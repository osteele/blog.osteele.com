---
description: Nowadays I use Promises for things like this
date: '2008-04-20 18:28:00'
layout: post
slug: conquering-busy-cursor-sequentially
status: publish
title: Conquering the Busy Cursor with Sequentially
wordpress_id: '295'
categories: [JavaScript, Libraries]
tags: JavaScript, concurrency
---

What's wrong with this function?  (Hint: it's meant to execute periodically on a JavaScript page.)

    function updateExpirationText() {
      var now = new Date;
      products.forEach(function(item) {
        var expiresDate = item.expiresDate || Date.parse(item.expires),
            remaining = expiresDate - now,
            text = remaining < 0 ? 'expired' : msToDuration(remaining);
        $('item-' + item.id + ' .time-remaining').text(remaining);
      });
    }

<!-- more -->

It's a trick question.  Maybe nothing's wrong.  But if `products` can get very long, or if the `msToDuration` is very slow, you've locked up the UI for a long time.  At best, this makes for sluggish response; at worst, the page that contains this will trigger a "script running slowly" error, and the user will likely abort all the JavaScript on the page.

If this computation only needs to run once, and when (or before) the page loads, you can do it on the server.  But often a computation depends on some aspect of the client state, that isn't known when the page is requested.  In this example, the computation depends on the current time (and the current time keeps changing).  In another case, the computation might depend upon the values of some controls or other widgets on the page -- if we've gone all AJAXy, and want to show the user an instant response, even if that means some client-side computation.

Here's an alternative to the function above, that doesn't lock up the page.  It uses `Sequentially.trickle.forEach`, a new function in [Sequentially](http://osteele.com/sources/javascript/sequentially).  This function walks its second argument over some span of the first argument -- up until 250ms has passed, in this case -- and then sleeps for a frame (via `setTimeout`) before waking up to walk over the next span, until all is done.  This gives time back to the browser (and to other `setTimeout` and `setInterval` threads), and avoids the "script running slowly" error.  Note the one-line change: `"products.forEach("`" becomes `"Sequentially.trickle.forEach(products,"`.

    function updateExpirationText() {
      var now = new Date;
      Sequentially.trickle.forEach(products, function(item) {
        var expiresDate = item.expiresDate || Date.parse(item.expires),
            remaining = expiresDate - now,
            text = remaining < 0 ? 'expired' : msToDuration(remaining);
        $('item-' + item.id + ' .time-remaining').text(remaining);
      }, 250);
    }

Sometimes you need to run some code after the iteration is done.  In other words, sometimes you need to transform a function that looks like this:

      var startTime = new Date;
      array.forEach(function(item) { ... });
      console.info(new Date - startTime, 'elapsed');

(Here, the code that runs after the iteration just reports how long the iteration took.)

You can do that with a continuation function (or callback), the same as you would with an AJAX request:

      var startTime = new Date;
      Sequentially.trickle.forEach(array, function(item) { ... }, 250, k);
      function k() {
        console.info(new Date - startTime, 'elapsed');
      }

JavaScript being lexically scoped, you can refer to all the same variables from a nested function (`k`).

There's a `Sequentially.trickle.map` too.  Since the return value can't contain the function application results yet when the function returns, you have to get them back from the callback.  Before (the synchronous version):

      var results = array.map(function(item) { ... });
      console.info('Results:', results);

and after (asynchronous):

      var startTime = new Date;
      Sequentially.trickle.map(array, function(item) { ... }, 250, k);
      function k(results) {
        console.info('Results:', results);
      }

