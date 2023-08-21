(in-package scrl)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defvar *emit-fun* nil)

(defstruct fun
  (name (error "Missing name") :type symbol)
  (args (error "Missing args") :type list)
  (pc (error "Missing pc") :type integer))

(defmethod print-object ((fun fun) out)
  (format out "Fun(~a ~a)" (fun-name fun) (fun-args fun)))

(defstruct call
  (fun (error "Missing fun") :type fun)
  (pos (error "Missing pos") :type pos)
  (args (error "Missing args") :type (array val))
  (ret-pc (error "Missing ret-pc") :type integer))

(defun vm-fun-args (fun)
  (let* ((s (vm-stack))
	 (i (- (length s) (length (fun-args fun))))
	 (args (subseq s i)))
    (setf (fill-pointer s) i)
    args))

(defmethod call ((fun fun) pos ret-pc)
  (let ((c (make-call :fun fun
		      :pos pos
		      :args (vm-fun-args fun)
		      :ret-pc ret-pc)))
    (vm-push-call c))

  (fun-pc fun))

(defun tail-call (fun pos ret-pc)
  (let ((c (vm-peek-call)))
    (setf (call-fun c) fun
	  (call-pos c) pos
	  (call-args c) (vm-fun-args fun)))
  
  (fun-pc fun))
