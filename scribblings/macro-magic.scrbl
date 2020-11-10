#lang scribble/manual
@require[@for-label[macro-magic
                    racket/base]]

@title{macro-magic}
@author{Lîm Tsú-thuàn}

@defmodule[macro-magic]

This project presents how macro work, by using quoted-expression, we can avoid parser part. The idea of macro is simple: a function operating AST. By operating AST, we can create new syntax for certain usage. We have to distinguish macro and other form, therefore, in @code{parse} it record macro form @code{define-syntax-rule} into environment. In second step: @code{expand}, it traverses all AST to lookup pattern, if name matched then check pattern matched, finally, to avoid name conflict, wrapping output AST with a new @code{let}
