---
date: '2004-12-31 13:05:33'
layout: post
slug: type-declaration-compromise
status: publish
title: The Type Declaration Compromise
wordpress_id: '128'
categories:
- Essays
- Software Development
tags: [programming-languages, essays]
---

> A vice grip is the wrong tool for every job. --- anonymous

Type declarations aren't the best tool for any particular purpose, but they're a passable tool for a lot of _different_ purposes, and therefore they're often the best tool for meeting _several purposes at once_.  There are better ways to comment a program, to add metadata for tools and libraries, or to verify program correctness; but type declarations, in many languages, are a passable way to do all of these jobs at once.

The situation is similar to that of a convergence device such as a camera phone.  The voice quality on my camera phone isn't that great (the speaker shares a tiny clamshell lid with the camera optics and CCD), and the camera doesn't take great pictures (the lens is smaller than a halfpenny), but I'd rather carry one substandard device than two separate best-of-breeds --- even if I have to go get my "real" camera when it's worth taking a _good_ photograph.  You can make the same argument for a PDA phone versus a laptop.  And I believe the same holds for type declarations, versus all the mechanisms that, considered separately, are superior to them.

This is why my ideal language has _optional_ type declarations (unlike Java, in which they're mandatory, and Python, in which they're absent).  I'd like to have the syntax _available_, for when I want to use a compromise that meets several of these requirements at once, but _optional_, so I can instead use features that are better tailored for each individual requirement, without redundancy.

Some of the uses for type declarations are:

* Documentation.  The type of a variable is more informative than just its name.  For example, `f(a: String, b: Integer): Boolean` is a better starting point for understanding the intent of `f` than `f(a, b)` alone.

* Code Generation.  An IDE can use the declared types to drive context-sensitive help such as docstring tooltips ("intellisense").  Foreign function _generators_ such as [jnih](http://java.sun.com/j2se/1.4.2/docs/tooldocs/windows/javah.html) and [SWIG](http://www.swig.org/) can use the type declarations to create function interfaces that stub or bridge to other languages or libraries.

* Runtime Introspection.  Foreign function _libraries_ can introspect variable types and function declarations to make foreign function calls at runtime.  Database bridges can introspect class definitions to generate `CREATE TABLE` statements, and to bridge RDBM tables and instance hierarchies.

* Compiler Optimization.  A compiler can use type declarations to choose efficient unboxed representations, or (in a dynamic language) to elide runtime type checks.

* Program verification.  Type mismatches are detected closer to the source location of the error (when a String is passed to a function that expects a Float), instead of further down the call chain (at the point where a primitive operation such as `/` is applied to a String).  With compile-time type checking, type mismatches are detected even in the absence of a test case or code coverage.

There are better solutions for each of these requirements, when the requirement is taken on its own:

* *Documentation*:  _Comments_ are generally superior to type declarations, because natural languages are more expressive and extensible than type systems.  A simple type system can't say very much, and a [complex type system](http://www.haskell.org/ghc/docs/latest/html/users_guide/type-extensions.html) can be hard to read.  

For example, I want to know (and declare) that `table` is a `Set` of `String`, not just that it's a `Set`.  If my language (say, Java 1.4) can't express this, I'm going to write `table: Set` in a comment _anyway_.  In this case, why write `table: Set` _as well_?  

Another example holds in languages without type synonyms (such as C's `typedef`), such as Java up through Java 5.  I generally want to know an object's abstract type (`Centimeters`), not its concrete type (`float` or `double`).

* *Code Generation* and *Runtime Introspection*: An _extensible metadata system_ is a more general solution, and will work in cases where type declarations fall short.  Again, the type system for one language doesn't generally describe the information that is necessary to convert types into another language.  Most languages have type systems that can't distinguish between required and optional values (a `String`, versus either a `String` or `null`).  This means, for instance, that you can't infer a RDBM type from a declared type, because you don't know if the value is nullable.

* *Compiler optimization*:  [Type *inference*](http://en.wikipedia.org/wiki/Type_inference) and _*optional* type declarations_ are often better solutions than mandatory explicit type declarations, where this feature is needed at all. The weak point in many programs these days is the feature set, quality, or development time, not the execution space and speed.  Even when optimization matters, _explicit_ type declarations are often both too much and too little:  

Too _much_, because they often aren't necessary: even a C++ or Java compiler infers the types of _expressions_, and it's some arbitrary to turn this inference off at the function level. Sure, type declarations are useful at compilation unit boundaries to avoid whole-program analysis, but declaring the type of _every variable and private function_ is a throwback to the -90s- -80s- -70s- 60s.  

Too _little_, because program analysis is necessary _anyway_ in order to infer much of what an optimizing compiler or modern memory manager needs to know: flow, lifetime, extent, aliasing, mutability.

* *Program verification*:  _Unit tests_, _assertions_, and [contracts](http://archive.eiffel.com/doc/manuals/technology/contract/) are better suited for this purpose alone.  I rarely see code without a test case that actually works; the clean compile (even with type declarations) just means the easy part is done.  Usually even the value-related errors are division by zero or invalid use of `null`, not something the type system would have caught; and the types of bugs that I see once I get to a clean compile are similar in Java (with mandatory type declarations) and Python (without type declarations at all).

Given the inadequacies of type declarations for each of their intended purposes, then, why use them at all?

## Compromise

One reason is that a type declaration doesn't just a poor job of _one_ of these things; it does a poor job of _each_ of them, and that means it does a _good job_ of doing them _all at once_.  If adding "`: Integer`" to a program produces an incremental improvement in both documentation and IDE support, and SQL and foreign function bindings that work some of the time, well, maybe that's worth it, even if the documentation value alone wouldn't have been justified doing this in addition to (or instead of) writing a comment.

I argued above that it wasn't worth writing `table: Set`, since `Set` doesn't say much of what I know about the value of `table` --- but if writing "`table: Set`" also enables a compiler optimization and some early error detection, then maybe I'll write `table: Set` _instead of_ `/* table: Set */`, in order to reduce the (partial) duplication in my source code that would be present if I wrote the ideal comment and the ideal (within the constraints of the type system) type declaration separately.  Eliminating the comment in this case is arguably an application of [DRY](http://c2.com/cgi/wiki?DontRepeatYourself).

Removing the extra information in the comment hurts the quality of my documentation, by using a lowest-common-denominator (the type system) instead of a tool (natural language) that is tailored for the job.   The fact that the type system is a compromise among several uses means that my use of it is a compromise too.

## Concision

There are two other advantages of using type declarations.  One is that type declarations are typically _concise_.  The other is that they are _integrated into the grammar_.  (The type systems in common use are also _declarative_ and _decidable_, but once a type system is made powerful enough to express real-world program constraints, it becomes Turing complete.)

Common Lisp has a syntax for extensible [declarations](http://www.lispworks.com/reference/HyperSpec/Body/s_declar.htm#declare), that can be used for [type declarations](http://www.lispworks.com/reference/HyperSpec/Body/d_type.htm) as well as [other purposes](http://www.lispworks.com/reference/HyperSpec/Body/d_declar.htm).  Fortunately, it's optional.  Unfortunately, it's so verbose that I only use it as a last resort --- only when I need the program to run faster, not just when I want to record my intent.

Many of the other alternatives to type declarations are similarly verbose.  Preconditions (part of Design by Contract) are more expressive than type declarations, and can function as a superset of type declarations too, but saying something simple like "this is an integer" takes more typing as a precondition.  As with comments, a type declaration does a little of what preconditions do, and in the cases where either type declaration or a precondition will work, the type declaration is more concise.

(Note that this is a property of the languages that have type declarations, not anything inherent about type declarations and preconditions themselves.  Still, that's what we have to work with today.)

Another example is unit tests.  Above, I blithely stated that unit testing was superior to type declarations --- and, if you're able to easily write and run them, [I believe this is true](http://osteele.com/archives/2003/08/test-versus-type).  The verbosity of a unit test can be a significant impediment to doing this, though.  I've noticed that in a language (or library) with [integrated unit tests](http://docs.python.org/lib/module-doctest.html) I can use unit testing to find all the errors that type declarations would find (and more).  But in a language where [unit tests are verbose](http://www.junit.org/index.htm), I don't write nearly so many.  Regardless of the _inherent_ merits of type declarations and unit test testing, the type declaration you write is more valuable than the unit test you don't.

## Granularity

The reason type declarations are concise is that they're conventionally integrated into the host language's grammar.  This leads to another advantage: in principle, a type declaration can apply to any term in the grammar --- like a comment, but unlike, say, the latest breed of metadata annotation mechanisms.  ([C# attributes](http://msdn.microsoft.com/library/default.asp?url=/library/en-us/csref/html/vclrfintroductiontoattributes.asp), [Java metadata annotations](http://java.sun.com/j2se/1.5.0/docs/guide/language/annotations.html), and [Python decorators](http://www.python.org/peps/pep-0318.html) are all constrained to the class and member level; they can't be used to annotate a variable or expression.)  In practice, most languages attach type declarations to _variables_ instead of _values_ (Common Lisp and Haskell are two exceptions), but this still gives you a finer annotation grain size than you get with metadata.  This means, for instance, that a metadata approach to annotating Java or C# method parameters would have to include a new syntax for annotating the parameters of a function, inside an annotation that was attached to the function itself --- and this would be more verbose, more complex, and require the maintenance of two duplicate structures (the annotation, and the signature itself).  And _this_ means that a problem (such as annotating the SQL types of a function's parameters) that might better be solved _conceptually_ by metadata, will often have a more _widely applicable_ (to documentation and other requirements) and a more _concise_ solution, and therefore a better _practical_ solution, that uses type declarations instead.

## Credits

Some [insightful](http://patricklogan.blogspot.com/2004/12/roi-of-optional-type-annotations.html#110427380892002757) [comments](http://patricklogan.blogspot.com/2004/12/roi-of-optional-type-annotations.html#110434394113764682) on the equally insightful Patrick Logan's posting [The ROI of Optional Type Annotations](http://patricklogan.blogspot.com/2004/12/roi-of-optional-type-annotations.html) got me thinking about this.

## Addendum

I've added a follow-up [here](/archives/2005/01/three-lefts).
