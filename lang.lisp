(defpackage lang
  (:use cl)
  (:export make-add-op make-push-op make-stop-op make-task make-vm make-val make-val-type
	   task-peek task-pop task-push
	   val-data val-type
	   version
	   *vm* vm-emit vm-eval vm-peek vm-pop vm-push))

(in-package lang)

(define-symbol-macro version
    (slot-value (asdf:find-system 'lang) 'asdf:version))
