(in-package lang)

(defstruct task
  (stdin *standard-input* :type stream)
  (stdout *standard-output* :type stream)
  (pc 0 :type fixnum)
  (stack (make-array 0 :element-type 'val :fill-pointer 0) :type (array val)))

(defun task-push (val task)
  (vector-push-extend val (task-stack task)))

(defun task-pop (task)
  (vector-pop (task-stack task)))

(defun task-peek (task)
  (with-slots (stack) task
    (aref stack (1- (length stack)))))

(defun task-dump-stack (task out)
  (with-slots (stack stdout) task
    (write-char #\[ out)
    
    (dotimes (i (length stack))
      (unless (zerop i)
	(write-char #\space out))
      (val-dump (aref stack i) out))

    (write-char #\] out)))
