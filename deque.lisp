(in-package ang)

(defstruct deque 
  (head (error "Missing head") :type list)
  (tail (error "Missing tail")  :type list)
  (len (error "Missing len") :type fixnum))

(defun new-deque (&rest in)
  (let ((in2 (cons nil in)))
    (make-deque :head in2 :tail (last in2) :len (length in))))

(defun push-back (val deque)
  (with-slots (tail) deque
    (setf tail (push val (rest tail)))
    (incf (deque-len deque))
  deque))

(defun pop-front (deque)
  (with-slots (head tail) deque
    (let ((v (pop (rest head))))
      (when (zerop (decf (deque-len deque)))
	(setf tail head))
      v)))

(defmethod len ((deque deque))
  (deque-len deque))

(defmethod print-object ((deque deque) out)
  (print-object (rest (deque-head deque)) out))
