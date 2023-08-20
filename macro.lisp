(in-package ang)

(defstruct macro
  (name (error "Missing name") :type symbol)
  (nargs (error "Missing nargs") :type integer)
  (body (error "Missing body") :type function))

(defun new-macro (name nargs body)
  (make-macro :name name :nargs nargs :body body))

(defmethod emit ((macro macro) pos args env)
  (funcall (macro-body macro) macro pos args env))

(defmethod print-object ((macro macro) out)
  (format out "Macro(~a ~a)" (macro-name macro) (macro-nargs macro)))
