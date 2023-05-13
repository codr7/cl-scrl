(in-package lang)

(defvar *vm*)

(defstruct vm
  (ops (make-array 0 :element-type 'function :fill-pointer 0)  :type (array function))
  (stack (make-array 0 :element-type 'val :fill-pointer 0) :type (array val)))

(defun vm-emit (op &key (vm *vm*))
  (with-slots (ops) vm
    (vector-push-extend (op-emit op (length ops) :vm vm) ops)))

(defun vm-push (val &key (vm *vm*))
  (vector-push-extend val (vm-stack vm)))

(defun vm-pop (&key (vm *vm*))
  (vector-pop (vm-stack vm)))

(defun vm-peek (&key (vm *vm*))
  (with-slots (stack) vm
    (aref stack (1- (length stack)))))

(defun vm-eval (pc &key (vm *vm*))
  (with-slots (ops) vm
    (let ((op (aref ops pc)))
      (funcall op))))
