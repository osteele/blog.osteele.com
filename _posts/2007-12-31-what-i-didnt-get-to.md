---
description: Some projects I didn't finish in 2007
date: '2007-12-31 23:25:23'
slug: what-i-didnt-get-to
title: What I didn’t get to
categories: [JavaScript, Libraries, Open Source, OpenLaszlo, Projects]
tags: javscript, libraries, Laszlo
---

Here are some of the weekend projects that I didn't finish this year.  These aren't good enough to put on my project list or my [sources page](https://osteele.com/sources/).  Some of these aren't even working, and some of them I might not finish at all (most of my weekends are spoken for).  And some of them I can't bear to look at (I'm not proud of the code, and don't want to be judged by it...), but I'm making myself put them out there anyway.  I feel bad for the neglected little things, trapped on my hard drive, and I'd like to let them see the sun, even if just briefly before they flicker out and die.

<!-- more -->

Libraries:

* [LzOSUtils](https://osteele.com/sources/openlaszlo/lzosutils) --- jQuery-compatible `ajax` function, Flash->JS bridge with callbacks, declarative Flash 8 filter effects, console that reports to Firebug, dashed lines, Prototype-compatible string and collection methods, etc.  Completely undocumented and fairly disorganized.

* [LzTestKit](https://osteele.com/sources/openlaszlo/lztestkit) --- mocks and asynchronous and automated testing for OpenLaszlo; still pretty raw.

* [HopKit](https://osteele.com/sources/javascript/hopkit) --- a "higher order programming kit", for constructed chained APIs such as in LzTestKit's mocks and expectations; still somewhat buggy and undocumented.

* [MVars](https://osteele.com/sources/javascript/concurrent) --- a port of Haskell [MVar](http://www.haskell.org/ghc/docs/latest/html/libraries/base/Control-Concurrent-MVar.html)'s to JavaScript.  I realized that what I actually needed for real-world applications was an implementation of the [join calculus](http://en.wikipedia.org/wiki/Join_calculus) (a la [JoCaml](http://jocaml.inria.fr/)).  I haven't written the join calculus version.

* [Protodoc](https://osteele.com/sources/javascript/protodoc) --- I wrote this to extract the docs from the source files and to implement the live examples in [Functional](https://osteele.com/sources/javascript/functional) and [Sequentially](https://osteele.com/sources/javascript/sequentially); it includes a version of the wonderful [doctest](http://docs.python.org/lib/module-doctest.html), for JavaScript.  I got part way through refactoring it into something that isn't quite put together again.  I haven't decided whether to finish it or whether there's an existing project that's close enough.

* [No link yet] Updates to [OpenLaszlo JSON](https://osteele.com/sources/openlaszlo/json/) and [ropenlaszlo](http://ropenlaszlo.rubyforge.org/), from using them over the past year.  (No, those links go to the old versions --- I haven't uploaded the updates :-(

* Implementations in [Ruby](https://osteele.com/sources/ruby/cfdg.rb) and [JavaScript](https://osteele.com/sources/javascript/cfdg)  of the awesome [CFDG](http://www.chriscoyne.com/cfdg/).  I wrote these a couple of years ago, and really want to update and clean them up to point where I can donate them to [Hackety Hack](http://hacketyhack.net/), or someone else who might use them.

Applets:

* [Tiles](https://osteele.com/applets/tiles.html) --- HTML port of my mid-nineties [Java version](https://osteele.com/applets/java-tiles.html) (which was a port of my mid-eighties C version), uses the Canvas tag; probably doesn't work in MSIE

* [IFS](https://osteele.com/applets/ifs.html) --- a few minutes of pair programming with my son to show him some stuff about matrices; probably doesn't work in MSIE

* [On this day](https://osteele.com/applets/onthisday/) --- iPhone applet; the feed is down right now

* Force-directed layout for my home page --- this was my experiment using HTML instead of Flash; I got discouraged when I saw how bad the frame rate for full-page animation is was even in Firefox, let alone MSIE (Safari rocks now, though!)

Plus a couple dozen essays that are half or three-quarters written (programming, software development, math education), a couple of AJAX presentations, and two workbooks for teaching abstract math at the elementary level.  It takes me longer to write an essay than a program, though!

More weekends, please.
