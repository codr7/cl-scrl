(in-package ang)

(defstruct op
  (pos nil :type (or null pos)))

(defstruct (call-op (:include op))
  (target (error "Missing target") :type t)
  (ret-pc (error "Missing ret-pc") :type integer))

(defmethod op-compile ((op call-op) pc)
  (lambda()
    (let ((pc (call (call-op-target op) (call-op-ret-pc op))))
      (vm-eval pc))))

(defstruct (goto-op (:include op))
  (pc (error "Missing pc") :type integer))

(defmethod op-compile ((op goto-op) pc)
  (lambda()
    (vm-eval (goto-op-pc op))))

(defstruct (if-op (:include op))
  (else-pc (error "Missing else-pc") :type integer))

(defmethod op-compile ((op if-op) pc)
  (lambda()
    (let ((v (vm-pop)))
      (vm-eval (if (val-true? (val-type v) (val-data v))
		   (1+ pc)
		   (if-op-else-pc op))))))

(defstruct (push-op (:include op))
  (val (error "Missing val") :type val))

(defmethod op-compile ((op push-op) pc)
  (lambda ()
    (vm-push (push-op-val op))
    (vm-eval (1+ pc))))

(defstruct (stop-op (:include op)))

(defmethod op-compile ((op stop-op) pc)
  (lambda ()))
