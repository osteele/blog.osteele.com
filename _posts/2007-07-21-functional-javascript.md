---
description: Functional JavaScript library
date: '2007-07-21 20:54:57'
layout: post
slug: functional-javascript
status: publish
title: Functional JavaScript
wordpress_id: '209'
categories: [JavaScript, Libraries, Projects]
tags: JavaScript, libraries, functional, fun
---

*Functional* is a JavaScript library for [functional programming](http://en.wikipedia.org/wiki/Functional_programming).  It defines the standard higher-order functions (`map`, `reduce`, `filter`) that you can read about elsewhere on the web.  It also defines functions for partial function application and [function-_level_](http://en.wikipedia.org/wiki/Function-level_programming) programming: `curry`, `partial`, `compose`, `guard`, and `until`.  Finally, it introduces "string lambdas", which let you write `'x -> x+1'`, `'x+1'`, or even `'+1'` as synonyms for `function(x) {return x+1}`.

See the [API and examples page](http://osteele.com/sources/javascript/functional) for more examples, API documentation, and a link to the source.

<!-- more -->

### String lambdas

Welcome to functional programming!  You've probably already discovered `map` and `filter`.  (If not, curl up with Google for a few minutes.  I'll wait.)  Try using them in JavaScript.  Isn't it a pain?:

    map(function(x){return x+1}, [1,2,3])
      -> [2,3,4]
    filter(function(x){return x>2}, [1,2,3,4]]
      -> [3,4]
    some(function(w){return w.length < 3}, 'are there any short words?'.split(' '))
      ->false

String lambdas let you write these this way, instead:

    map('x+1', [1,2,3])
    select('x>2', [1,2,3,4])
    some('_.length < 3', 'are there any short words?'.split(' '))

Some more examples, using just `map`, `filter`, and `reduce`:

    // double the items in a list:
    map('*2', [1,2,3])
      -> [2, 4, 6]
    // find just the odd numbers:
    filter('%2', [1,2,3,4])
      -> [1, 3]
    // or just the evens:
    filter(not('%2'), [1,2,3,4])
      -> [2, 4]
    // find the length of the longest word:
    reduce(Math.max, 0, map('_.length', 'how long is the longest word?'.split(' ')))
      -> 7
    // parse a binary array:
    reduce('2*x+y', 0, [1,0,1,0])
      -> 10
    // parse a (non-negative) decimal string:
    reduce('x*10+y', 0, map('.charCodeAt(0)-48', '123'.split(/(?=.)/)))
      -> 123

### Function-level programming

Value-level programming manipulates values, transforming a sequence of inputs into an output.  [ Function-level programming](http://en.wikipedia.org/wiki/Function-level_programming) manipulates functions, applying operations to functions to construct a new function.  It's this new function that transforms inputs into outputs.

Here are some examples of function-level programming with *Functional*.  There's more in the [documentation](http://osteele.com/sources/javascript/functional).

    // find the reciprocal only ofvalues that test true:
    map(guard('1/'), [1,2,null,4])
      -> [1, 0.5, null, 0.25]
    // apply '10+' only to even values, leaving the odd ones alone:
    map(guard('10+', not('%2')), [1,2,3,4])
      -> [1, 12, 3, 14]
    // write a version of map that only applies to the evens:
    var even = not('%2');
    var mapEvens = map.prefilterAt(0, guard.rcurry(even));
    mapEvens('10+', [1,2,3,4])
    // find the first power of two that's greater than 100:
    until('>100', '2*')(1)
      -> 128
    // or the first three-digit power of two (these are equivalent):
    until('String(_).length>2', '2*')(1)
    until(compose('>2', pluck('length'), String), '2*')(1)
    until(sequence(String, pluck('length'), '>2'), '2*')(1)

### Partial function application

Partial function application, or specialization, creates a new
function out of an old one.  For example, given a division function:

    function div(a, b) {return a/b}

a partial application of `div` is a new function that divides its argument by two:

    var halve = div.partial(_, 2);

Partial application is especially useful as an argument to the higher-order functions such as `map`, where, given a function `div`, we can apply it (the first line below) without an explicit wrapper (the second).

    map(div.partial(_, 10), [10, 20, 30])
    map(lambda(n) {return div(n, 10)}, [10, 20, 30])

The `curry` function handles a special case of partial function application, and the previous example could have been handled via `curry`.  Partial function application in all its generality is only necessary when you're specializing not just on all the arguments on the left, or all the arguments on the right, but some distribution of arguments with holes in the middle.  To illustrate this requires a function with more than two parameters.

JavaScript doesn't have many functions with more than two parameters. (`splice` takes three, but `splice` isn't very functional).  Here's a contrived example to start (and a real-world example next).

We'll borrow one of the few trinary predicates from math: "between".  `increasing(a, b, c)` tests whether b (the middle argument) lies in the open interval bounded by a and c.  Specialize the first and last arguments to produce a functions that tests whether a number is positive, for example.

    function increasing(a, b, c) {
      return a < b && b < c;
    }
    var positive = increasing.partial(0, _, Infinity);
    map(positive, [-1, 0, 1])
      -> [false, false, true]
    var negative = increasing.partial(-Infinity, _, 0);
    map(negative, [-1, 0, 1])
      -> [true, false, false]

Here's how to use `compose` and `curry` to generalize some of the examples from the first section into reusable functions.  (You'll probaby like or hate these function definitions to the extent that you like or hate Haskell.)

    var longest = compose(reduce.curry(Math.max, 0), map.curry('_.length'), "_.split(' ')");
    longest("how long is the longest word?");
      -> 7
    longest("I bet floccinaucinihilipipification is longer.");
      -> 29
    var parseUnsignedInt = compose(reduce.curry('x*10+y.charCodeAt(0)-48', 0), '_.split(/(?=.)/)')
    parseUnsignedInt('123')
      -> 123

Here's real-world example:  The following line attaches a `sum` method to Array.  Note how the `'this'` string lambda, which is short for `function(){return this}`, moves the object from object position to argument position so that the curried `reduce` can apply to it.

    Array.prototype.sum = reduce.curry('+', 0).compose('this')
    [1,2,3].sum()
       -> 6

Here's another example:  If you're using Prototype, you can replace the first line below by the second:

    Event.observe('myobj', 'click', function() {...})
    onclick(''myobj', function() {...})

by defining a specialized version of Event.observe:

    var onclick = Event.observe.bind(Event).partial(_, 'click');

### A Question of Taste

Is this:

    var onclick = Event.observe.bind(Event).partial(_, 'click');

really better than the following?

    function onclick(element, handler) {
      Event.observe(elenent, 'click', handler);
    }

It's a matter of taste, with some performance considerations as well.

The function-level version is less efficient.  To the inexperienced eye, it's also harder to read.

On the other hand, the functional version doesn't include as much plumbing, with its attendent opportunity for error.  The second definition  of `onclick`, considered as a general replacement for `Event.observer(..., 'click', ...)`, has two such errors.  One shows up as soon as you use it; the second is considerably more subtle.

Whether functional programming is appropriate, for reasons of efficiency or readability, in any particular instance, it's nice to have it, at least for prototyping, in your arsenal.

### Performance Notes

In most languages, including JavaScript, invoking a function is one of the slowest things you can do.  The implementations of languages designed for functional programming use a variety of techniques to optimize function calls.  JavaScript is not one of those languages.

*Functional* attempts to reduce the cost of higher-order-programming where doing so doesn't add to the code complexity or readability too much.  Each higher-order function and method is a small number of lines, and each function-returning method attempts to do as much work as possible outside the function that it returns, to optimize the case where the returned function is called more than once (as an argument to a higher-order function such as `map`, for example).

Still, using *Functional* is expensive.  Invoking a constructed function results in at least twice as many invocations as invoking the underlying function.  This isn't any different from using `bind` in the Prototype library, say, but, the more of your program you write in a functional style --- and therefore the more method calls you introduce --- the slower it will be.  As with any library, be aware that you may have to hand-compile performance-critical sections of your code into an approximation of you would have written without the library anyway.  If you think you already know what needs to be optimized (or that your whole program does), or you aren't comfortable with measuring performance periodically in order to intelligently trade execution time against implementation time, you may want to eschew libraries, especially higher-order ones.

### Compatibility

Functional is known to work in Firefox 2.0, Safari 3.0, and MSIE 6.0.  I didn't intentionally use any non-standard ECMAScript constructs, but meta-programming such as this tends to turn up corners in the browser implementations.

I've used this with Prototype and jQuery.  If you call `Functional.install`, it will replace Prototype's `bind`, but with a compatible version.  `Functional.install` defines a number of other top-level functions (all documented), but to my knowledge these all have unusual names (e.g. `curry`), or standard semantics (e.g. `map`), so you're unlikely to run into any problems unless you try to use this with _another_ library of higher-order functions.  In which case, don't call `Functional.install`.

Update: The current version also defines `equal` as a functional, for doing things like this: `select(equal(pluck('x'), K(1)), [{x:1,y:2}, {x:3,y:4}])`.  This is more likely to conflict with a method from your code or another library, so beware!

Defining `String.prototype.apply` and `...call` seems potentially skanky, although the ECMAScript standard permits it and i haven't run into any trouble.  These methods could be removed without breaking anything except a few of the example; internally, the *Functional* functions use `Function.toFunction` instead.

The implementation of string lambdas uses regular expressions and `eval`.  The rest of the code doesn't.  The intent of this separation is that the code might be portable to environments that don't include these features, such as Flash and OpenLaszlo.  I haven't tested it against any of these environments, thoug, so I've kept the code in one file for now.

### Future Directions

### Credits

(Temporarily deleted while I debug why this text borks WordPress.)
