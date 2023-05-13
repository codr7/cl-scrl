(defpackage lang
  (:use cl)
  (:export make-add-op make-push-op make-stop-op make-vm make-val make-val-type
	   val-data val-type
	   version
	   *vm* vm-emit vm-eval vm-pop vm-push))

(in-package lang)

(define-symbol-macro version
    (slot-value (asdf:find-system 'lang) 'asdf:version))
