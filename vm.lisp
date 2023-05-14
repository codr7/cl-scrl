(in-package ang)

(defvar *vm*)

(defmacro with-vm ((&rest args) &body body)
  `(let ((*vm* (make-vm ,@args)))
     ,@body))

(defstruct vm
  (ops (make-array 0 :element-type 'function :fill-pointer 0) :type (array function))
  (task (make-task) :type task))

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

(defun vm-pop (&key)
  (task-pop (vm-task *vm*)))

(defun vm-peek (&key)
  (task-peek (vm-task *vm*)))

(defun vm-dump-stack (out &key (vm *vm*))
  (task-dump-stack (vm-task vm) out))

(defun vm-emit (op &key)
  (with-slots (ops) *vm*
    (vector-push-extend (op-emit op (length ops)) ops)))

(defun vm-emit-pc (&key)
  (length (vm-ops *vm*)))

(defun vm-eval (pc &key)
  (with-slots (ops) *vm*
    (setf (task-pc (vm-task *vm*)) pc)
    (funcall (aref ops pc))))
