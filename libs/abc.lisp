(in-package ang)

(defstruct (bool-type (:include val-type)))

(defmethod val-print ((typ bool-type) dat out)  
  (format out "~a" (if dat #\T #\F)))

(defstruct (macro-type (:include val-type)))

(defmethod val-emit ((typ macro-type) dat pos args env)
  (emit dat pos args env))

(defmethod val-print ((typ macro-type) dat out)  
  (format out "Macro(~a ~a)" (macro-name dat) (macro-nargs dat)))

(defstruct (prim-type (:include val-type)))

(defmethod val-emit ((typ prim-type) dat pos args env)
  (vm-emit (make-call-op :pos pos :target dat :ret-pc (1+ (vm-emit-pc)))))

(defmethod val-print ((typ prim-type) dat out)  
  (format out "Prim(~a ~a)" (prim-name dat) (prim-nargs dat)))

(defstruct (abc-lib (:include lib) (:conc-name nil))
  (bool-type (make-bool-type :name "Bool"))
  (meta-type (make-val-type :name "Meta"))
  (macro-type (make-macro-type :name "Macro"))
  (num-type (make-val-type :name "Num"))
  (prim-type (make-prim-type :name "Prim")))

(defun new-abc-lib ()
  (let ((lib (make-abc-lib :name "abc")))
    (env-set lib "Bool" (new-val (meta-type lib) (bool-type lib)))
    (env-set lib "Meta" (new-val (meta-type lib) (meta-type lib)))
    (env-set lib "Macro" (new-val (meta-type lib) (macro-type lib)))
    (env-set lib "Num" (new-val (meta-type lib) (num-type lib)))
    (env-set lib "Prim" (new-val (meta-type lib) (prim-type lib)))  

    (env-set lib "T" (new-val (bool-type lib) t))
    (env-set lib "F" (new-val (bool-type lib) nil))
    
    (env-set lib "if"
	     (new-val (macro-type lib)
		      (new-macro "if" 2 (lambda (macro pos args env)
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
						       :pc if-pc)))))))

    (env-set lib "+"
	     (new-val (prim-type lib)
		      (new-prim "+" 2 (lambda (prim ret_pc)
					(declare (ignore prim))
					(let ((y (vm-pop))
					      (x (vm-peek)))
					  (setf (val-data x) (+ (val-data x) (val-data y))))
					ret_pc))))

    (env-set lib "-"
	     (new-val (prim-type lib)
		      (new-prim "-" 2 (lambda (prim ret_pc)
					(declare (ignore prim))
					(let ((y (vm-pop))
					      (x (vm-peek)))
					  (setf (val-data x) (- (val-data x) (val-data y))))
					ret_pc))))

    (env-set lib "<"
	     (new-val (prim-type lib)
		      (new-prim "<" 2 (lambda (prim ret_pc)
					(declare (ignore prim))
					(let ((y (vm-pop))
					      (x (vm-peek)))
					     (setf (val-data x) (< (val-data x) (val-data y))
						   (val-type x) (bool-type lib)))
					ret_pc))))

    (env-set lib "type"
	     (new-val (prim-type lib)
		      (new-prim "type" 1 (lambda (prim ret_pc)
					   (declare (ignore prim))
					   (let ((x (vm-peek)))
					     (setf (val-data x) (val-type x)
						   (val-type x) (meta-type lib)))
					   ret_pc))))

    lib))

(defvar *abc-lib* (new-abc-lib))
