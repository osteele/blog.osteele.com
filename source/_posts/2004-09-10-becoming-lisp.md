---
date: '2004-09-10 19:50:10'
layout: post
slug: becoming-lisp
status: publish
title: Becoming Lisp
wordpress_id: '104'
categories:
- Programming Languages
tags: [Python, programming-languages]
---

Python really is [becoming lisp][google-becoming-lisp].  With the [type/class unification](http://www.python.org/2.2/descrintro.html), [decorators](http://www.python.org/cgi-bin/moinmoin/PythonDecorators), and [generator expressions](http://www.python.org/peps/pep-0289.html), it's jumped from 80 percent of Common Lisp + CLOS to 90 percent[^1], and for web tasks the web programming libraries often make up the difference.

I've listed below some of the functional and metaprogramming recipes and packages that have shown up in [PyPI](http://www.python.org/pypi) and the [Python Cookbook](http://aspn.activestate.com/ASPN/Python/Cookbook/) over the past few weeks.  [As of Memorial Day weekend, when I first wrote this.  I didn't post it until a week later.  My [real job](http://laszlosystems.com) is heating up :-]

The point is not that these recipes exist.  There's plenty of clever Perl preprocessor hacks; there's some pretty amazing [C++ template metaprogramming libraries](http://www.google.com/search?q=c%2B%2B+template+metaprogramming); and I bet if you scoured the web you could find this many recipes for Java reflection.  (Well, I don't bet very much on the Java part.  I'll buy you an ice cream at [Bart's](http://www.amherstarea.com/business/index.cfm/fa/showBusiness/CompanyID/138.cfm). First taker only.)

The point is that these are flowing in fast and furious, and that they don't take much code.  The recipes below are from just two weeks.  There's half a dozen functional programming recipes, and a dozen MOP (Metaobject Programming) recipes; many of them are one-pagers.  There were some real wizards in the Lisp community, but I don't recall anything like this pace of development on top of the CLOS (Common Lisp Object System) MOP (Metaobject Protocol, this time).

_Two weeks_ of MOP(Metaobject Programming) and reflection recipes:

* [Overriding __new__ for attribute initialization](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/303059)

* Named tuple items: [here](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/303439) and [here](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/303481)

* [Cacheable value objects"](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/302699)

* [Thread-safe caching](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/302997)

* [Simpler `super` syntax](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/286195)

* [Constants](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/65207)

* [Prolog syntax](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/303057)

* [Named Singletons](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/286206)

* [Handler design pattern](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/302422)

* [Monostate design pattern](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/66531)

* [Simplified Mutable Instances](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/299777)

Two weeks of functional programming recipes:

* [izip inverse (starzip)](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/302325)

* [Batched iterables](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/303279)

* [Windowed iterables](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/299529)

* [Grouped iterables](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/303060)

* [Coroutines](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/300019)

* [Cartesian product](http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/302478)

Web programming in August:

* [The Whole Web in a Dictionary](http://www.mnot.net/blog/2004/07/31/http_py)

* [Webcleaner](http://webcleaner.sourceforge.net/), a filtering HTTP proxy

* [rxrdf](http://rx4rdf.sf.net/), an RDF application stack

* [milter](http://www.bmsi.com/python/milter.html), interface to sendmail milter API

* [itools](:http://sf.net/projects/lleu), uri, resources, handlers, i18n, and workflow tools

* [libgmail](http://libgmail.sourceforge.net/), a binding for Google's Gmail service

* [naja](http://www.keyphrene.com/), a download manager and a website grabber

* IRC bots: [pyfibot](http://tefra.fi/software/) and [supybot](http://supybot.sf.net/)

* [linkchecker](http://linkchecker.sourceforge.net/), not sure what this does :-)

And [hotswap](http://www.krause-software.de/python/) finally adds object evolution (what "live edit").

[^1]: Percentage gains are subjective and are based on simulated exploratory programming conditions.  Actual productivity will vary with hardware speed, workplace environment, develpment habits, and problem complexity.  Results reported to SEI indicate that the majority of projects with these estimates will achieve between 71% and 123% of Lisp productivity in single-person projects and between 83% and 159% in team projects.

[google-becoming-lisp]: http://www.google.com/search?q=%22becoming+lisp%22
