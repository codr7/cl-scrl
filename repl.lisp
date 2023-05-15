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
			   (eval-string (get-output-stream-string buf) :pos (new-pos "repl"))
			   (file-position buf 0)
                           (vm-dump-stack stdout)
                           (terpri stdout))
                       (ignore ()
			 :report "Ignore condition.")))
                   (write-string line buf))
               (go next))))))))
