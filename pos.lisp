(in-package scrl)

(declaim (optimize (safety 0) (debug 0) (speed 3)))

(defstruct pos
  (source (error "Missing source") :type string)
  (row (error "Missing row") :type fixnum)
  (col (error "Missing col") :type fixnum))

(defun new-pos (source &key (row 1) (col 0))
  (make-pos :source source :row row :col col))

(defmethod clone ((pos pos))
  (copy-structure pos))

(defmethod print-object ((pos pos) out)
  (with-slots (file row col) pos
    (format out "~a@~a:~a"
            (pos-source pos)
            (pos-row pos)
	    (pos-col pos))))
