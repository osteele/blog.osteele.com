---
date: '2006-03-03 17:15:56'
layout: post
slug: readable-javascript-values
status: publish
title: Readable JavaScript Values
wordpress_id: '188'
categories:
- JavaScript
- Libraries
- Projects
tags: [JavaScript, libraries]
---

One problem with JavaScript development is that the string representation of a value doesn't tell you much about the value.  For example, `[null]`, `[undefined]`, and `''` all display as the empty string.  `[1,2}`, `[[1,2]]`, and `[[^1],[^2]]` all display as `1,2` (and so does `"1,2"`).  And `({a: 1})`, `({b: 2})`, and `new MySwankyNewObject()` all display as `[object Object]`.

<!-- more -->

If you [use an IDE](/archives/2004/11/ides) for development, this may not be a problem.  Probably the IDE has its own string representation; even if it doesn't, you can generally drill into objects by clicking on them.  This doesn't help those us of who prefer REPL development or printf-style debugging.  When you display a debugging value (to the browser status line, to the `alert()` dialog, or to the Rhino console), you'd like some indication of what it actually _is_.  And JavaScript doesn't generally tell you, at least when the value is more complex than a string, number, or boolean.

Hence, [readable.js](/sources/javascript/docs/readable).  _Readable_ adds a Readable class that can stringify a JavaScript value readably, for debugging purposes.  Readable.toReadable([1,'', null, [3, 4]]) evaluates to [1, '', null, [3, 4]], not 1,,,3,4.  And so on.

To make it easier to *use* the Readable class, *Readable* comes with a couple of hooks.  First of all, it defines defines info, warn, error, and debug functions[^1] that display their arguments to the user.  In Rhino, these functions call through to `print`.  In a browser, they use `alert()` --- unless [fvlogger](http://www.alistapart.com/articles/jslogging) has been loaded first, in which case they use it instead[].  You can also replace Readable.log(level, message) or
Readable.display(message) to add your own behavior; for example,
to display the message in the status line, or AJAX it up to the server.

Secondly, Readable can add toString methods to Array.prototype and Object.prototype.  Do this, and evaluating an expression in Rhino writes a readable representation to the console, without your having to wrap it in `info(...)` or `Readable.toString(...)`.  Doing this has the consequence that iterating over the properties of an Object or Array will yield an extra one (toString), so this is off by default.  But define READABLE_REPLACE_TOSTRING *before* loading the file, or invoke `Readable.replaceToString()` *after* loading it, and you'll get this behavior.

Files:

* [readable.js](/sources/javascript/readable.js)

* [documentation](/sources/javascript/docs/readable)

**Update**: Fixed for Internet Explorer.

---

[^1]: The reason there's more than one function is that this is intended to be consistent with [fvlogger](http://www.alistapart.com/articles/jslogging).  It's also handy to be able to search your sources for one logging function, and not the other.

[^2]:  One advantage of including *Readable* even if you're already using fvlogger is that now `info([1,2])` prints something different from `info([[^1],[^2]])`.  Another is that *Readable* extends the fvlogger functions with variadicity: `info(key, '->', value)` works now.  (Without *Readable*, it's equivalent to `info(key)`, except that `value` is also evaluated for effect.)  Finally, you can use *Readable* to extend Rhino with the same logging API.  I use this to write modules --- such as [paths and beziers](/archives/2005/02/javascript-beziers) --- that I test with Rhino and integrate into a UI in the browser.

