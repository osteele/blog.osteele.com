---
description: JSON and YAML came along and did this.
date: '2003-06-22 18:54:17'
slug: alternate-syntaxes-for-xml
title: Alternate Syntaxes for XML
categories: [XML]
tags: XML
---

Don Park [writes](http://www.docuverse.com/blog/donpark/2003/06/16.html#a597):

> I had been expecting baby talk versions of complex XML formats to emerge for sometime now.  It hasn't happened yet so I am left with scratching my head.  The idea is simple enough, take a complex format and create a user-friendly version that maps to the more complex version via an XSLT file.

if the problem is authoring a target format with redundant structure, where the extra structure makes the format more complex than it needs to be, then XSLT is a good solution.  (If the extra structure weren't redundant, an XSLT file couldn't add it.)  If the problem is the general verbosity of XML at representing any particular vocabulary, because of its impoverished grammar and punctuation, then you need another solution.

If you're going to write your document in a language that has to be transformed into a target document anyway, maybe it's better to ditch the markup.  These are some languages (or formats) that were designed to translate into XML:

* [RELAX NG Compact Syntax](http://www.oasis-open.org/committees/relax-ng/compact-20021121.html) -- for RELAX NG
* [n3](http://www.w3.org/2000/10/swap/Primer) -- for RDF
* Setext, [ReStructuredText](http://docutils.sourceforge.net/rst.html), and a large number of WikiText formats, designed to translate into HTML.

The reason not to use a domain-specific language for human-writable documents is that parsing is hard.  (One of XML's advantages is that a parser for a domain-specific langauge is only one or two lines in any modern language, as long as that domain-specific language is an application of XML.)  Todd Preobsting [suggests](http://research.microsoft.com/~toddpro/papers/disruptive.ppt) parsing for a subset of CFL languages as a builtin language feature, but for now learning how to use use a parser generator (such as [ANTLR](http://www.antlr.org/), [Yapps](http://theory.stanford.edu/~amitp/Yapps/), [Spark](http://pages.cpsc.ucalgary.ca/~aycock/spark/), [PLY](http://systems.cs.uchicago.edu/ply/)) is still a significant undertaking.

There's another reason not to write in a non-XML language, even if parsing were free.  That's that documents that are the _beginning_ of a pipeline today (that is, written by hand), often end up in the _middle_ of a pipeline as the infrastructure matures.  This has already happened with HTML, which was designed to be easy to author and parse, but is now frequently generated too.  XML can be serialized from a DOM or class bindings, or created by validity-preserving APIs such as [http://www.entrian.com/PyMeld/](PyMeld).  These tools have to be recreated for each new non-XML language.

A third advantage of XML is that parsers, generators, and even binding constructors are available for every modern language.  If there were a standard annotated EBNF format that worked with all the parser generators, then this wouldn't be a problem.

XSLT can be used to go the other direction too -- from XML to a non-XML text representation.  There are stylesheets that do this to generate n3 and RELAXNG CS.  But these are separate implementations from the parsers _from_ these formats _to_ XML, and that's a lot of overhead.

Something like reversible tree transformations [[A Language for Bi-Directional Tree Transformations](http://www.cis.upenn.edu/%7Ebcpierce/papers/lenses.pdf), by Michael B. Greenwald, Jonathan T. Moore, Benjamin C. Pierce, and Alan Schmit], combined with parsing constructors, might be a better technology for this.

Another alternative is [YAML](http://www.yaml.org/).  YAML is a general language that can represent many of the same structures as XML, but has made the tradeoff between human and machine readability differently.  YAML includes both parsers and generators for a variety of languages, so the pipeline and cross-language problems are solved.  [Okay](http://yaml.freepan.org/index.cgi?TheOkayProject) applies YAML to different XML applications -- _voila_! instant grammar.
