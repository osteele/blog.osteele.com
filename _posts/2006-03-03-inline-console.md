---
description: Portable JavaScript developer console &mdash; from before browsers had web developer consoles
date: '2006-03-03 23:10:37'
layout: post
slug: inline-console
status: publish
title: Inline JavaScript Console
wordpress_id: '191'
categories: [JavaScript, Libraries, Projects]
tags: JavaScript, libraries, obsolete
---

Last week for the first time I did [some serious browser JavaScript programming](/tools/rework).  I put the following tools to good use, but ran against limits with each of them:

* [fvLogger](http://www.alistapart.com/articles/jslogging) is terrific, but doesn't include an evaluator.  You have to reload your page each time you want to query a new value.

* [Rhino](http://www.mozilla.org/rhino/) is great for pure logic, but you can't use it with anything that use a browser API.  In fact, you can't use it with anything *that uses anything* that uses a browser API.  This means, for example, that you can't use it with a library that uses Prototype, without writing some mock objects first.

* The [JavaScript Shell](http://www.squarefree.com/shell/) is pretty amazing, but I wanted something a bit lighter weight (within the same window), and that works in Safari.

What I came up with is [inline-console.js]({{ site.sources }}/javascript/inline-console.js).  This file adds an output console, and a text field with an "Eval" button, to the bottom of your application.  It also defines some logging functions --- `info`, `debug`, `warn`, and `error` --- that append text to the console.  (If you include [fvlogger](http://www.alistapart.com/articles/jslogging), it will use it instead.)

The point of this is to be as lightweight as possible.  Add
`script type="text/javascript" src="inline-console.js"` (appropriately tagged) to the document head, and the script will take care of adding the UI.

For more fun, include [readable.js](/2006/03/readable-javascript-values) after inline-console.js.  Then `{a: 1}` will print as `{a: 1}` instead of `[object Object]`.

Here's an example.  Try entering some JavaScript expressions, such as `2*3`, `Math.sqrt(2)`, or `document.body`, and then pressing "Eval".  (Click [here]({{ site.sources }}/javascript/demos/inline-console.html) to open the example in a separate window, where you can view source.)

Files:

* [inline-console.js]({{ site.sources }}/javascript/inline-console.js) --- adds the inline console

* [readable.js]({{ site.sources }}/javascript/readable.js) --- adds readable representations for JavaScript objects (optional)

* [fvlogger](http://www.alistapart.com/articles/jslogging) --- a nicer console UI with more control over which log levels are displayed (optional)

My other JavaScript libraries are [here]({{ site.sources }}/javascript).
