---
description: Modern test libraries do this
date: '2008-04-20 18:28:08'
slug: mock-setcleartimeoutinterval
title: A Mock for {set,clear}{Timeout,Interval}
categories: [JavaScript, Libraries]
tags: JavaScript, libraries, GitHub
---

Here's a potential [JSSpec](http://jania.pe.kr/aw/moin.cgi/JSSpec) spec for `Sequentially.trickle.map`:

    describe('Sequentially.trickle.map', {
      'should apply to all the elements': function() {
        Sequentially.trickle.map(
          ['a', 'b', 'c'],
           function(x) { return x + 1 },
           1,
           function(result) {
             value_of(result.join(',')).should_be('a1,b1,c1');
           });
        });
      }
    });

<!-- more -->

This doesn't work.  The problem is that `Sequentially.trickle.map` is asynchronous (it defers most of its computation -- including the invocation of the callback -- via `setTimeout`).  This means that `should_be` isn't called until after the spec has returned.  If it succeeds, this isn't a problem, but if it fails, JSSpec can't associate it with the failing spec -- worse, JSSpec will have already have marked it successful.

Here's the version that I [actually used](http://github.com/osteele/sequentially/tree/master%2Fspecs%2Fsequentially-specs.js?raw=true):

    describe('Sequentially.trickle.map', {
      'should apply to all the elements': function() {
        withMockTimers(function() {
          Sequentially.trickle.map(
            ['a', 'b', 'c'],
             function(x) { return x + 1 },
             1,
             function(result) {
               value_of(result.join(',')).should_be('a1,b1,c1');
             });
          });
        }
    });

`withMockTimers` temporarily replaces `setTimeout` and friends with its own deferred execution system, so that it can make sure to call them all before it returns.  Get it [here](http://github.com/osteele/sequentially/tree/master%2Fspecs%2Fmock-timers.js?raw=true).

## Limitations

This approach has its limits.  It doesn't mock `new Date` to pretend that more time has passed, so whether it works or not will depend on how your code _uses_ the timers (if it keeps an interval running or re-submitting a timeout until an amount of time measured on `new Date` has passed, it will probably get a "script running slowly" error).  And, I don't know how kosher it is to replace `setTimeout` -- this let me test against Firefox 2.0 and Safari 3.1; I haven't tried on Opera and MSIE.  Nonetheless, it got me what I wanted here -- unit tests for the new methods in [Sequentially](https://osteele.com/sources/javascript/sequentially).

(I've got a [more involved implementation](http://github.com/osteele/lztestkit) that patches the test suite to run callbacks within an emulation of the dynamic scope of the original test function, but it's tricky, and I haven't got it integrated with JSSpec -- or any other browser JavaScript implementation -- yet.)
