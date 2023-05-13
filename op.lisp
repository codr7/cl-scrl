(in-package ang)

(defstruct op)

(defstruct (add-op (:include op)))

(defmethod op-emit ((op add-op) pc &key (vm *vm*))
  (lambda ()
    (let ((y (vm-pop :vm vm))
	  (x (vm-peek :vm vm)))
      (setf (val-data x) (+ (val-data x) (val-data y))))
    (vm-eval (1+ pc) :vm vm)))

(defstruct (push-op (:include op))
  (val (error "Missing val")))

(defmethod op-emit ((op push-op) pc &key (vm *vm*))
  (lambda ()
    (vm-push (push-op-val op) :vm vm)
    (vm-eval (1+ pc) :vm vm)))

(defstruct (stop-op (:include op)))

(defmethod op-emit ((op stop-op) pc &key (vm *vm*))
  (declare (ignore vm))
  (lambda ()))
