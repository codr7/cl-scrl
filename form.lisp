(in-package ang)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defstruct form
  (pos (error "Missing pos") :type pos))

(defstruct (id-form (:include form))
  (name (error "Missing name") :type symbol))

(defmethod print-object ((form id-form) out)
  (write-string (symbol-name (id-form-name form)) out))

(defmethod form-emit ((form id-form) args env)
  (let ((n (id-form-name form)))
    (when *emit-fun*
      (let ((i (position n (fun-args *emit-fun*))))
	(when i
	  (vm-emit (make-fun-arg-op :pos (form-pos form) :index i))
	  (return-from form-emit))))

    (let ((v (vm-get n)))
      (unless v
	(error "Unknown: '~a'" n))
      (val-emit (val-type v) (val-data v) (form-pos form) args env))))

(defstruct (list-form (:include form))
  (body (error "Missing body") :type list))

(defmethod print-object ((form list-form) out)
  (print-object (list-form-body form) out))

(defmethod form-emit ((form list-form) args env)
  (dolist (f (list-form-body form))
    (form-emit f args env)))

(defstruct (lit-form (:include form))
  (val (error "Missing val") :type val))

(defmethod print-object ((form lit-form) out)
  (print-object (lit-form-val form) out))

(defmethod form-emit ((form lit-form) args env)
  (vm-emit (make-push-op :pos (form-pos form) :val (lit-form-val form))))
