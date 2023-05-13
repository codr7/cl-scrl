(defpackage lang
  (:use cl)
  (:export make-add-op make-push-op make-stop-op make-task make-vm make-val make-val-type
	   repl
	   task-dump-stack task-peek task-pop task-push task-stdin task-stdout
	   val-data val-dump val-type
	   version
	   *vm* vm-dump-stack vm-emit vm-eval vm-peek vm-pop vm-push vm-stdin vm-stdout
	   with-vm))

(in-package lang)

(define-symbol-macro version
    (slot-value (asdf:find-system 'cl-lang) 'asdf:version))
