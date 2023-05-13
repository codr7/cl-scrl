(in-package lang)

(defstruct val-type
  (name (error "Missing name") :type keyword))

(defstruct val
  (type (error "Missing type") :type val-type)
  (data (error "Missing data")))

(defun val-dump (val out)
  (print-object (val-data val) out))
