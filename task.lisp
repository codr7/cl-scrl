(in-package ang)

(defstruct task
  (stdin *standard-input* :type stream)
  (stdout *standard-output* :type stream)
  (pc 0 :type fixnum)
  (env (make-env) :type env)
  (stack (make-array 0 :element-type 'val :fill-pointer 0) :type (array val)))

(defun task-get (task key)
  (env-get (task-env task) key))

(defun task-set (task key val)
  (env-set (task-env task) key val))

(defun (setf task-get) (val task key)
  (task-set task key val))

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
      (print-object (aref stack i) out))

    (write-char #\] out)))
