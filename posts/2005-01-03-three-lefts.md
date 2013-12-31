---
description: Comments versus type declarations
date: '2005-01-03 22:34:25'
layout: post
slug: three-lefts
status: publish
title: Three Lefts Make a Right: The Type Declaration Paradox
wordpress_id: '130'
categories: [Essays, Software Development]
tags: programming-languages, essays
---

A few days ago [I argued](http://osteele.com/archives/2004/12/type-declaration-compromise) that even though type declarations aren't the best possible solution for any _particular_ problem, they can be the right solution for solving _several problems at once_.  I baffled even [smart](http://patricklogan.blogspot.com/2005/01/more-than-two-wrongs-might-make-right.html) [people](http://www.cincomsmalltalk.com/blog/blogView?showComments=true&entry;=3282205449).  If I had longer I'd write a clarification.  As it is, I'll just give an example.

## Type Declarations as Documentation

Let's say that I'm writing a function `f()` that takes two arguments:

    function gcd(a, b) {...}

I know as I'm writing the function what the range of parameter values is intended to be.  They're both non-negative integers.  I could do at least four things to document this: add a comment, use descriptive variable names, add assertions, or insert type declarations.

To make this interesting, let's assume this is in a language that doesn't have a "non-negative integer" type and doesn't have a [mechanism to create restrictive types](http://gauss.gwydiondylan.org/books/drm/drm_46.html)[^1].

*Comment encoding:*

    // a and b are non-negative integers
    function gcd(a, b) {...}

*Structured comment:*

    // @param a : Integer
    // @param b : Integer
    function gcd(a, b) {...}

*Variable name encodings:*

    // Smalltalk style (loses information):
    function gcd(anInteger, anotherInteger) {...}
    // Extended Smalltalk:
    function gcd(aNonNegativeInteger, anotherNonNegativeInteger) {...}
    // Hungarian notation:
    function gcd(nA, nB) {...}


*Assertions:*

    function gcd(a, b) {
      assert a isinstance Integer && a >= 0
      assert b isinstance Integer && b >= 0
      ...
    }

*Type declarations:*

    function gcd(a: Integer, b: Integer) {...}

Note that the type declaration, from the perspective of how much information it captures, is the worst of these: it loses the information that `a` and `b` are non-negative.  (It's tied with the short form of the Smalltalk convention here.)

This is because the type declaration is only being used for one purpose: documentation.  And comments are better at documentation.

Let's summarize the benefits of these solutions numerically.  I'm pulling the numbers from a hat (with some attempt to make the _rank_ match my perception); what's important is that, according to this metric, type declarations aren't the best solution for documentation.  More verbose mechanisms, and mechanisms that violate [DRY](http://c2.com/cgi/wiki?DontRepeatYourself), get docked in the _cost_ column.

| Mechanism        | Cost | Benefit |
| :-               | :-   | :-      |
| comment          | 1    | 4       |
| name             | 3    | 2       |
| assertion        | 2    | 4       |
| type declaration | 1    | 3       |

## Type Declarations as Metadata

Now add another requirement: this function should be callable from a statically typed language, e.g. C.  (You can substitute your own requirement: compile-time checking, database bridging, etc.)  There are a couple of ways to do this too:

*Metadata:*

    @cexport(bool gcd(int, int))
    function gcd(a, b) {...}

*Type declarations:*

    function gcd(a: Integer, b: Integer) : Boolean {...}

Again, the type declaration is more concise, but it's not as general a solution to the problem of exposing a function in one language to code in another.  The metadata solution allows me to choose an export name for the function, and perhaps do a better job of selecting equivalent types than a library or tool driven solely by the types in _this_ language might perform.  It does so at a significantly greater cost: in verbosity, and in the duplication of structure and names which now have to be maintained in parallel.  Numerically:

| Mechanism        | Cost | Benefit |
| :-               | :-   | :-      |
| metadata         | 2    | 4       |
| type declaration | 1    | 2       |

Mow, for any _particular_ use of metadata, the cost-benefit ratio may be different.  For example, a tool driven by the metadata may not do any better a job than one driven by the type declarations, in which case the cost-benefit ratio may look more like this:

| Mechanism        | Cost | Benefit |
| :-               | :-   | :-      |
| metadata         | 2    | 2       |
| type declaration | 1    | 2       |

## Adding Apples and Oranges

So far type declarations are 0-for-2.  They're worse than comments at documentation, and they're worse than domain-specific metadata at bridging languages.  But type declarations are stronger when they take on both challengers at once.

Let's consider a function definition that satisfies both documentation _and_ metadata requirements.  I'll consider two solutions: (1) a "swat team" solution composed of the best documentation solution (comments) together with the best metadata solution (a domain-specific annotation); and (2) type declarations:

*Swat team:*

    // a and b are non-negative integers
    `cexport(bool myGCD(int, int))
    function gcd(a, b) {...}

*Type declarations:*

    function gcd(a: Integer, b: Integer) : Boolean {...}

Numerically:

| Mechanism        | Cost | Documentation benefit | Tooling benefit |
| :-               | :-   | :-                    | :-              |
| comment          | 1    | 4                     | 0               |
| metadata         | 2    | 0                     | 2               |
| comment+metadata | 3    | 4                     | 2               |
| type declaration | 1    | 3                     | 2               |

Again, don't pay two much attention to the actual numbers; the point to note is that even though a comment is better at documentation, and metadata is better (or in this case as good) at tooling, the comment+benefit solution has a worse cost-benefit ratio (3:6=1:2) than the type declaration solution (1:5).  This is because the cost for type declarations stays constant while, the more requirements type declarations meet (even if poorly), the more the benefits rise.  This as as opposed to the swat team approach, where the cost rises with the number of requirements (and therefore solutions).

Setting aside the math, it's obvious at a glance that the swat team example is _longer_, and _more complex_, and therefore should be expected to have _more overhead_.  A simple change, such as adding a parameter to a function, becomes a _lot_ more expensive, because you've got to make each change so many places.

## Notes

[^1]: In fact, this language could even be Java.  Consider a `gcd` that worked on [BigDecimals](http://java.sun.com/j2se/1.4.2/docs/api/java/math/BigDecimal.html).  There isn't a "non-negative BigDecimal" type, so a type declaration can't encode the domain of the function.
