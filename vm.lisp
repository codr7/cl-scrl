(in-package ang)

(defvar *vm*)

(defmacro with-vm ((&rest args) &body body)
  `(let ((*vm* (make-vm ,@args)))
     ,@body))

(defstruct vm
  (ops (make-array 0 :element-type 'function :fill-pointer 0)  :type (array function))
  (task (make-task) :type task))

(defun vm-stdin (&key (vm *vm*))
  (task-stdin (vm-task vm)))

(defun vm-stdout (&key (vm *vm*))
  (task-stdout (vm-task vm)))

(defun vm-push (val &key (vm *vm*))
  (task-push val (vm-task vm)))

(defun vm-pop (&key (vm *vm*))
  (task-pop (vm-task vm)))

(defun vm-peek (&key (vm *vm*))
  (task-peek (vm-task vm)))

(defun vm-dump-stack (out &key (vm *vm*))
  (task-dump-stack (vm-task vm) out))

(defun vm-emit (op &key (vm *vm*))
  (with-slots (ops) vm
    (vector-push-extend (op-emit op (length ops) :vm vm) ops)))

(defun vm-emit-pc (&key (vm *vm*))
  (length (vm-ops vm)))

(defun vm-eval (pc &key (vm *vm*))
  (with-slots (ops) vm
    (setf (task-pc (vm-task vm)) pc)
    (funcall (aref ops pc))))
