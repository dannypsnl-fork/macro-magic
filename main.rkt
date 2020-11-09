#lang racket

(define macro-env (make-hash))
(struct @macro (pat* body) #:transparent)

;;; in first step: parse, we make everything be sexp
; but only record macros
(define (parse exp)
  (match exp
    [`(define-syntax-rule (,name ,pat* ...) ,body)
     (hash-set! macro-env name (@macro pat* body))]
    [else exp]))

;;; in second step: expand, we lookup macros and substitute expression with macro pattern
(define (expand exp)
  (match exp
    [`(,name-pat ,pat* ...)
     (let ([macro! (hash-ref macro-env name-pat #f)])
       (when macro!
         (unless (= (length (@macro-pat* macro!)) (length pat*))
           (error 'macro "macro pattern mismatching: ~a <-> ~a" (@macro-pat* macro!) pat*))
         `(let (,@(map (λ (k v) `(,k ,v))
                       (@macro-pat* macro!) pat*))
            ,(@macro-body macro!))))]
    [else exp]))

(module+ test
  (parse '(define-syntax-rule (swap first second) (let ([tmp first])
                                                    (set! first second)
                                                    (set! second tmp))))
  (let ([parsed (parse '(swap a b))])
    (expand parsed)))