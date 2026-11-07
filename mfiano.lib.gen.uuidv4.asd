(asdf:defsystem #:mfiano.lib.gen.uuidv4
  :description "Simple UUID v4 generator"
  :author "Michael Fiano <michael.fiano@gmail.com>"
  :license "MIT"
  :homepage "https://github.com/mfiano/mfiano.lib.gen.uuidv4"
  :encoding :utf-8
  :depends-on
  (#:ironclad/core
   #:mfiano.lib.base)
  :pathname "src"
  :serial t
  :components
  ((:file "uuid")))
