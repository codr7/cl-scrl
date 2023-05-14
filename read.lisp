(in-package ang)

(defun read-ws (in pos)
  (tagbody
   next
     (let ((c (read-char in nil)))
       (when c
           (case c
             (#\newline
              (incf (pos-row pos))
              (setf (pos-col pos) 0)
	      (go next))
	     (#\tab
	      (incf (pos-col pos))
	      (go next))
	     (#\space
	      (incf (pos-col pos))
	      (go next))
	     (otherwise
              (unread-char c in)))))))

(defun read-id (in pos out)
  (let ((fpos (clone pos))
        (s (with-output-to-string (out)
             (tagbody
              next
                (let ((c (read-char in nil)))
                  (when c
                    (incf (pos-col pos))
                    (write-char c out)
                    (go next)))))))
    (push-back (make-id-form :pos fpos :name s) out)
    t))

(defun read-num (in pos out)
  (let ((fpos (clone pos))
	(v 0))
    (tagbody
     next
       (let ((c (read-char in nil)))
         (when c
           (when (digit-char-p c)
             (incf (pos-col pos))
             (setf v (+ (* v 10) (char-digit c)))
             (go next))
           (unread-char c in))))
    (push-back (make-lit-form :pos fpos :val (make-val :type (num-type *abc-lib*) :data v)) out)
    t))

(defun read-form (in pos out)
  (read-ws in pos)
  
  (let ((c (peek-char nil in nil)))
    (cond
      ((null c) nil)
      ((digit-char-p c) (read-num in pos out))
      (t (read-id in pos out)))))

(defun read-forms (in pos out)
  (when (read-form in pos out)
    (read-forms in pos out)))

