(in-package scrl)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defstruct op
  (pos nil :type (or null pos)))

(defstruct (bench-op (:include op))
  (reps (error "Missing reps") :type integer))

(defmethod print-object ((op bench-op) out)
  (format out "BENCH ~a" (bench-op-reps op)))

(define-symbol-macro +time-units-per-ms+ (/ internal-time-units-per-second 1000))

(defmethod op-compile ((op bench-op) pc)
  (lambda()
    (let ((start (get-internal-real-time))
	  (stack-length (length (vm-stack))))
      (dotimes (i (bench-op-reps op))
	(vm-eval (1+ pc))
	(setf (fill-pointer (vm-stack)) stack-length))
      (vm-push (new-val (num-type *abc-lib*)
			(round (/ (- (get-internal-real-time) start)
				  +time-units-per-ms+)))))
    (1+ (task-pc (vm-task *vm*)))))

(defstruct (call-op (:include op))
  (target (error "Missing target") :type t)
  (ret-pc (error "Missing ret-pc") :type integer))

(defmethod print-object ((op call-op) out)
  (format out "CALL ~a ~a" (call-op-target op) (call-op-ret-pc op)))

(defmethod op-compile ((op call-op) pc)
  (lambda()
    (let ((pc (call (call-op-target op) (op-pos op) (call-op-ret-pc op))))
      (vm-eval pc))))

(defstruct (fun-arg-op (:include op))
  (index (error "Missing index") :type integer))

(defmethod print-object ((op fun-arg-op) out)
  (format out "FUN-ARG ~a" (fun-arg-op-index op)))

(defmethod op-compile ((op fun-arg-op) pc)
  (lambda()
    (let ((c (vm-peek-call)))
      (unless c
	(error "No call in progress"))
      (let ((v (aref (call-args c)  (fun-arg-op-index op))))
	(vm-push (val-clone (val-type v) (val-data v)))))
    (vm-eval (1+ pc))))

(defstruct (goto-op (:include op))
  (pc (error "Missing pc") :type integer))

(defmethod print-object ((op goto-op) out)
  (format out "GOTO ~a" (goto-op-pc op)))

(defmethod op-compile ((op goto-op) pc)
  (lambda()
    (vm-eval (goto-op-pc op))))

(defstruct (if-op (:include op))
  (else-pc (error "Missing else-pc") :type integer))

(defmethod print-object ((op if-op) out)
  (format out "IF ~a" (if-op-else-pc op)))

(defmethod op-compile ((op if-op) pc)
  (lambda()
    (let ((v (vm-pop)))
      (vm-eval (if (val-true? (val-type v) (val-data v))
		   (1+ pc)
		   (if-op-else-pc op))))))

(defstruct (push-op (:include op))
  (val (error "Missing val") :type val))

(defmethod print-object ((op push-op) out)
  (format out "PUSH ~a" (push-op-val op)))

(defmethod op-compile ((op push-op) pc)
  (lambda ()
    (let ((v (push-op-val op)))
      (vm-push (val-clone (val-type v) (val-data v))))
    (vm-eval (1+ pc))))

(defstruct (ret-op (:include op)))

(defmethod print-object ((op ret-op) out)
  (format out "RET"))

(defmethod op-compile ((op ret-op) pc)
  (lambda()
    (let ((c (vm-pop-call)))
      (vm-eval (call-ret-pc c)))))

(defstruct (stop-op (:include op)))

(defmethod print-object ((op stop-op) out)
  (format out "STOP"))

(defmethod op-compile ((op stop-op) pc)
  (lambda ()))

(defstruct (tail-call-op (:include op))
  (target (error "Missing target") :type fun)
  (ret-pc (error "Missing ret-pc") :type integer))

(defmethod print-object ((op tail-call-op) out)
  (format out "TAIL-CALL ~a ~a" (tail-call-op-target op) (tail-call-op-ret-pc op)))

(defmethod op-compile ((op tail-call-op) pc)
  (lambda()
    (let ((pc (tail-call (tail-call-op-target op) (op-pos op) (tail-call-op-ret-pc op))))
      (vm-eval pc))))
