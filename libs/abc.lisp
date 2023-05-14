(in-package ang)

(defstruct (abc-lib (:include lib) (:conc-name nil))
  (bool-type (make-val-type :name "Bool"))
  (num-type (make-val-type :name "Num")))

(defvar *abc-lib* (make-abc-lib :name "abc"))
