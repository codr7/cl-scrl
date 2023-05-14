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
           (let ((line (read-line stdin nil)))
             (when line
               (if (string= line "")
                   (progn
                     (restart-case
			 (let ((pc (vm-emit-pc))
			       (fs (new-deque)))
			   (read-forms (make-string-input-stream (get-output-stream-string buf))
				       (new-pos "repl")
				       fs)

			   (file-position buf 0)
			   
			   (while (not (zerop (len fs)))
			     (form-emit (pop-front fs) fs))
			   
			   (vm-emit (make-stop-op))
			   (vm-eval pc)
                           (vm-dump-stack stdout)
                           (terpri stdout))
                       (ignore ()
			 :report "Ignore condition.")))
                   (write-string line buf))
               (go next))))))))
