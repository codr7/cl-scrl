(in-package ang)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defstruct prim
  (name (error "Missing name") :type symbol)
  (nargs (error "Missing nargs") :type integer)
  (body (error "Missing body") :type function))

(defun new-prim (name nargs body)
  (make-prim :name name :nargs nargs :body body))

(defmethod call ((prim prim) pos return-pc)
  (funcall (prim-body prim) prim pos return-pc))

(defmethod print-object ((prim prim) out)
  (format out "Prim(~a ~a)" (prim-name prim) (prim-nargs prim)))

