(defpackage scrl
  (:use cl)
  (:export *abc-lib* *vm*
	   deque-items
	   emit-forms env env-get env-set eval-string
	   id-form
	   make-call-op make-id-form make-push-op make-stop-op make-task make-vm make-val make-val-type
	   new-abc-lib new-deque new-pos num-type
	   len lib lit-form
	   pop-front pos-col pos-row pos-source push-back
	   read-forms read-id read-ws repl
	   task-dump-stack task-get task-peek task-pop task-push task-set task-stdin task-stdout
	   val-data val-type
	   +version+
	   vm-compile vm-dump-stack vm-emit vm-emit-pc vm-eval vm-get vm-peek vm-pop vm-push vm-set vm-stdin
	   vm-stdout
	   with-vm))

(in-package scrl)

(define-symbol-macro +version+
    (slot-value (asdf:find-system 'scrl) 'asdf:version))

(defvar *macro-type*)
(defvar *prim-type*)

(defvar *ret* nil)
