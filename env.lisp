(in-package ang)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defstruct env
  (parent nil :type (or null env))
  (bindings (make-hash-table) :type hash-table))

(defun env-get (env key)
  (let ((v (gethash key (env-bindings env))))
    (or v (with-slots (parent) env (and parent (env-get parent key))))))

(defun env-set (env key val)
  (setf (gethash key (env-bindings env)) val))

(defun (setf env-get) (val env key)
  (env-set env key val))

(defun env-set-macro (env name nargs body)
  (env-set env name (new-val *macro-type* (new-macro name nargs body))))

(defun env-set-prim (env name nargs body)
  (env-set env name (new-val *prim-type* (new-prim name nargs body))))

(defun env-set-val (env key typ dat)
  (env-set env key (new-val typ dat)))
