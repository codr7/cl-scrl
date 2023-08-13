(in-package ang)

(defstruct prim
  (name (error "Missing name") :type string)
  (nargs (error "Missing nargs") :type integer)
  (body (error "Missing body") :type function))

(defun new-prim (name nargs body)
  (make-prim :name name :nargs nargs :body body))

(defmethod call ((prim prim) ret_pc)
  (funcall (prim-body prim) prim ret_pc))
