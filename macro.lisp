(in-package ang)

(defstruct macro
  (name (error "Missing name") :type string)
  (nargs (error "Missing nargs") :type integer)
  (body (error "Missing body") :type function))

(defun new-macro (name nargs body)
  (make-macro :name name :nargs nargs :body body))

(defmethod emit ((macro macro) pos args env)
  (funcall (macro-body macro) macro pos args env))
