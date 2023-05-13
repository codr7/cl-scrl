(in-package lang)

(defvar *vm*)

(defstruct vm
  (ops (make-array 0 :element-type 'function :fill-pointer 0)  :type (array function))
  (task (make-task) :type task)
  (stack (make-array 0 :element-type 'val :fill-pointer 0) :type (array val)))

(defun vm-emit (op &key (vm *vm*))
  (with-slots (ops) vm
    (vector-push-extend (op-emit op (length ops) :vm vm) ops)))

(defun vm-push (val &key (vm *vm*))
  (task-push val (vm-task vm)))

(defun vm-pop (&key (vm *vm*))
  (task-pop (vm-task vm)))

(defun vm-peek (&key (vm *vm*))
  (task-peek (vm-task vm)))

(defun vm-eval (pc &key (vm *vm*))
  (with-slots (ops) vm
    (setf (task-pc (vm-task vm)) pc)
    (funcall (aref ops pc))))
