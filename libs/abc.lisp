(in-package ang)

(defstruct (bool-type (:include val-type)))

(defmethod val-print ((typ bool-type) dat out)  
  (format out "~a" (if dat #\T #\F)))

(defstruct (prim-type (:include val-type)))

(defmethod val-emit ((typ prim-type) dat pos args env)
  (vm-emit (make-call-op :pos pos :target dat :ret-pc (1+ (vm-emit-pc)))))

(defmethod val-print ((typ prim-type) dat out)  
  (format out "Prim(~a ~a)" (prim-name dat) (prim-nargs dat)))

(defstruct (abc-lib (:include lib) (:conc-name nil))
  (bool-type (make-bool-type :name "Bool"))
  (meta-type (make-val-type :name "Meta"))
  (num-type (make-val-type :name "Num"))
  (prim-type (make-prim-type :name "Prim")))

(defun new-abc-lib ()
  (let ((lib (make-abc-lib :name "abc")))
    (env-set lib "Bool" (new-val (meta-type lib) (bool-type lib)))
    (env-set lib "Meta" (new-val (meta-type lib) (meta-type lib)))
    (env-set lib "Num" (new-val (meta-type lib) (num-type lib)))
    (env-set lib "Prim" (new-val (meta-type lib) (prim-type lib)))  

    (env-set lib "T" (new-val (bool-type lib) t))
    (env-set lib "F" (new-val (bool-type lib) nil))
    
    (env-set lib "+"
	     (new-val (prim-type lib)
		      (new-prim "+" 2 (lambda (prim ret_pc)
					(declare (ignore prim))
					(let ((y (vm-pop))
					      (x (vm-peek)))
					  (setf (val-data x) (+ (val-data x) (val-data y))))
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
