(in-package lang)

(defstruct task
  (pc 0 :type fixnum)
  (stack (make-array 0 :element-type 'val :fill-pointer 0) :type (array val)))

(defun task-push (val task)
  (vector-push-extend val (task-stack task)))

(defun task-pop (task)
  (vector-pop (task-stack task)))

(defun task-peek (task)
  (with-slots (stack) task
    (aref stack (1- (length stack)))))
