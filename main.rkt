#lang racket

(provide parse expand)

(define macro-env (make-hash))
(struct @macro (pat* body) #:transparent)

;;; in first step: parse, we make everything be sexp
; but only record macros
(define (parse exp)
  (match exp
    [`(define-syntax-rule (,name ,pat* ...) ,body)
     (hash-set! macro-env name (@macro pat* (unique-binding body)))]
    [else exp]))

(define (subst! subst exp)
  (match exp
    [`(,e* ...)
     (map (λ (e) (subst! subst e)) e*)]
    [e (let ([result? (hash-ref subst e #f)])
         (if result? result? e))]))
(define (unique-binding exp)
  (match exp
    [`(let ([,name* ,value*] ...) ,body* ...)
     (define subst (make-hash))
     `(let (,@(map (λ (name value)
                     (let ([new-name (gensym name)])
                       (hash-set! subst name new-name)
                       `(,new-name ,value))) name* value*))
        ,@(map (λ (body) (subst! subst body)) body*))]
    [else exp]))

;;; in second step: expand, we lookup macros and substitute expression with macro pattern
(define (expand exp)
  (match exp
    [`(,name-pat ,pat* ...)
     (let ([macro! (hash-ref macro-env name-pat #f)])
       (when macro!
         (unless (= (length (@macro-pat* macro!)) (length pat*))
           (error 'macro "macro pattern mismatching: ~a <-> ~a" (@macro-pat* macro!) pat*))
         (define subst (make-hash))
         (for ([name (@macro-pat* macro!)]
               [new-name pat*])
           (hash-set! subst name new-name))
         (subst! subst (@macro-body macro!))))]
    [else exp]))

(module+ test
  (parse '(define-syntax-rule (swap first second) (let ([tmp first])
                                                    (set! first second)
                                                    (set! second tmp))))
  (let ([parsed (parse '(swap a b))])
    (expand parsed)))
