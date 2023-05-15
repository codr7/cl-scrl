(defpackage ang
  (:use cl)
  (:export *abc-lib* *vm*
	   emit-forms env env-get env-set eval-string
	   make-add-op make-id-form make-push-op make-stop-op make-task make-vm make-val make-val-type
	   new-deque new-pos num-type
	   len lib
	   pop-front pos-col pos-row pos-source push-back
	   read-id read-ws repl
	   task-dump-stack task-get task-peek task-pop task-push task-set task-stdin task-stdout
	   val-data val-type
	   version
	   vm-dump-stack vm-emit vm-eval vm-get vm-peek vm-pop vm-push vm-set vm-stdin vm-stdout
	   with-vm))

(in-package ang)

(define-symbol-macro version
    (slot-value (asdf:find-system 'cl-ang) 'asdf:version))
