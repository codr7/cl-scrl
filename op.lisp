(in-package ang)

(defstruct op
  (pos nil :type (or null pos)))

(defstruct (call-op (:include op))
  (target (error "Missing target") :type t)
  (ret-pc (error "Missing ret-pc") :type integer))

(defmethod op-emit ((op call-op) pc)
  (lambda()
    (let ((pc (call (call-op-target op) (call-op-ret-pc op))))
      (vm-eval pc))))

(defstruct (push-op (:include op))
  (val (error "Missing val") :type val))

(defmethod op-emit ((op push-op) pc)
  (lambda ()
    (vm-push (push-op-val op))
    (vm-eval (1+ pc))))

(defstruct (stop-op (:include op)))

(defmethod op-emit ((op stop-op) pc)
  (lambda ()))
