(in-package ang)

(defstruct op
  (pos nil :type (or null pos)))

(defstruct (add-op (:include op)))

(defmethod op-emit ((op add-op) pc)
  (lambda ()
    (let ((y (vm-pop))
	  (x (vm-peek)))
      (setf (val-data x) (+ (val-data x) (val-data y))))
    (vm-eval (1+ pc))))

(defstruct (push-op (:include op))
  (val (error "Missing val")))

(defmethod op-emit ((op push-op) pc)
  (lambda ()
    (vm-push (push-op-val op))
    (vm-eval (1+ pc))))

(defstruct (stop-op (:include op)))

(defmethod op-emit ((op stop-op) pc)
  (lambda ()))
