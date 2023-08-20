(in-package ang)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defun ws? (c)
  (or ))

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
		    (if (and (graphic-char-p c)
			     (not (member c '(#\newline #\tab #\space #\( #\)))))
			(progn
			  (incf (pos-col pos))
			  (write-char c out)
			  (go next))
			(unread-char c in))))))))
    (push-back (make-id-form :pos fpos :name (kw s)) out)))

(defun read-list (in pos out)
  (let ((fpos (clone pos))
	(body (new-deque)))
    (read-char in nil)
    
    (tagbody
     next
       (let ((c (peek-char nil in nil)))
	 (unless (eq c #\))
	   (unless (read-form in pos body)
	     (error "Open list"))
             (go next))))
    (read-char in)
    (push-back (make-list-form :pos fpos :body (deque-items body)) out)))

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
    (push-back (make-lit-form :pos fpos :val (make-val :type (num-type *abc-lib*) :data v)) out)))

(defun read-form (in pos out)
  (read-ws in pos)
  
  (let ((c (peek-char nil in nil)))
    (cond
      ((null c) (return-from read-form))
      ((char= c #\()
       (read-list in pos out))
      ((digit-char-p c)
       (read-num in pos out))
      (t (read-id in pos out))))

  t)

(defun read-forms (in pos out)
  (if (read-form in pos out)
      (read-forms in pos out)
      out))
