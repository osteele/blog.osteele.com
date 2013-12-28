---
date: '2006-04-16 19:58:50'
layout: post
slug: javascript-memoization
status: publish
title: One-Line JavaScript Memoization
wordpress_id: '204'
categories: [Essays, JavaScript, Tips]
tags: [JavaScript, essays]
---

Computing the length of a Bezier curve is expensive, but the length of a given Bezier doesn't change over time.  In my [JavaScript Bezier implementation](/archives/2006/02/javascript-beziers), I wanted to compute the length only the first time it's need, and save this result in order to return instantly thereafter.

<!-- more -->

This is a special case of [memoization](http://en.wikipedia.org/wiki/Memoization).  There are well-known strategies for implementing memoization.  But `getLength` is a [nullary](http://en.wikipedia.org/wiki/Arity) function,  and there's a trick for implementing memoization of nullary methods in a dynamic language such as JavaScript (or Python or Ruby).  In these languages, you can memoize a nullary method by adding one line to it, without any support libraries.  This line replaces the method by a constant function, that returns the computed value. This memoization strategy is also more efficient than the general-purpose solution that non-nullary methods require.

## Memoizing by Hand

The naive way to implement memoization is to store the value in a property the first time it's computed, and test for the presence of the property thereafter:

    Bezier.prototype.getLength = function() {
      var length = this._length;
      if (length === undefined) {
        var length = ... // expensive computation
        this._length = length;
      }
      return length;
    }

or:

    Bezier.prototype.getLength = function() {
      if ('_length' in this) return this._length;
      var length = ... // expensive computation
      this._length = length;
      return length;
    }

There are some problems with these solutions.  First, they're verbose.  Worse, the domain logic (the line labelled "expensive computation") and the memoization logic (the code that accesses `length` and `this._length`) are tangled up with each other.

These implementations also require a private property for each memoized method.  And then there's a (minor) performance hit too: it takes a few instructions, each time, just to discover that the return value has already been computed.

## The Big Gun

The standard solution to the first two of the problems above (the length and structure of the implementation) is to write a higher-order-function, that creates a memoizing function from a non-memoizing one.

    Function.prototype.memoize = function () {
      var fn = this;
      var cacheName = ... // create a unique property name
      return function() {
        var key = serialize(arguments);
        var cache = this[cacheName] || this[cacheName] = {};
        return key in cache ? cache[key] :
          cache[key] = fn.apply(this, arguments);
      }
    }

 (Keith Gaughan has a complete implementation [here](http://talideon.com/weblog/2005/07/javascript-memoization.cfm.))  Then you can use it thus:

    Bezier.prototype.getLength = function() {
      var length = ... // expensive compuation
      return length;
    }.memoize();

This is the best general-purpose solution, and it's good for a framework, or for a complete application.  But in a small standalone code library such as [this](/sources/javascript/bezier.js) or [this](/sources/javascript/gradient.js), I don't want to include a copy of `Function.prototype.memoize` in each standalone file (and then worry about version skew); and I don't want to make each file depend on a utility file (and then worry about file dependencies).

## The One-Liner

A nullary function such as `getLength` is a special case of functions in general, and there's a particular technique[^1] for memoizing it, that fits on a single line.

Here's the first variant.  This is less source code that the version above, and uses fewer instructions to retrieve a memoized value.  (In fact, it uses the fewest possible number of instructions, if the API for retrieving a value requires a function call at all.)  It's an extra line (the assignment to `this.getLength`) that you can stick in a nullary method, that memoizes the method's value on a per-instance basis.

    Bezier.prototype.getLength = function() {
      var length = ... // expensive computation
      this.getLength = function(){return length};
      return length;
    }

The second variant moves the return  and the assignment to the same line.  Think of this line as a "memoizing return statement".  It comes at the cost of more opaque code, and an extra function call. (The overhead of a function call is probably not a problem if the computation is expensive enough to be worth memoizing anyway.)  And although it's not a style I would use for general-purpose programming, I find it acceptable in an idiom[^2].

    Bezier.prototype.getLength = function() {
      var length = ... // expensive computation
      return (this.getLength = function(){return length})();
    }

## Another Use

You can use a similar technique to prevent a function from being called twice.Â  This is even simpler, since you donâ€™t need to keep track of the value.Â  For example (from [gradients.js](/sources/javascript/docs/gradients):)

    OSGradients.initialize = {
      OSGradients.initialize = function() {};
      ... // initialization
    }

## Avoiding Memory Leaks

The inner function captures the variables from the outer function.  In the method below, `temp` will never be deallocated, until the instance that `getLength` has been applied to (and that the constant version of `getLength` is therefore now attached to) has been deallocated.

    Bezier.prototype.getLength = function() {
      var temp = new Array(10000);
      var length = ... // expensive computation
      // the following line captures length and temp:
      return (this.getLength = function(){return length})();
    }

If there are large temporaries, or pointers to DOM elements that may be deleted later, you should either detach them before you exit the outer function body:

    Bezier.prototype.getLength = function() {
      var temp = new Array(10000);
      var length = ... // expensive computation
      temp = null; // so the value won't be captured
      // the following line captures length and work:
      return (this.getLength = function(){return length})();
    }

or use a helper function that closes over just the return value:

    // Function.K(value) is a constant-valued function that returns
    // value.
    Function.K = function(value) {return function(){return value}};
    Bezier.prototype.getLength = function() {
      var temp = ...
      var length = ...
      // the following line only captures length:
      return (this.getLength = Function.K(length))();
    }

## Thunks for the Memories

Although I didn't realize it until later (when I was writing my Bezier library, coming at this more from the "how can I cache this value" perspective than from a "theory of memoization and programming language implementation" perspective), this is nothing more than an implementation of [thunks](http://en.wikipedia.org/wiki/Thunk) for JavaScript.

In a lazy (or call-by-need) language such as Haskell, memoization comes for free.  A variable with an initializer has the same syntax and semantics as a function; the initializer is evaluated once, the first time the variable is referenced, and then cached.

A referentially transparent nullary function has the syntax of a function, but the semantics of a value.  (In Haskell, the syntax is the same too.)  By memoizing it, we're making this value [call-by-need](http://en.wikipedia.org/wiki/Evaluation_strategy#Call_by_need).  One technique for implementing call-by-need (or "lazy") values is to create a thunk that replaces its computation by its value the first time it's evaluated.  In JavaScript, we can implement these semantics but have to stick with the function-call syntax.

## Beyond Thunks

There's three directions to go from here, but all of them involve giving up the single-line solution.

First, it's a bother that a method has to know its own name.  This means you can't paste the same line of code into each memoized function.  This is the only way, however, that the method can replace itself with the constant function[^3].  You can eliminate the need to type the name twice, if give up both the no-helpers requirement and the optimization that a memoized function doesn't test any conditions the second time it is called.  (The higher-order function in the section "The Big Gun" does this.)

Second, you can memoize non-nullary functions by getting out the big gun too.  In this case the replace-yourself optimization is useless too, since each invocation needs to check whether the value has already been computed _for these arguments_, regardless of how many times the function has been invoked before.

A third extension lets you hang onto the optimization, but takes more than a line of code (and therefore, realistically, depends on a support function).  It's for the case where the return value depends upon the object state, and that state is _mutable_.  In this case, you need a way to reset the memoized function to its initial state, so that it will perform the computation the next time it's called.  For example, `setRadians` below resets `getDegrees` so that the multiplication happens again upon the first call `getDegrees` after each time `setRadians` is called.  (This example isn't a realistic candidate for memoization, but pretend multiplication is really really really slow.)

    function Angle(radians) {this.setRadians(radians)}
    Angle.prototype.setRadians = function(radians) {
      this.radians = radians;
      this.getDegrees.reset();
    };
    Angle.prototype.getDegrees = function() {
      return this.radians * 180 / Math.PI;
    }
    memoizeConstantMethod(Angle.prototype, 'getDegrees');

Here's a long but marginally readable implementation of `memoizeConstantMethod`:

    function memoizeConstantMethod(object, property) {
      var f = object[property];
      var mf = function() {
        var value = f.call(this);
        var kf = function(){return value};
        kf.reset = reset;
        object[property] = kf;
        return value;
      }
      var reset = function() {
        object[property] = mf;
      }
      mf.reset = reset;
      reset();
    }

And here's a shorter version, that sacrifices the remaining readability for source code size[^4].

    function memoizeConstantMethod(o, p) {
      var f = o[p], mf, value;
      var s = function(v) {return o[p]=v||mf};
      ((mf = function() {
        (s(function(){return value})).reset = mf.reset;
        return value = f.call(this);
      }).reset = s)();
    }

Update: Peter Michaux has a nicely written description of a similar technique [here](http://peter.michaux.ca/article/3556).

---

[^1]: Memoization in general requires a finite map (or "hash") from argument lists to result values.  In the special case where the function is nullary, you don't need a map, because the empty list is the only key.

[^2]: Just as I don't need to understand what the tabs are in an English idiom such as "keep tabs on", I don't need to easily read a programming language idiom compositionally each time I see it.

[^3]: You can't search the object and its prototype chain for a function that's `===` to the one being replaced, because the same function might be present at different property names.

[^4]: This is written in might be called the "[\_why](http://redhanded.hobix.com/) [combinator](http://en.wikipedia.org/wiki/Combinator)" style of programming.
