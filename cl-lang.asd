(asdf:defsystem cl-lang
  :name "cl-lang"
  :version "1"
  :maintainer "codr7"
  :author "codr7"
  :description "a scripting language/virtual machine"
  :licence "MIT"
  :serial t
  :components ((:file "lang")
	       (:file "vm")
               (:file "val")
	       (:file "op")
	       (:file "test")))
