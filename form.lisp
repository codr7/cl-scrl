(in-package ang)

(defstruct form
  (pos (error "Missing pos") :type pos))

(defstruct (id-form (:include form))
  (name (error "Missing name") :type string))

(defmethod print-object ((form id-form) out)
  (write-string (id-form-name form) out))

(defmethod form-emit ((form id-form) args env)
  (let* ((n (id-form-name form))
	 (v (vm-get n)))
    (unless v
      (error "Unknown: '~a'" n))
    (val-emit (val-type v) (val-data v) (form-pos form) args env)))

(defstruct (lit-form (:include form))
  (val (error "Missing val") :type val))

(defmethod print-object ((form lit-form) out)
  (print-object (lit-form-val form) out))

(defmethod form-emit ((form lit-form) args env)
  (vm-emit (make-push-op :pos (form-pos form) :val (lit-form-val form))))
