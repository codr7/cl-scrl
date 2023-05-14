(in-package ang)

(defstruct (lib (:include env))
  (name (error "Missing name") :type string))
