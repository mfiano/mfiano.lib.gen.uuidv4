# mfiano.lib.gen.uuidv4 : A tiny UUID v4 generator/parser for Common Lisp.

In "pure Lisp land", UUIDs are often optional: you already have object identity, symbols, packages, pathname conventions, `make-load-form`, and plenty of ways to name things.

This library is for the less-pure reality where you need to **interoperate with other systems** that expect RFC-4122 UUIDs (usually the canonical 36-character form: `8-4-4-4-12` hex digits).

## When it's actually useful

You'll get real value out of UUIDs when you need identifiers that are **portable across processes, machines, and languages**:

- **DB/document store IDs**: you want IDs that don't depend on a particular Lisp image's object identity.
- **Network messages / job systems**: correlation IDs for tracing a request through logs and queues.
- **File formats**: some binary/text formats (or vendor APIs) literally include UUID fields.
- **Public-ish opaque IDs**: you don't want sequential integers in URLs. (Not a security boundary, but it avoids "guess the next ID" [but so do more concise forms for a single domain pool of IDs, heh]).

## When it's probably not

- Everything is in one Lisp image and you already have a natural key.
- You only need uniqueness *within one run* and don't serialize it.
- You're tempted to use UUIDs as a substitute for thinking about identity. Just don't.

## In a nutshell

It's mostly useless, but it's a thing.

## Quick start

```lisp
(asdf:load-system :mfiano.lib.gen.uuidv4)

(defparameter *id* (mfiano.lib.gen.uuidv4:make-uuid))
(mfiano.lib.gen.uuidv4:to-string *id*)
;; => "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx" (example shape, where y is 8, 9, a or b)

(defparameter *id2*
  (mfiano.lib.gen.uuidv4:from-string "f47ac10b-58cc-4372-a567-0e02b2c3d479"))

(mfiano.lib.gen.uuidv4:valid-string? "f47ac10b-58cc-4372-a567-0e02b2c3d479")
;; => T

(mfiano.lib.gen.uuidv4:version *id2*)
;; => 4

(mfiano.lib.gen.uuidv4:variant *id2*)
;; => :RFC-4122
```

## License

Licensed under the MIT License.
