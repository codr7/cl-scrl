(in-package scrl)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defvar *vm*)

(defmacro with-vm ((&rest args) &body body)
  `(let ((*vm* (make-vm ,@args)))
     ,@body))

(defstruct vm
  (ops1 (make-array 0 :element-type 'op :fill-pointer 0) :type (array op))
  (ops2 (make-array 0 :element-type 'function :fill-pointer 0) :type (array function))
  (task (make-task :env (make-env :parent *abc-lib*)) :type task))

(defun vm-stdin ()
  (task-stdin (vm-task *vm*)))

(defun vm-stdout ()
  (task-stdout (vm-task *vm*)))

(defun vm-trace? ()
  (task-trace? (vm-task *vm*)))

(defun (setf vm-trace?) (val)
  (setf (task-trace? (vm-task *vm*)) val))

(defun vm-get (key)
  (task-get (vm-task *vm*) key))

(defun vm-set (key val)
  (task-set (vm-task *vm*) key val))

(defun (setf vm-get) (val key)
  (vm-set key val))

(defun vm-stack ()
  (task-stack (vm-task *vm*)))

(defun vm-push (val)
  (task-push (vm-task *vm*) val))

(defun vm-pop ()
  (task-pop (vm-task *vm*)))

(defun vm-peek (&key index)
  (task-peek (vm-task *vm*) :index index))

(defun vm-dump-stack (&key (out *standard-output*))
  (task-dump-stack (vm-task *vm*) :out out))

(defun vm-push-call (call)
  (task-push-call (vm-task *vm*) call))

(defun vm-peek-call ()
  (task-peek-call (vm-task *vm*)))

(defun vm-pop-call ()
  (task-pop-call (vm-task *vm*)))

(defun vm-emit (op &key pc)
  (with-slots (ops1) *vm*
    (if pc
	(setf (aref ops1 pc) op)
	(vector-push-extend op ops1))))

(defun vm-emit-pc ()
  (length (vm-ops1 *vm*)))

(defun vm-op (pc)
  (aref (vm-ops1 *vm*) pc))

(defun vm-compile (pc)
  (with-slots (ops1 ops2) *vm*
    (adjust-array ops2 pc)
    (while (< pc (length ops1))
      (let* ((op1 (aref ops1 pc))
	     (op2 (op-compile op1 pc)))
	(vector-push-extend (if (vm-trace?)
				(let ((pc2 pc))
				  (lambda ()
				    (format t "~a ~a~%" pc2 op1) 
				    (funcall op2)))
				op2)
			    ops2))
      (incf pc))))

(defun vm-eval (pc)
  (with-slots (ops2) *vm*
    (setf (task-pc (vm-task *vm*)) pc)
    (funcall (aref ops2 pc))))

(defun emit-forms (forms)
  (while (not (zerop (len forms)))
    (form-emit (pop-front forms) forms (task-env (vm-task *vm*)))))

(defun eval-string (code &key (pos (new-pos "eval")))
  (let ((pc (vm-emit-pc))
	(fs (read-forms (make-string-input-stream code) pos (new-deque))))
    (emit-forms fs)
    (vm-emit (make-stop-op))
    (vm-compile pc)
    (vm-eval pc)))
