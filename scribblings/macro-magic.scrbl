#lang scribble/manual
@require[@for-label[macro-magic
                    (except-in racket/base
                        expand)]]

@title{macro-magic}
@author{Lîm Tsú-thuàn}

@defmodule[macro-magic]

This project presents how macro work, by using quoted-expression, we can avoid parser part. The idea of macro is simple: a function operating AST. By operating AST, we can create new syntax for certain usage. Here I present two steps method.

@defform[(parse exp)]{
  In this step we have to distinguish macro and other form, then record macro form @code{define-syntax-rule} into environment.
}

You might think why we don't just use one step, we can do that actually, but price is macro must be defined before usage like @bold{C} does. Now, let's take a look at the second step:

@defform[(expand exp)]{
  This step traverses all AST to lookup pattern, if name matched then check pattern matched, finally, to avoid name conflict, TODO
}

A common question is why TODO(renaming)

@racketblock[
(define-syntax-rule (swap first second)
  (let ([tmp first])
    (set! first second)
    (set! second tmp)))
]

Without new @code{let}, @code{(swap tmp other)} produces:

@racketblock[
(let ([tmp tmp])
  (set! tmp other)
  (set! other tmp))
]

Which definitely wrong
