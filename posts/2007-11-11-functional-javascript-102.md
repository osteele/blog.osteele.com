---
description: Functional JavaScript update
date: '2007-11-11 15:34:11'
layout: post
slug: functional-javascript-102
status: publish
title: Functional Javascript 1.0.2
wordpress_id: '214'
categories: [JavaScript, Libraries, Projects]
tags: [JavaScript, libraries, functional]
---

Thanks to everyone who has commented or contributed, praised or pitched in --- I've released an update to [Functional Javascript](/sources/javascript/functional), with these changes:

<!-- more -->

### New features

- Rhino compatibility.  I think --- at least it loads now, and a couple of hand tests work; i have yet to port the testing tool.  (Credit: [Reginald Braithwaite](http://weblog.raganwald.com/))

### Optimizations

- More efficient Array.slice.  (Credit: [Dean Edwards](http://dean.edwards.name/))
- Memoize Function.lambda.  (Credit: [henrah](http://code.google.com/u/henrah/))

### Packaging changes

- Added jsmin version.  With jsmin and gzip, the file is 2.5K.
- Moved string lambdas to a separate file, `to-string.js`.  (Both files are included in the jsmin version.)
- Reformatted for new version of the doc tool.

### Compatibility notes

If you were including `functional.js` before, now you need to include both `functional.js` and `to-function.js` in order to get the string lambda conversion functions too.  Or you can include `functional.min.js`, which is smaller and includes them both.

The fact that functional.js itself no longer contains any regular expressions might make it usable in Flash.  I haven't actually tried this, because the only Flash I use is OpenLaszlo, which is still at version 8 of the Flash file format (AVM2, no JIT, <del>&lt;25% browser speed</del> method calls are 10% of Firefox 2 / Safari 3.0 speed).  I don't dare program at too high a level in Flash 8 because of performance concerns.

## Meanwhile, over in Ruby land...

I'll also put in a plug here for Braithwaite's [String#to_proc](http://weblog.raganwald.com/2007/10/stringtoproc.html), which is a port of string lambdas to Ruby:



    (1..5).map &'*2'
      -> [2, 4, 6, 8, 10]
    (1..5).inject &'+'
      -> 15
    factorial = "(1.._).inject &'*'".to_proc
    factorial.call(5)
      -> 120


I've been a Raganwald fan for a while; and Ruby is my favorite server-side glue language, I look forward to using it there...

