(in-package ang)

(defun repl (&key stdin stdout)
  (let ((stdin (or stdin (vm-stdin)))
	(stdout (or stdout (vm-stdout))))
    (flet ((fmt (spec &rest args)
             (apply #'format stdout spec args)
             (finish-output stdout)))
      (fmt "ang v~a~%~%" version)

      (let ((buf (make-string-output-stream)))
	(tagbody
	 next
           (fmt " ")
           (let ((in (read-line stdin nil)))
             (when in
               (if (string= in "")
                   (progn
                     (setf in (get-output-stream-string buf))
                     (restart-case
			 (let ((pc (vm-emit-pc)))
			   ;;todo read/emit
			   (vm-emit (make-stop-op))
			   (vm-eval pc)
                           (vm-dump-stack stdout)
                           (terpri stdout))
                       (ignore ()
			 :report "Ignore condition.")))
                   (write-string in buf))
               (go next))))))))
