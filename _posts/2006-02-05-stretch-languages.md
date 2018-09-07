---
description: Timeline of languages in my life
date: '2006-02-05 23:57:02'
slug: stretch-languages
permalink: 2006/02/stretch-languages
redirect_from: posts/2006/02/stretch-languages
title: “Stretch” Languages, or, 28 years of programming
categories: [Essays, Programming, Visualizations]
tags: programming-languages, visualizations, essays
---

Recently I reviewed the programming languages I've used over the 28 years[^1] of
my programming career. The result is shown in the chart below. (Click on the
image to see it full size.)

[![](http://images.osteele.com/2006/languages-thumb.png)](http://images.osteele.com/2006/languages.png)

<!-- more -->

There are some obvious trends here[^2]. The languages are mostly getting higher
level. There are a few "survivors": languages that I've used over the the course
of a decade, although discontiguously: C/C++, Common Lisp, and Java. Java has
replaced C (except for a stint around 2000 where I went back to low-level
graphics programming at AlphaMask), and the scripting languages have taken over
from Common Lisp --- they're slower, but they're terse, have better libraries,
and are easier to deploy.

It didn't surprise me that there are so many languages. For one thing, I like
languages, and I enjoy learning how to program by learning new ones. For another
thing, times changes and programming languages get better. You'd have to be
crazy to program in 1970's BASIC these days. (That's BASIC, not Visual Basic.
The language I cut my teeth on didn't have functions or structures.) And there
just isn't much call for Z80 assembly any more.

But why so many languages _at one time_?

The reason is that different languages are good at different things. When I
first learned to program, I used BASIC for everything. Then I started using
assembly for code that had to be fast, but I stuck with BASIC for doing my
homework. (In tenth grade I wrote programs to multiply and invert matrices, so I
wouldn't be bored silly doing it by hand. It took longer, but I had more fun.)

This is what the second chart shows. Again, click on the thumbnail to see the
full size version. And beware! --- the colors don't mean the same thing as in
the chart above. (Sorry.)

[![](http://images.osteele.com/2006/languages-by-use-thumb.png)](http://images.osteele.com/2006/languages-by-use.png)

I use four kinds of languages: _utility languages_, for writing tools and
solving problems; _application languages_, for writing distributable integrated
applications; _system programming languages_, for implementing operating systems
and low-level libraries; and a fourth category of languages, which I'll call
"stretch languages", for learning how to program. (I also dabble with bash for
shell programming and R for statistics, but I don't really think of the way I
use them as programming.)

A _utility language_ is useful for solving small problems and for exploring
problem domains. It's what you write your ten-minute program in. If you can use
your utility language as your file manipulation language and your build
language, all the better. (For a while I did a lot of programming in C and then
Java, and I tried to use make and ant for these. Now that I'm using Ruby as my
utility language, I'm a lot happier using Rake instead.)

An _application language_ is for building larger, more full-feature programs
that other people can use. (This is my own use of the term. Think "desktop
application", or "web application".) An application language often has
requirements for speed, OS integration, and deployability, that a utility
language does not.

("Application" for me used to mean desktop applications. Recently I've only
written web applications --- although I did write a MacOS app a few months ago,
in order to learn about the MacOS toolbox. That's why the "Desktop Application"
category in the second chart trails off, to be replaced by languages for writing
web applications, and browser-based clients that connect to them.)

Lastly, the point of a _stretch language_ is to teach me new ways to think about
programming. This is the _opposite_ of a utility language, although a stretch
language can turn into a utility language after I absorb its concepts. A utility
language makes it easy to express programs that I have in mind; it gets out of
the way, so I only have to think about the problem domain, and not how to
program. A stretch language can make it difficult to do even simple things,
because I'm still learning the concepts that are necessary to use it
idiomatically or, sometimes, to use it at all.

Sometimes a stretch language becomes a utility language or an application
language. This was the case with Common Lisp, which took me a while to
understand, but for a while was my most productive language.

More often, the concepts that I learn from a stretch language are helpful in
using other languages, even if I have to express these concepts by writing the
equivalent of macro-expanded code or a VM. For example, I've written a
continuation-based pattern matcher in Common Lisp and a logic program in Java,
even though neither language supports those respective features. Designing the
programs as though the features existed made a hard problem tractable.

And finally, learning concepts from one language makes it easier for me to
recognize them and start using them when they're available in a more mainstream
language or one with better deployment characteristics. Those of us who were
familiar with advise and the CLOS MOP had a leg up on understanding how to use
AOP when it came around to Java. The modern round of scripting languages (Python
2.x and Ruby) have MOPs --- if you're familiar with them from Smalltalk, you
know how to take advantage of them in Python and Ruby too. And if I ever have to
use C++ again, at least I'll know from Haskell to look for template
implementations of combinator libraries.

Here are the languages that I've learned from over the years, and what I've
learned from each one[^3]. Some of the languages that aren't in _my_ list would
be perfectly respectable stretch languages for someone else --- I just happened
to be familiar with their concepts by the time I got to them. For example,
Python is probably a fine way to learn about OO (and my son learned a lot of OO
concepts from Logo MicroWorlds), and I could have learned metaobject programming
from Ruby if I hadn't already learned it from Smalltalk and Common Lisp.

* _BASIC_: basic programming

* _Z80_: ADTs; recursion

* _Prolog_: logic variables; abstracting over control flow

* _CLU_: exception handling; coroutines; parameterized data types

* _Smalltalk_: OOP

* _Common Lisp_: functional objects; meta-object programming

* _Java_: concurrency

* _Eiffel_: design by contract

* _Haskell_: lazy evaluation; type classes

* _LZX_ (OpenLaszlo): constraint-based programming

Right now my stretch language is Haskell. When I write in Haskell, I feel like a
beginning programmer again. I can't use it when I'm in a hurry, and I don't use
it when I'm more interested in the problem domain than in the craft of
programming. Reading Haskell is like reading poetry (I'm very slow at it, and I
can't skim because the new-concept density is very high), and writing Haskell is
like writing poetry (something else that takes me forever). As opposed to Python
and Ruby, which are more prosaic, and Enterprise Java, which is more like a tax
form.

## Translations

[Estonian](https://www.piecesauto-pro.fr/blog/2018/08/21/venitada-keelt-voi-28-aastat-programmeerimine/)
— thanks to Weronika Pawlak.

[Serbo-Croatian](http://science.webhostinggeeks.com/stretch-jezici) — thanks to
Jovana Milutinovich of the University of Belgrade in Serbia.

[^1]: I first learned to program in seventh grade, from the TRS-80 Level I Basic
      reference. That makes me both (1) almost 30, and (2) innumerate.

[^2]: In this entire essay, I'm quantifying over the languages I use and the way
      I use them. YMMV.

[^3]: This list includes more languages than the charts do because it includes
      languages that I've never used commercially. I've only ever used Prolog and
      CLU for college projects, for example, but I learned a lot from them anyway.
