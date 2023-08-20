(in-package ang)

(defun char-digit (c)
  (- (char-int c) (char-int #\0)))

(defun syms (&rest args)
  (with-output-to-string (out)
    (dolist (a args)
      (princ a out))))

(defun kw (&rest args)
  (intern (apply #'syms args) 'keyword))

(defmacro while (cnd &body body)
  (let (($next (gensym)))
    `(block nil
       (tagbody
	  ,$next
	  (when ,cnd
	    ,@body
	    (go ,$next))))))
 
