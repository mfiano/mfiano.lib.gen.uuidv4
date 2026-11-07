(in-package #:mfiano.lib.gen.uuidv4/test)

(test uuid.make.version
  (is (every (lambda (string) (char= (char string 14) #\4)) (generated-strings 1000)))
  (is (= (uuid:version (uuid:make-uuid)) 4)))

(test uuid.make.variant
  (let ((digits (remove-duplicates (map 'list (lambda (string) (char string 19))
                                        (generated-strings 1000)))))
    (is (null (set-difference digits '(#\8 #\9 #\a #\b))))
    (is (= (length digits) 4)))
  (is (eq (uuid:variant (uuid:make-uuid)) :rfc-4122)))

(test uuid.make.distinct
  (let ((strings (generated-strings 10000)))
    (is (= (length (remove-duplicates strings :test #'string=)) 10000))))

(test uuid.to-string.canonical
  (let ((string (uuid:to-string (uuid:make-uuid))))
    (is (= (length string) 36))
    (is (uuid:valid-string? string))
    (is (string= string (string-downcase string)))))

(test uuid.from-string.round-trip
  (is (string= (uuid:to-string (uuid:from-string *canonical*)) *canonical*))
  (is (string= (uuid:to-string (uuid:from-string (string-upcase *canonical*))) *canonical*))
  (is (every (lambda (string) (string= (uuid:to-string (uuid:from-string string)) string))
             (generated-strings 1000))))

(test uuid.from-string.version
  (is (= (uuid:version (uuid:from-string *canonical*)) 4))
  (is (= (uuid:version (uuid:from-string "6ba7b810-9dad-11d1-80b4-00c04fd430c8")) 1)))

(test uuid.from-string.variant
  (is (every (lambda (digit) (eq (variant-of digit) :reserved/ncs)) "01234567"))
  (is (every (lambda (digit) (eq (variant-of digit) :rfc-4122)) "89ab"))
  (is (every (lambda (digit) (eq (variant-of digit) :reserved/microsoft)) "cd"))
  (is (every (lambda (digit) (eq (variant-of digit) :reserved/future)) "ef")))

(test uuid.from-string.invalid
  (dolist (string *malformed*)
    (signals error (uuid:from-string string))))

(test uuid.valid-string?
  (is (uuid:valid-string? *canonical*))
  (is (uuid:valid-string? (string-upcase *canonical*)))
  (is (notany #'uuid:valid-string? *malformed*))
  (is (notany #'uuid:valid-string? (list nil 42 :uuid #\a (vector #\a)))))

(test uuid.print
  (let ((uuid (uuid:make-uuid)))
    (is (search (uuid:to-string uuid) (prin1-to-string uuid)))))
