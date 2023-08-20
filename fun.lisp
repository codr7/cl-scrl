(in-package ang)

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
  (return-pc (error "Missing return-pc") :type integer))

(defmethod call ((fun fun) pos return-pc)
  (let* ((i (- (length (vm-stack)) (length (fun-args fun))))
	 (args (subseq (vm-stack) i)))
    (setf (fill-pointer (vm-stack)) i)
    (let ((c (make-call :fun fun
			:pos pos
			:args args
			:return-pc return-pc)))
      (vm-push-call c)))
  (fun-pc fun))
