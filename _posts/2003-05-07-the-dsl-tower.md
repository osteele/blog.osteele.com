---
description: DSLs
date: '2003-05-07 08:35:55'
slug: the-dsl-tower
title: The DSL Tower
categories: [Programming Languages]
tags: DSLs, programming-languages
---

A [domain-specific language](http://www.google.com/search?q=domain+specific+language) is a language for dealing with a specific problem domain, such as students at a university or entries in a blog.  DSL implementation has become so easy, and some of the domains have become so deep, that there's now a market for subdomain-specific languages (SDSLs).

There used to be two approaches to writing a DSL: (1) extend an existing language to include the new problem domain, or (2) write a parser and interpreter (or compiler) for the new language. With the first approach, you would implement objects that correspond to students and classes, and extend your language with a literal syntax for creating and referring to students, classes, and the relations between them.  With the second approach, you would write a parser for files that described students and classes.

You can only extend an existing language if it has an extensible syntax, and if its semantic primitives are rich enough to build new semantics from (or if the semantics of the domain language happen to already be a subset of the implementation language).  This is one of the reasons that Lisp advocates go on about macros and closures: macros extend the syntax, and closures are building blocks for semantics.  (It's only one of the reasons, because macros and closures are also used to extend the language in ways that aren't domain-specific too.)  That meant that everyone who didn't use a lisp-like language had to write parsers and interpreters to implement a DSL.  This made DSL implementation an expensive proposition.

The task of writing parsers and interpreters has recently become dramatically easier.  One reason is that XML parsers are ubiquitous, and XML can be used as a (verbose) syntax for any tree-structured language.  Another reason is that the primitives that make it easy to model domains and to implement interpreters --- object systems, hash tables (aka finite maps aka associative arrays), and lists --- are now built into most languages, or provided as standard libraries.  A third reason is that computers are now fast enough that an interpreter can be written in a rapid development P* language such as Python, Perl, or PHP.  And since the P* languages have dynamic linking, it's easy to create an open interpreter such that third parties can add language constructs (tags); this creates the technology infrastructure for a developer community.

The domain that I think has seen the most proliferation is the generation of content for web pages.  There's a huge number of DHTML systems for controlling the server-side generation of HTML: PHP and Cold Fusion are the examplars, but there are hundreds more.

Within the domain of page generation, there's the subdomain of content management, where textual (or graphical) content from one data source is aggregated and placed within a template.  Languages designed for this kind of page generation tend to be called template languages. Any decent DHTML language could be used for content management, just like any general-purpose programming language could be used for page generation, but just as in the latter case, a domain-specific language can express the same intent more succinctly, and is embedded within a developer community that is more likely to have tips and tools relevant to any specific problem within the domain area.

And within the subdomain of content management, blogging is a sub-subdomains.  Tag sets such as Movable Type and Blogger are just DHTML tags, for server-side generation of content, backed by domain models of the content of blogs and blog entries, but users are flocking to them rather than trying to implement the same thing in general purpose languages such as Java or Perl, conventional DHTML languages such as PHP, or page template languages.

The evolution of DSLs and SDSLs has so far mirrored the evolution of the web.  (And predictably so; the creation of new domains leads to an opportunity for new DSLs.)  Web pages lead to dynamic web pages lead to content-backed sites lead to blogs.  And there's a feedback loop, too: a DSL for a domain makes it easier to create a subdomain, which once it exists calls out for its own language.  All the work on tools for dynamic web page creation made it easier to implement blogging systems on top of those tools.

I wonder whether we'll see further subdomains within the world of blogging, and a newer generation of tools to address these subdomains?
