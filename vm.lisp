(in-package ang)

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

(defun vm-get (key)
  (task-get (vm-task *vm*) key))

(defun vm-set (key val)
  (task-set (vm-task *vm*) key val))

(defun (setf vm-get) (val key)
  (vm-set key val))

(defun vm-push (val)
  (task-push val (vm-task *vm*)))

(defun vm-pop ()
  (task-pop (vm-task *vm*)))

(defun vm-peek ()
  (task-peek (vm-task *vm*)))

(defun vm-dump-stack (&optional out)
  (task-dump-stack (vm-task *vm*) out))

(defun vm-emit (op &key pc)
  (with-slots (ops1) *vm*
    (if pc
	(setf (aref ops1 pc) op)
	(vector-push-extend op ops1))))

(defun vm-emit-pc ()
  (length (vm-ops1 *vm*)))

(defun vm-compile (pc)
  (with-slots (ops1 ops2) *vm*
    (adjust-array ops2 pc)
    (while (< pc (length ops1))
      (vector-push-extend (op-compile (aref ops1 pc) pc) ops2)
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
