(defpackage ang-test
  (:use cl ang)
  (:export run))

(in-package ang-test)

(defun test-deque ()
  (let ((q (new-deque 1 2)))
    (assert (= (len q) 2))
    (push-back 3 q)
    (assert (= (len q) 3))
    (dotimes (i 3)
      (assert (= (pop-front q) (1+ i))))
    (assert (zerop (len q)))))

(defun test-vm ()
  (with-vm ()
    (vm-emit (make-push-op :val (make-val :type (num-type *abc-lib*) :data 35)))
    (vm-emit (make-push-op :val (make-val :type (num-type *abc-lib*) :data 7)))
    (vm-emit (make-add-op))
    (vm-emit (make-stop-op))
    (vm-eval 0)
    (assert (= (val-data (vm-pop)) 42))))

(defun run ()
  (test-deque)
  (test-vm))
