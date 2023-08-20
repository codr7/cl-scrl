(in-package ang)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defstruct (lib (:include env))
  (name (error "Missing name") :type string))
