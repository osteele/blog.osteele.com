---
description: Some meta-ish libraries from when I was doing lots of JavaScript
date: '2008-04-15 14:36:47'
slug: three-small-javascript-libraries
title: Three Small JavaScript Libraries
categories: [JavaScript, Libraries]
tags: JavaScript, libraries
---

Three small libraries, that I carry with me from project to project:

<!-- more -->

## Fluently -- Construction Kit for Chainable Methods

With Fluently, you can do this:

        var o = Fluently.make(function(define) {
          define('fn1', function() {console.info('called fn1')});
          define('fn2', function() {console.info('called fn2')});
          define('fn3', function() {return 3});
        });

to define an object with chained methods, that can be invoked thus:

      o.fn1().fn2() // calls fn1 and then fn2
      o.fn2().fn1() // calls fn2 and then fn1
      o.fn1().fn3() // returns 3 (an explicit 'return' breaks the chain)

You can also define modifiers, and aliases:

        var o = Fluently.make(function(define) {
          define('fn1', function() {console.info('called fn1')});
          define('fn2', function() {console.info('called fn2')});
          define.empty('and');
          define.alias('fn3', 'fn1');
          define.modifier('not');
        });

      o.fn3(); // same as o.fn1()
      o.fn1().and.fn2() // same as o.fn1().fn2()
      o.fn1().and.not.fn2() // options.not is set when fn2 is called

I used this to build a [mock and spec construction kit](http://github.com/osteele/lztestkit).  I don't use Fluently to define the mocks; I use it to define the methods that define the mocks.  Doing all this in one library made my head hurt, so I factored this part of it out.

Git Fluently from [here](http://github.com/osteele/fluently).

## MOP JS

MOP JS defines utilities for JavaScript metaprogramming.  You don't think you need it until you try asynchronous programming, where some methods don't have enough information to operate until the response to another method's asynchronous request have returned.

      MOP.delegate(target, propertyName, methods)

> For each name in `methods`, defines a method on `target` with this
name, that delegates to the method of the `propertyName` property
of `target` with the same name.

      new MOP.MethodReplacer(object, methods)

> When a new MethodReplacer is constructed, it replaces each method
on `object` by the method in `methods` with the same key value, if
such a method exists.  A MethodReplacer has a single method,
`restore`, which restores each method to its pre-replacement
value.

      new MOP.QueueBall(object, methodNames)

> When a new QueueBall is constructed, it replaces each method named
by `methodNames` with a method that enqueues the method call (the
name of the method and its arguments).  A QueueBall has a single
method, `replayMethodCalls`, which plays back the method calls and
restores the methods.

      MOP.withMethodOverridesCallback(object, methods, fn)

> Calls `fn` on `object`, within a dynamic scope within which the
methods in `methods` have temporarily replaced the like-named
methods on `object`.  The scope is terminated by the argument to
the call to `fn`; this argument should be treated as a
continuation, and restores the methods.

      MOP.withDeferredMethods(object, methodNames, fn)

> Calls `fn` on `object`, within a dynamic scope within which the
methods in `methodNames` have been enqueued.  The scope is
terminated by the argument to the call to `fn`; this argument
should be treated as a continuation, and ends the queue, replaying
the methods.

See the [specs](http://github.com/osteele/mop-js/tree/master/specs/mop-specs.js) for examples; git MOP JS from [here](http://github.com/osteele/mop-js).

## Collections JS

Finally, the Collections library defines framework-independent JavaScript collection methods, for use in browser JavaScript and in ActionScript / OpenLaszlo.  There are many libraries like this; this one is mine.

The `Array` and `String` methods extend the class prototype; the `Hash` methods use a proxying wrapper to avoid prototype pollution.  The methods with the same names as the ECMAScript 1.6+ extensions have the same spec as those; the ones with the same name as prototype extensions have the same spec as those in the Prototype library; and there's a few odds and ends such as `String#capitalize`.

I use this when I don't want the overhead of Prototype, or want to use these functions in an environment that Prototype doesn't run on, such as OpenLaszlo.  It has some overlap with [Functional](http://osteele.com/sources/javascript/functional/), but isn't nearly so radical -- this can be an advantage.

Git Collections JS from [here](http://github.com/osteele/collections-js).

