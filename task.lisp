(in-package scrl)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defstruct task
  (stdin *standard-input* :type stream)
  (stdout *standard-output* :type stream)
  (trace? nil :type boolean)
  (pc 0 :type fixnum)
  (env (make-env) :type env)
  (stack (make-array 0 :element-type 'val :fill-pointer 0) :type (array val))
  (calls (make-array 0 :element-type 'call :fill-pointer 0) :type (array call)))

(defun task-get (task key)
  (env-get (task-env task) key))

(defun task-set (task key val)
  (env-set (task-env task) key val))

(defun (setf task-get) (val task key)
  (task-set task key val))

(defun task-push (task val)
  (vector-push-extend val (task-stack task)))

(defun task-pop (task)
  (vector-pop (task-stack task)))

(defun task-peek (task &key index)
  (with-slots (stack) task
    (aref stack (or index (1- (length stack))))))

(defun task-dump-stack (task &key (out *standard-output*))
  (with-slots (stack stdout) task
    (write-char #\[ out)
    
    (dotimes (i (length stack))
      (unless (zerop i)
	(write-char #\space out))
      (print-object (aref stack i) out))

    (write-char #\] out)))

(defun task-push-call (task call)
  (vector-push-extend call (task-calls task)))

(defun task-pop-call (task)
  (vector-pop (task-calls task)))

(defun task-peek-call (task)
  (with-slots (calls) task
    (aref calls (1- (length calls)))))
