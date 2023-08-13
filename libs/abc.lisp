(in-package ang)

(defstruct (prim-type (:include val-type)))

(defmethod val-emit ((typ prim-type) dat pos args env)
  (vm-emit (make-call-op :pos pos :target dat :ret-pc (1+ (vm-emit-pc)))))

(defstruct (abc-lib (:include lib) (:conc-name nil))
  (bool-type (make-val-type :name "Bool"))
  (meta-type (make-val-type :name "Meta"))
  (num-type (make-val-type :name "Num"))
  (prim-type (make-prim-type :name "Prim")))

(defun new-abc-lib ()
  (let ((lib (make-abc-lib :name "abc")))
    (env-set lib "Bool" (new-val (meta-type lib) (bool-type lib)))
    (env-set lib "Meta" (new-val (meta-type lib) (meta-type lib)))
    (env-set lib "Num" (new-val (meta-type lib) (num-type lib)))
    (env-set lib "Prim" (new-val (meta-type lib) (prim-type lib)))
    
    (env-set lib "+"
	     (new-val (prim-type lib)
		      (new-prim "+" 2 (lambda (prim ret_pc)
					(declare (ignore prim))
					(let ((y (vm-pop))
					      (x (vm-peek)))
					  (setf (val-data x) (+ (val-data x) (val-data y))))
					ret_pc))))
    lib))

(defvar *abc-lib* (new-abc-lib))
