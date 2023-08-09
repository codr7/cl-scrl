(in-package ang)

(defstruct deque 
  (head (error "Missing head") :type list)
  (tail (error "Missing tail")  :type list)
  (len (error "Missing len") :type fixnum))

(defun new-deque (&rest in)
  (let ((in2 (cons nil in)))
    (make-deque :head in2 :tail (last in2) :len (length in))))

(defun deque-items (q)
  (rest (deque-head q)))

(defun push-back (val q)
  (with-slots (tail) q
    (setf tail (push val (rest tail)))
    (incf (deque-len q))
  q))

(defun pop-front (q)
  (with-slots (head tail) q
    (let ((v (pop (rest head))))
      (when (zerop (decf (deque-len q)))
	(setf tail head))
      v)))

(defmethod len ((q deque))
  (deque-len q))

(defmethod print-object ((q deque) out)
  (print-object (rest (deque-head q)) out))
