(asdf:defsystem cl-ang
  :name "cl-ang"
  :version "1"
  :maintainer "codr7"
  :author "codr7"
  :description "a scripting language/virtual machine"
  :licence "MIT"
  :serial t
  :components ((:file "ang")
               (:file "val")
	       (:file "task")
	       (:file "vm")
	       (:file "op")
	       (:file "repl")
	       (:file "test")))
