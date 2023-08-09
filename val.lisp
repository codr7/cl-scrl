(in-package ang)

(defstruct val-type
  (name (error "Missing name") :type string))

(defstruct val
  (type (error "Missing type") :type val-type)
  (data (error "Missing data")))

(defun new-val (typ dat)
  (make-val :type typ :data dat))

(defmethod print-object ((val val) out)  
  (print-object (val-data val) out))

(defmethod val-emit (typ dat pos args env)
  (vm-emit (make-push-op :pos pos :val (new-val typ dat))))
