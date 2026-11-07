(in-package #:mfiano.lib.base.pkg)

(define-package #:mfiano.lib.gen.uuidv4/test
  (:local-nicknames
   (#:uuid #:mfiano.lib.gen.uuidv4))
  (:use #:cl #:1am))

(in-package #:mfiano.lib.gen.uuidv4/test)

(defparameter *canonical* "f47ac10b-58cc-4372-a567-0e02b2c3d479")

(defparameter *malformed*
  (list ""
        "f47ac10b58cc4372a5670e02b2c3d479"
        "f47ac10b-58cc-4372-a567-0e02b2c3d479zz"
        "+47ac10b-58cc-4372-a567-0e02b2c3d479"
        "f47ac10b-58cc-4372-a567-0e02b2c3d479----"
        "f47ac10b-58cc-4372-a567-0e02b2c3d47"
        "f47ac10b-58cc-4372-a567_0e02b2c3d479"
        "g47ac10b-58cc-4372-a567-0e02b2c3d479"
        " f47ac10b-58cc-4372-a567-0e02b2c3d47"))

(defun variant-of (digit)
  (uuid:variant (uuid:from-string (format nil "00000000-0000-4000-~c000-000000000000" digit))))

(defun generated-strings (count)
  (loop :repeat count :collect (uuid:to-string (uuid:make-uuid))))
