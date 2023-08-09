(asdf:defsystem cl-ang
  :name "cl-ang"
  :version "1"
  :maintainer "codr7"
  :author "codr7"
  :description "a scripting language/virtual machine"
  :licence "MIT"
  :serial t
  :components ((:file "ang")
	       (:file "util")
               (:file "val")
	       (:file "prim")
	       (:file "task")
	       (:file "env")
	       (:file "lib")
	       (:file "libs/abc")
	       (:file "vm")
	       (:file "pos")
	       (:file "deque")
	       (:file "form")
	       (:file "read")
	       (:file "op")
	       (:file "repl")
	       (:file "test")))
