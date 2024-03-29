(in-package scrl)

(declaim (optimize (safety 0) (debug 3) (speed 3)))

(defstruct (bool-type (:include val-type)))

(defmethod val-print ((typ bool-type) dat out)  
  (format out "~a" (if dat #\T #\F)))

(defstruct (fun-type (:include val-type)))

(defmethod val-emit ((typ fun-type) dat pos args env)
  (dotimes (i (length (fun-args dat)))
    (form-emit (pop-front args) args env))
  (let ((ret-pc (1+ (vm-emit-pc))))
    (if *ret*
	(vm-emit (make-tail-call-op :pos pos :target dat :ret-pc ret-pc))
	(vm-emit (make-call-op :pos pos :target dat :ret-pc ret-pc)))))

(defstruct (macro-type (:include val-type)))

(defmethod val-emit ((typ macro-type) dat pos args env)
  (emit dat pos args env))

(defstruct (num-type (:include val-type)))

(defmethod val= ((typ num-type) x rhs)
  (let ((y (val-data rhs)))
    (declare (type number x y))
    (= x y)))

(defstruct (prim-type (:include val-type)))

(defmethod val-emit ((typ prim-type) dat pos args env)
  (dotimes (i (prim-nargs dat))
    (form-emit (pop-front args) args env))
  (vm-emit (make-call-op :pos pos :target dat :ret-pc (1+ (vm-emit-pc)))))

(defstruct (abc-lib (:include lib) (:conc-name nil))
  (bool-type (make-bool-type :name :|Bool|))
  (fun-type (make-fun-type :name :|Fun|))
  (meta-type (make-val-type :name :|Meta|))
  (macro-type (make-macro-type :name :|Macro|))
  (num-type (make-num-type :name :|Num|))
  (prim-type (make-prim-type :name :|Prim|)))

(defun new-abc-lib ()
  (let* ((lib (make-abc-lib :name "abc"))
	 (*macro-type* (macro-type lib))
	 (*prim-type* (prim-type lib)))
    (env-set-val lib :|Bool| (meta-type lib) (bool-type lib))
    (env-set-val lib :|Meta| (meta-type lib) (meta-type lib))
    (env-set-val lib :|Macro| (meta-type lib) (macro-type lib))
    (env-set-val lib :|Num| (meta-type lib) (num-type lib))
    (env-set-val lib :|Prim| (meta-type lib) (prim-type lib))

    (env-set-val lib :|T| (bool-type lib) t)
    (env-set-val lib :|F| (bool-type lib) nil)

    (env-set-macro lib :|bench| 2 (lambda (macro pos args env)
				    (declare (ignore macro))
				    (let ((reps (lit-form-val (pop-front args))))
				      (unless (eq (val-type reps) (num-type *abc-lib*))
					(error "Invalid reps: ~a" reps))
				      (vm-emit (make-bench-op :pos pos :reps (val-data reps))))
				    (form-emit (pop-front args) args env)
				    (vm-emit (make-stop-op :pos pos))))
    
    (env-set-macro lib :|fun| 3 (lambda (macro pos args env)
				  (declare (ignore macro))
				  (let ((goto-pc (vm-emit-pc)))
				    (vm-emit nil)
				    
				    (let (name
					  fargs
					  (arg (pop-front args)))
				      (ecase (type-of arg)
					('list-form
					 (setf fargs arg))
					('id-form
					 (setf name (id-form-name arg))
					 (setf fargs (pop-front args))))
				      
				      (let ((*emit-fun*
					      (make-fun :name name
							:args (mapcar #'id-form-name
								      (list-form-body fargs))
							:pc (vm-emit-pc))))
					(env-set env name (new-val (fun-type lib) *emit-fun*))
					(form-emit (pop-front args) args env)
					(vm-emit (make-ret-op :pos pos))
					(vm-emit (make-goto-op :pos pos :pc (vm-emit-pc))
						 :pc goto-pc))))))
    
    (env-set-macro lib :|if| 2 (lambda (macro pos args env)
				 (declare (ignore macro))
				 (form-emit (pop-front args) args env)
				 (let ((if-pc (vm-emit nil)))
				   (form-emit (pop-front args) args env)
				   (let ((else-pc (vm-emit-pc))
					 (f (peek-front args)))
				     (when (and f
						(eq (type-of f) 'id-form)
						(string= (id-form-name f) "else"))
				       (pop-front args)
				       (let ((goto-pc (vm-emit-pc)))
					 (vm-emit nil)
					 (setf else-pc (vm-emit-pc))
					 (form-emit (pop-front args) args env)
					 (vm-emit (make-goto-op :pos pos :pc (vm-emit-pc))
						  :pc goto-pc)))
				     
				     (vm-emit (make-if-op :pos pos :else-pc else-pc)
					      :pc if-pc)))))

    (env-set-macro lib :|ret| 1 (lambda (macro pos args env)
				  (declare (ignore macro))
				  (let ((*ret* t))
				    (form-emit (pop-front args) args env))
				  (vm-emit (make-ret-op :pos pos))))
    
    (env-set-prim lib :|+| 2 (lambda (prim pos ret_pc)
			       (declare (ignore prim))
			       (let ((y (vm-pop))
				     (x (vm-peek)))
				 (setf (val-data x) (+ (val-data x) (val-data y))))
			       ret_pc))

    (env-set-prim lib :|inc| 1 (lambda (prim pos ret_pc)
				 (declare (ignore prim))
				 (incf (val-data (vm-peek)))
				 ret_pc))
    
    (env-set-prim lib :|-| 2 (lambda (prim pos ret_pc)
			       (declare (ignore prim))
			       (let ((y (vm-pop))
				     (x (vm-peek)))
				 (setf (val-data x) (- (val-data x) (val-data y))))
			       ret_pc))

    (env-set-prim lib :|dec| 1 (lambda (prim pos ret_pc)
				 (declare (ignore prim))
				 (decf (val-data (vm-peek)))
				 ret_pc))

    (env-set-prim lib :|=| 2 (lambda (prim pos ret_pc)
			       (declare (ignore prim))
			       (let ((y (vm-pop))
				     (x (vm-peek)))
				 (setf (val-data x) (val= (val-type x) (val-data x) y)
				       (val-type x) (bool-type lib)))
			       ret_pc))

    (env-set-prim lib :|<| 2 (lambda (prim pos ret_pc)
			       (declare (ignore prim))
			       (let ((y (vm-pop))
				     (x (vm-peek)))
				 (setf (val-data x) (< (val-data x) (val-data y))
				       (val-type x) (bool-type lib)))
			       ret_pc))
    
    (env-set-prim lib :|>| 2 (lambda (prim pos ret_pc)
			       (declare (ignore prim))
			       (let ((y (vm-pop))
				     (x (vm-peek)))
				 (setf (val-data x) (> (val-data x) (val-data y))
				       (val-type x) (bool-type lib)))
			       ret_pc))

    (env-set-prim lib :|z?| 1 (lambda (prim pos ret_pc)
				(declare (ignore prim))
				(let ((x (vm-peek)))
				  (setf (val-data x) (zerop (val-data x))
					(val-type x) (bool-type lib)))
				ret_pc))

    (env-set-prim lib :|trace| 0 (lambda (prim pos ret_pc)
				   (declare (ignore prim))
				   (let ((enabled? (not (vm-trace?))))
				     (setf (vm-trace?) enabled?)
				     (vm-push (new-val (bool-type lib) enabled?)))
				   ret_pc))

    (env-set-prim lib :|type-of| 1 (lambda (prim pos ret_pc)
				     (declare (ignore prim))
				     (let ((x (vm-peek)))
				       (setf (val-data x) (val-type x)
					     (val-type x) (meta-type lib)))
				     ret_pc))

    lib))

(defvar *abc-lib* (new-abc-lib))
