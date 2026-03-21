(in-package #:mfiano.lib.base.pkg)

(define-package #:mfiano.lib.gen.uuidv4
  (:use #:mfiano.lib.base.util)
  (:export
   #:from-string
   #:make-uuid
   #:to-string
   #:uuid
   #:valid-string?
   #:variant
   #:version))

(in-package #:mfiano.lib.gen.uuidv4)

(declaim (inline %make-uuid))
(defstruct (uuid
            (:constructor %make-uuid)
            (:conc-name nil)
            (:predicate nil)
            (:copier nil))
  (version 4 :type fixnum)
  (variant :rfc-4122)
  (low 0 :type u64)
  (high 0 :type u64))

(define-ftype valid-string? (string) boolean)
(defun valid-string? (string)
  (and (= (nth-value 1 (parse-integer (remove #\- string) :radix 16 :junk-allowed t)) 32)
       (char= (char string 8) (char string 13) (char string 18) (char string 23) #\-)))

(define-ftype to-string (uuid) string)
(defun to-string (uuid)
  (declare (optimize (speed 3)))
  (macrolet ((%write (string count offset bits word)
               `(setf ,@(loop :for i :below count
                              :collect `(aref ,string ,(+ offset i))
                              :collect `(aref "0123456789abcdef"
                                              (ldb (byte 4 ,(- bits (* i 4))) ,word))))))
    (let ((high (high uuid))
          (low (low uuid))
          (string (make-string 36 :element-type 'base-char)))
      (psetf (aref string 8) #\-
             (aref string 13) #\-
             (aref string 18) #\-
             (aref string 23) #\-)
      (%write string 8 0 60 high)
      (%write string 4 9 28 high)
      (%write string 4 14 12 high)
      (%write string 4 19 60 low)
      (%write string 12 24 44 low)
      string)))

(define-ftype from-string (string) uuid)
(defun from-string (string)
  (declare (optimize (speed 3)))
  (flet ((parse-variant (bits)
           (cond
             ((not (logbitp 2 bits))
              :reserved/ncs)
             ((not (logbitp 1 bits))
              :rfc-4122)
             ((not (logbitp 0 bits))
              :reserved/microsoft)
             (t
              :reserved/future))))
    (declare (inline parse-variant))
    (unless (valid-string? string)
      (error "Invalid UUID string"))
    (let* ((string (remove #\- string))
           (high (parse-integer string :end 16 :radix 16))
           (low (parse-integer string :start 16 :radix 16)))
      (declare (type u64 high low))
      (%make-uuid :version (ldb (byte 4 12) high)
                  :variant (parse-variant (ldb (byte 3 61) low))
                  :low low
                  :high high))))

(define-ftype make-uuid (&optional (fn (u64) u64)) uuid)
(defun make-uuid (&optional (rng #'random))
  (declare (optimize (speed 3)))
  (declare (type (fn (u64) u64) rng))
  (%make-uuid :version 4
              :low (dpb 4 (byte 3 61) (funcall rng #.max/u64))
              :high (dpb 4 (byte 4 12) (funcall rng #.max/u64))))

(define-printer (uuid stream :type t)
  (format stream "~a" (to-string uuid)))
