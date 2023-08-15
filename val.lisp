(in-package ang)

(defstruct val-type
  (name (error "Missing name") :type string))

(defmethod print-object ((typ val-type) out)  
  (write-string (val-type-name typ) out))

(defstruct val
  (type (error "Missing type") :type val-type)
  (data (error "Missing data")))

(defun new-val (typ dat)
  (make-val :type typ :data dat))

(defmethod val-emit (typ dat pos args env)
  (vm-emit (make-push-op :pos pos :val (new-val typ dat))))

(defmethod val-print (typ dat out)  
  (print-object dat out))

(defmethod val-true? (typ dat)  
  dat)

(defmethod print-object ((val val) out)  
  (val-print (val-type val) (val-data val) out))
