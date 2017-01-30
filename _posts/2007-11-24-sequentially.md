---
description: Fun library; these days I uses Promises instead
date: '2007-11-24 13:06:06'
layout: post
slug: sequentially
status: publish
title: "Sequentially: Temporal and Frequency Adverbs for JavaScript"
wordpress_id: '218'
categories: [JavaScript, Libraries, Projects]
tags: JavaScript, libraries, fun
---

[Sequentially](/sources/javascript/sequentially) is a JavaScript library for asychronous programming.  It makes it easy to define functions that are called later, or periodically, or that can be called only a certain number of times, or only at a certain frequency.

<!-- more -->

    // Call a function f five times in a row
    f.only(5).repeatedly()
    // Call f five times, at one second intervals
    f.only(5).periodically()
    // Make a new function g that calls through to f at most five times,
    // no matter how often g is called
    var g = f.only(5)
    // Make a new function g that calls f at most once per minute,
    // no matter how frequently g is called
    var g = f.infrequently(60*1000)
    // Apply a function to each of the elements of an array, at intervals
    // of once per second
    ['here', 'are', 'some', 'elements'].sequentially(
      function(word) {console.info(word, '->', word.length)})
      .periodically()

You can run these examples in your browser (Safari and Firefox only, for now) on this [page of examples](/sources/javascript/sequentially).  Mouse over the source code to see which outputs come from each statement.  Mouse over or click on the outputs to see which statement generates each output.

This is an early version.  Some aspects aren't well thought-out; some terminology isn't consistent.  Nonetheless, some early readers have urged me to put this out.

## Why?

Recently I wrote an browser application that did the following:

Ask the content server for an image.  If it's not there, ask the application server to queue a request to the image server to create it.  Then check back with the content server again.  If the asset doesn't show up after a while, the application server may have been down or overloaded, so ask it again.  But I don't want the client applications to mount a DDoS attack on an ailing server, so back off the frequency of the requests, and then give up, after a while.

Why?  I'd like to be able to run client applications that present data from a cluster of unreliable commodity hardware (the same as Erlang; the same as [CouchDB](http://couchdb.org)).   This means these clients must survive component-wise server failure: they should implement retries (when a server is temporarily overloaded), then transition to failover (when it's out for the count).

My first pass at this was a tangled mess of domain logic, network requests, and control code.  It was way more complex than it ought to have been, especially for such a general design pattern.

The basic concepts here are simple: repetition ("keep asking, but not too many times...") and frequency ("...and not too frequently").  Simple concepts should be simply spelled.

You can think of Sequentially as a tiny little domain-specific extension to JavaScript, that defines words for these concepts.

## Some Analogies

I use this in a style I call "adverbial programming".  Another example of adverbial programming would be some uses of AOP.

Someday I'll post an entry about the analogy between computer languages and natural languages.  For now, simply note that methods such as "only" and "infrequently" modify a function (a verb) to produce a new function with a related meaning --- this is the same as (one of the senses of) an adverb.

This is in contrast to procedural programming, which assembles statements into paragraphs with aggregate effect; object-oriented (OO) programming, which assembles noun phrases; and functional programming, which is largely about verbs[^1].  (Closures, which bridge the gap between the functional and OO style, are gerunds.)

Here are some other analogies for thinking about thinking about this.  This is all kind of notional, but I found these useful in suggesting how this relates to other work, and where to take it next.

You could think of Sequentially as doing something like memoization, where instead of just caching the result it modifies _when_ and_whether_ a function is called.  Alternatively (and very loosely), Sequentially is the categorical dual of [generators](http://en.wikipedia.org/wiki/Generator_%28computer_science%29) (it builds sinks instead of sources), in a partially CPS-converted program. Or, if you took the call graph of a program, turned that into a dataflow diagram, and implemented a dataflow interpreter for that diagram, then Sequentially would override some of the pipes.  Or (again, loosely) it's a kind of two-way dual of [Functional JavaScript](http://osteele.com/sources/javascript/functional) in [Chu space](http://chu.stanford.edu/) --- instead of _collecting_ _values_ (arguments) across _state space_, it _distributes_ _function calls_ across _time_ (sequence).

Or maybe that's all overkill, and it's just a few combinators for frequency, iteration, and time.

---

[^1]: More accurately, functional programming is about saturating the argument positions of both nouns and verbs.  Its closest analogy is to _theories_ of language, such as Montague Grammar and Categorial grammar, rather than to language _itself_.  This may be why functional programming is for many people less than intuitive.
