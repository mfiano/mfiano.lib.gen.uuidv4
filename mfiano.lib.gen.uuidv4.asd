(asdf:defsystem #:mfiano.lib.gen.uuidv4
  :description "Simple UUID v4 generator"
  :author "Michael Fiano <michael.fiano@gmail.com>"
  :license "MIT"
  :homepage "https://github.com/mfiano/mfiano.lib.gen.uuidv4"
  :encoding :utf-8
  :depends-on
  (#:ironclad/core
   #:mfiano.lib.base)
  :in-order-to ((test-op (test-op #:mfiano.lib.gen.uuidv4/test)))
  :pathname "src"
  :serial t
  :components
  ((:file "uuid")))

(asdf:defsystem #:mfiano.lib.gen.uuidv4/test
  :description "Unit tests for mfiano.lib.gen.uuidv4"
  :author "Michael Fiano <michael.fiano@gmail.com>"
  :license "MIT"
  :homepage "https://github.com/mfiano/mfiano.lib.gen.uuidv4"
  :encoding :utf-8
  :depends-on
  (#:1am
   #:mfiano.lib.gen.uuidv4)
  :perform (test-op (o c) (symbol-call '#:1am '#:run))
  :pathname "test"
  :serial t
  :components
  ((:file "helpers")
   (:file "test")))
