---
description: Thoughts on designing a programming language
date: '2003-05-13 01:05:34'
slug: designing-a-language
title: Designing a Language
categories: [Programming Languages]
tags: programming-languages
---

One of the things we're building at Laszlo is LZX, a language for Rich Internet Applications. (Some of the other things we're building are the client, server, and compiler pieces necessary to make applications written in that language actually do anything.)

Language design is a process, and there's process-specific knowledge about how to do it. Much of the knowledge is the same that's needed to design an architecture, or an API; some of it is language-specific. Here are some of the principles I've found helpful in designing LZX:

#### Know the Past

Starting with Fortran and Lisp (two languages created in the same year), there's been almost half a year of computer language history to draw on. Many of the pitfalls of language design (dynamic scope, misuse of namespaces) are known; some of the other difficult areas (the distinctions between declarative and procedural programming, class and macro design) have been extensively explored, and there's a lot of past experience to draw on.

In the design of LZX, I've tried to find analogues to each construct in other languages, so that I have some idea of what the problems introduced by those constructs will be and what solutions already exist.

An example is the use of namespaces. There's several different types of entities in the system, and special syntactic forms (that is, XML tag names) that introduce them. It's tempting to give each one its own namespace, and, for technical and historical reasons, a couple of them (fonts and resources) do have their own namespaces. But experience with other languages that take different stands on this, and in particular with _teaching_ Common Lisp (which has two namespaces) and Scheme (which has one), makes me think that while having multiple namespaces avoids a class of name collision problems, it also makes the conceptual model of the language more difficult and it makes the language much harder to get started with. LZX has as few as we can manage.

#### Know the Present

We try not to design anything we don't have to, but to use standards instead. Designing a system is like cooking, and standards are the ingredients: you have to know what's available and which ones can mix. LZX uses XML and JavaScript, even where we think we could improve on them. It uses XPath for DOM reference, and a system like XStyle for data binding. And it uses XBase and XInclude for compile-time program composition.

The advantage of standards is that it lets you use network effects. Using standards allows both the language implementors and its developers to use standard tools, documentation, and skill sets. And it increases the attractiveness of developing tools and skills related to the language, because these assets then have more general use than the language itself. To learn LZX you don't have to be convinced that LZX will be successful or that you'll be using it a lot; you just have to be convinced that XML and JavaScript will be useful to you at some point, and maybe that the domain-specific extensions to deal with rich internet applications will teach you something you'll find useful anyway about that application area.

Another other reason to avoid new designs is that each area that has to be designed is both a time sink and an opportunity for error. Language design errors don't usually show up immediately, in a way that can be uncovered by a test suite or a QA process. They show up as difficulties learning or using the language (which are difficult to uncover, because developers don't report them and may not even recognize how much of their difficulty is due to the language design), or forward compatibility problems, where the language can't be extended to handle changes or additions.

#### Have a Design Process

I was at Apple Cambridge during the design of the [Dylan programming language](https://osteele.com/museum/apple_dylan.html). While I was there, several of my coworkers (David Moon and Kim Barrett, at least) were involved with the final stages of the Common Lisp language standard. These were two different points along a spectrum of process formality. LZX design is currently much less formal than either of these, but it does follow a process, and that process is a rational excerpt of the more formal processes.

It's important to keep the language from swaying in the wind as new features and opinions pass by, because each aspect eventually solidifies, and there's no guarantee that it will freeze into a viable position instead of an arbitrary extreme. What freezes a feature is the widening wake of backwards compatibility, to mix in another metaphor. This is true of software in general, and framework and APIs more; I believe it's true of language design most of all. A design and review process for language changes can help damp the oscillations in a controlled manner before compatibility issues set in.

#### Use Mock-ups

One of the things I learned from working with visual designers was how to solve non-visual design problems. My math and science background had prepared me to solve single-solution problems, where success lay in coming up with any solution at all. Engineering added the idea of constraints, where multiple solutions can be ranked according to some set of constraints such as size and space constraints. An engineering and science background doesn't prepare one to solve usability problems, which neither have a single solution nor can be ranked by any objective criterion. A language is a user interface, and much of language design is about solving usability problems.

Visual designers prototype multiple solutions to a problem, compare them, and iterate. This is a useful process for language design as well. It goes beyond use cases in that a set of solutions, instead of a single solution, is evaluated against each use case.

Among all the tradeoffs in the design of LZX, the most frequent has been between internal consistency and standards compatibility. Often usability is the tiebreaker.

#### Watch the Curve

Another tradeoff is between easy adoption ("simple things should be simple") and power use ("complex things should be possible" --- or, since everything should be possible in a Turing-complete language, "not too hard"). I think of this in terms of the language learnability curve, which is a hypothetical graph of how much effort is required to reach each increment of proficiency. (It's hypothetical because it's unrealistic to define effort, and probably impossible to usefully define proficiency.)

I don't want to flatten the left side of this curve, at the expense of creating an inflection point for the user who wants to get beyond being a beginner. Too many special cases built into the language do this. For instance, a calendar component would be nice in a language for rich internet applications, but if there were a great disparity between the ease of using a calendar component, and the ease of writing one, then the user who needed a modified calendar or a slightly different component such as a bearing log would hit the wall.

Conversely, if you make the curve level then it's either at zero all the way across (and you can't do anything with it), or it's steep at the left border, and is unapproachably difficult.

#### Turtles All the Way Down

The worst wall for a language user is discovering that you need to reimplement in another language. (Language integration technologies ameliorate this problem, but only somewhat; we can't use them right now anyway.) The second-worst wall is to discover that you've got to reimplement something that the language already does, because the language doesn't do it quite right.

#### Know the Domain

A language for Rich Internet Applications is a Domain-Specific Language (DSL). Designing a DSL requires knowledge of the principles of language design (everything else on this list), but also of the domain itself. We've put a lot of thinking into the domain of Rich Internet Applications, and the structure of the applications, and this is reflected in the features of LZX. This is an important area, and I'll write more about it in the future.

#### Lightweight Language Principles

The discussions at the [first Lightweight Language Workshop](http://ll1.ai.mit.edu) in 2001 were very helpful to me. (LZX was first publicly presented at the [second Lightweight Language Workshop](http://ll2.ai.mit.edu) in 2002.) These principles were distilled from those discussions and from the mailing list discussions that followed:

Hello world should be short
The need for "boilerplate" is a bad sign.
Read-Event-Print Loop
An expression evaluator is more useful than source debugging for exploratory programming and test-driven development.
