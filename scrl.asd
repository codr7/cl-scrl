(asdf:defsystem scrl
  :name "scrl"
  :version "1"
  :maintainer "codr7"
  :author "codr7"
  :description "a scripting language/VM"
  :licence "MIT"
  :serial t
  :components ((:file "package")
	       (:file "util")
               (:file "val")
	       (:file "macro")
	       (:file "prim")
	       (:file "fun")
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
