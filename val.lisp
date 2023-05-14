(in-package ang)

(defstruct val-type
  (name (error "Missing name") :type string))

(defstruct val
  (type (error "Missing type") :type val-type)
  (data (error "Missing data")))

(defmethod print-object ((val val) out)
  (print-object (val-data val) out))
