(in-package ang)

(defstruct prim
  (name (error "Missing name") :type string)
  (nargs (error "Missing nargs") :type integer)
  (body (error "Missing body") :type function))

(defun new-prim (name nargs body)
  (make-prim :name name :nargs nargs :body body))

(defmethod print-object ((val prim) out)
  (format out "Prim(~a ~a)" (prim-name val) (prim-nargs val)))

(defmethod call ((prim prim) ret_pc)
  (funcall (prim-body prim) prim ret_pc))
