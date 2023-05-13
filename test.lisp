(defpackage lang-test
  (:use cl lang)
  (:export run))

(in-package lang-test)

(defun run ()
  (let ((*vm* (make-vm))
	(num (make-val-type :name :num)))
    (vm-emit (make-push-op :val (make-val :type num :data 35)))
    (vm-emit (make-push-op :val (make-val :type num :data 7)))
    (vm-emit (make-add-op))
    (vm-emit (make-stop-op))
    (vm-eval 0)
    (assert (= (val-data (vm-pop)) 42))))
