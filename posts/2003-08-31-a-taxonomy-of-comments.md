---
description: Some different uses for programming language comments
date: '2003-08-31 00:47:51'
layout: post
slug: a-taxonomy-of-comments
status: publish
title: A Taxonomy of Comments
wordpress_id: '64'
categories: [Essays, Programming]
tags: [programming, essays]
---

Christian Sepulveda writes about [comments in source code](http://christiansepulveda.com/blog/archives/000028.html):

> Not all comments are bad. But they are generally deodorant; they cover up mistakes in the code. Each time a comment is written to explain what the code is doing, the code should be re-written to be more clean and self explanatory.

This statement is provocative and interesting, but wrong.  There are more good uses for comments than bad ones.  (The rest of Sepulveda's posting is more nuanced, and much of what I write here expands on points he makes.)

Comments are an escape hatch for expressing everything about a program that the programming language can't.  Comments therefore [don't fall into a single natural category](http://www.u.arizona.edu/~bedford/papers/FORUM-Bedford.pdf).

Rather than stating a single purpose or use for comments, one can start by stating the purpose of the non-comment portions of the source code.  Comments are used for everything else, which is at least the following:

## The Coding Compromise

Non-comment source code is a compromise among meeting the needs of two classes of consumers: compilers and runtimes on one hand; and human developers on the other[^1].  The priority given to each of these consumers depends on the context of the program's development and deployment.  An example at the level of programming language selection is that I use C++ for performance-critical applications or deployment to resource-limited platforms, but for more readable programs I use Python.  However, even within a specific context, the compromise is always present.

[^1]: There are of course also tradeoffs within each of these audiences: for example, size versus speed for program execution; readability by domain experts versus programming language experts on the human side.

Comments don't have to meet this compromise.  A line of code may legitimately be biased towards program execution (the compiler audience), but the line of code plus its comment can meet the needs of the human reader as well.

As an example, let's look at the inner loop of the scan convertor for a graphics library that I worked on.  This loop is responsible for drawing spans within a polygon.  A span is the portion of a scan line from the _x_ position of an edge on the left side of the polygon's interior to the _x_ position of the next leftmost edge on its right.  The definition of "interior" depends on the [fill mode](http://www.google.com/search?q=winding+number) of the polygon.  Since (for source size and code size reasons) a single function implements both fill modes, the way that this function computes the interior of the polygon is conditional on the fill mode.

If I'm implementing the computation for human readability, especially by someone who isn't familiar with low-level graphics programming, the initialization code, and the code to handle an edge transition, might look like this:

    bool inside = false;
    int windingCount = 0;

    if (windingType == kEvenOddFill) {
       inside= !inside;
    } else {
      windingCount += edge->direction;
      inside = windingCount != 0;
    }

(If I cared more about abstraction and flexibility, I might even turn `windingType` into an instance of a class with an update function:
`windingType.updateState(edge);`
`inside = windingType.isInside();`)

The same functionality coded for runtime efficiency might instead look like this:

    int windingMask = (windingType == kEvenOddFill) ? 1 : -1;
    bool inside=false;
    int windingCount = 0;

    inside = windingCount & windingMask;

The efficient code uses integer/bitfield and integer/boolean puns which wouldn't even compile in a strictly typed language, but which take advantage of the implementation of values of these types in C++ to optimize the performance characteristics of the program.  (It also uses a clever hack that I was proud of at the time.)  These tricks turn the process of reading the source, however, into an exercise in reverse engineering.

Comments ameliorate this reverse engineering process, by speaking _sotto voce_ to the human audience:

    // windingMask tells which bits of the windingCount to test.
    // For even-odd fill, test the low bit, to tell whether the number is odd.
    // Otherwise, test all the bits, to tell whether it's non-zero.

## The Limits of Expression

Another reason for a comment is to compensate for the limits of the programming language at hand.  There is often no way to express the design of the program within the syntax of a particular programming language.  Languages in mainstream use have become moderately good at abstracting over data structures; they're less good at abstracting over types, control structures, definition patterns, or patterns of composition, and they generally lack means of describing design patterns or architecture[^2].

A comment can add information about a program's design, such as that the program implements the Pipes-and-Filters [architecture](http://www.amazon.com/exec/obidos/ASIN/0131829572/steele-20), that a class implements the Flyweight [Design Pattern](http://www.amazon.com/exec/obidos/ASIN/0201633612/steele-20), that a declared `float` represents _feet_, or that a declared `String` may be null.  There are languages which can express each of these facts directly, in which case the comment is superfluous, but chances are you aren't using one of them.

[^2]: Haskell is good at expressing abstractions over types; C++ is better than Java.  Languages with either a lightweight syntax for closures (aka blocks), such as Smalltalk and Ruby, or with structural macros such as [JSE](http://www.ai.mit.edu/~jrb/jse/index.htm), or with both such as [Dylan](http://directory.google.com/Top/Computers/Programming/Languages/Dylan/?tc=1) and [Scheme](http://directory.google.com/Top/Computers/Programming/Languages/Lisp/Scheme/?tc=1), can express abstractions over control structures.  Languages with definition-level macros or modifiers such as [Bigwig](http://www.brics.dk/bigwig/oldindex.html), Dylan, Lisp, or [Elide](http://www.cs.ubc.ca/labs/spl/projects/explicit.html) can abstract over definition patterns.  Architecture languages such as [ArchJava](http://www.cs.washington.edu/homes/jonal/archjava/) are still in the research stage.

## Levels of Abstraction

Source code is typically written only at one level of abstraction.  It may combine different units of _structure_ or _composition_, such as methods, classes, and packages, but the source code typically doesn't contain both statements that express something in a high-level or coarse-grained way, and the same thing in a low-level or fine grained way.  (An exception is invariants in [Eiffel](http://www.cetus-links.org/oo_eiffel.html), which express the abstract _what_ as well as the concrete _how_.)  After all, this would be redundant, from the perspective of the compiler.

The human reader, on the other hand, would like to be able to understand the purpose of a code block, function, or package without reading its implementation.  Different audiences care about different levels of detail, and at different times.  An API user needs a description of a method's external behavior; someone working on the implementation of a method needs a high-level understanding of its implementation or algorithms as a roadmap of the implementation, maybe an overview of what each block does, but a line-by-line understanding of a particular block within the method at only a particular time.  Source code is either there or not, and often can't be easily skimmed; comments let the reader turn the dial to positions betweeen no information and too much.

## Program as Palimpsest

_A comment is a note from the past to the future._

I write a comment wherever I'm afraid someone might change the program for the worse.  One reason this might happen, discussed above, is because the program's design isn't evident in the source.  Another is that the reason for an implementation decision comes from data that isn't present in the design.  Corner cases and performance metrics are two kinds of data that aren't present in a program's design.  Changes made in response to these data frequently result in code that's suboptimal from a readability perspective, and that in the absence of that data would appear to be redundant.  In the absence of information to the contrary, this code should be optimized out, for performance and code size reasons as well as from a readability perspective.  Comments are a protection against this form of regression.

For example, I've written code like this:

    if (shape.bounds.contains(point) && shape.contains(point)) ...

First this code tests if the bounding box of the shape contains _point_; if it does, it tests if the shape itself contains _point_.  The first test is redundant.  It's extra source text to read, extra code to maintain (if I rename "shape" or "point", there's one more subexpression to edit), extra code to deploy, and it breaks the [Law of Demeter](http://c2.com/cgi/wiki?LawOfDemeter) -- it increases the coupling between this code and the implementation of the class of _shape_.  As it stands, in my book, this is bad code.

Here's a non-executable line that, prepended to the example above, changes it into correct code:
`// On a 400MHz P5, testing shape.bounds speeds text tracking by 10%`

Without this line, there's nothing to indicate whether the code is the result of premature and possibly misguided optimization, or whether it actually provides some benefit to compensate for its readability and maintainability shortcomings.  With it, the source code records its own history; if anyone decides to remove the hard-won optimization, it won't be out of ignorance.

Joel Spolsky has written an [essay](http://www.joelonsoftware.com/articles/fog0000000348.html) about corner cases.  I'll just add that corner case code looks like optimization code: without a comment it's hard to tell whether it's contingency or clutter.

## Time Bomb or Time Capsule

Comments are also a place to put wishlist items and to-dos.  Some of these may be "mistakes in the code", but an item can be a mistake in the code without being a mistake in the software development process.  The point of software _engineering_ is to make tradeoffs between implementation speed, implementation resources, deployment resources, and code quality.  Sometimes putting all the emphasis on code quality or feature completeness is the wrong way to make the tradeoff -- for example, when bytes count, when days count, when the code is throwaway and the corner condition will never be met , or when the enhancement isn't yet useful.

When the developer knows that a corner case is present or that an enhancement is possible, comments add a choice between implementing it immediately on one hand, and ignoring it altogether on the other.  The first alternative is expensive immediately, because of its affect on the schedule and its distraction from work implementing the more important use cases.  The second is expensive later, because it loses information that's available now and that may have to be recreated then.

A comment at the implementation site can document the cause of the error in implementation terms, or collect notes about how the missing condition could be handled.  The comment captures knowledge from construction time, when it's available, and saves it for maintenance or enhancement time, when it's useful.

## The Path to Deployment

Conventional programming languages define program execution, but don't express information about activities that occur before the deployed program is executed.  Other activities than execution require other artifacts.  Development requires examples.  Testing requires tests and contracts.  Deployment requires packaging information.

These artifacts can be placed in separate files.  Often they're ephemeral, such as a test case that is typed into the command line and then discarded.  But it's convenient to keep these artifacts close to the program units that they describe, so that they can be updated and reused as the program evolves.  Many of them are also useful to the human reader trying to understand the program: for example, the examples and tests that drive and verify development make useful API documentation too.  Capturing these artifacts in comments is a way to do meet these needs.

(All of the other uses of comments are a special case of this point.  Design notes and explanations support construction, maintenance, and white-box testing, which are all non-execution activities.)

## The Third Consumer

I wrote at the beginning of this entry that there were two consumers for source text: humans, and the compiler.  I lied.  There's a third class of consumers: comment processors, which treat comments as source code in an supplementary language -- a language that fills gaps in the coverage of the source code's primary language.

Tim Peters's [doctest](http://www.python.org/doc/current/lib/module-doctest.html) treats comments as unit tests.  [iContract](http://www.reliable-systems.com/tools/iContract/iContract.htm) reads comments for pre- and post-conditions. [XDoclet](http://xdoclet.sourceforge.net/) is an extensible processor, preconfigured to read packaging and deployment descriptions.   These tools address the non-execution activities of software development.

[SPARK](http://pages.cpsc.ucalgary.ca/~aycock/spark/) is a generic parser that reads BNF productions from the comments of methods that their semantic actions.  It patches the failure of Python to abstract over defining forms.

All of these functions of comments as metadata could be implemented by extending the language instead.  (Contracts are from Eiffel, for example, which supports them in its core syntax.)  However, the use of structured comments as metadata lets a third-party tool address a gap in the language in a way that leaves the source structure intact for compilers and other source processors (such as editors, source debuggers, and refactoring tools) that wouldn't recognize an extended grammar.  Just as comments are an escape hatch for human readers, they're an escape hatch for development tools as well.

And these two kinds of comments -- natural language and structured metadata -- are related.  They both add information that can't be expressed in the primary programming language.  And they're both useful to humans too.

---
