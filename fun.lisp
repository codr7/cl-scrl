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

(defmethod call ((fun fun) pos ret-pc)
  (let* ((i (- (length (vm-stack)) (length (fun-args fun))))
	 (args (subseq (vm-stack) i)))
    (setf (fill-pointer (vm-stack)) i)
  
    (let ((c (make-call :fun fun
			:pos pos
			:args args
			:ret-pc ret-pc)))
      (vm-push-call c)))
    
    (fun-pc fun))

(defun tail-call (fun pos ret-pc)
  (let* ((i (- (length (vm-stack)) (length (fun-args fun))))
	 (args (subseq (vm-stack) i)))
    (setf (fill-pointer (vm-stack)) i)

    (let ((c (vm-peek-call)))
      (setf (call-fun c) fun)
      (setf (call-pos c) pos)
      (setf (call-args c) args)))

  (fun-pc fun))
