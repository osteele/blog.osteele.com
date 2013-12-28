---
date: '2008-02-15 14:37:45'
layout: post
slug: self-printing-javascript-literals
status: publish
title: Self-Printing JavaScript Literals
wordpress_id: '247'
categories: [JavaScript, Tips]
tags: [JavaScript]
---

Sometimes you need a totally opaque "constant" -- a value that isn't intended to be projected or modified, and whose only purpose is to be completely different from every other value[^1].  For example, [Functional](/sources/javascript/functional/) uses `Functional._` as a placeholder; a comment on [John Resig's blog](http://ejohn.org/blog/partial-functions-in-javascript/) suggests defining something like `Partial.PLACEHOLDER` for something similar.

<!-- more -->

In JavaScript, these are easy to make.  Here's one: `{}`.  And here's another: `{}`.  Note that these two values are _different_: the following code[^2] will print `true`, then `true`, then `false`:

    var L1 = {};
    var L2 = {};
    console.info(L1 == L1);
    >>> true
    console.info(L2 == L2);
    >>> true
    console.info(L1 == L2);
    >>> false

The problem with these values is that they look the same when you print them.  `L1` and `L2` both print as `Object` (in Firefox).

I'm going to print a value now:

    console.info(isPrime(172942) ? L1 : L2);
    >>> Object

Quick, which one did I print?  Sure, you can figure it out in this case (assuming my implementation of `isPrime` isn't buggy -- probably not a safe bet, especially if you're having to debug this in the first place), but in general this wreaks havoc with debugging.

Here's an idiom for making opaque values that can be debugged.  This has the further benefit that if the value is bound to a variable, you can use this to create a value that evaluates to itself when you type it back into the console (or into your source code). This works in Firebug and Rhino and OpenLaszlo, at least.

    var L1 = {toString:function{return "L1"}};
    var L2 = {toString:function{return "L2"}};
    L1
    >>> L1
    L2
    >>> L2

If you do use opaque constants often, you can use this `makeLiteral` utility routine to make them:

    function makeLiteral(name) {return {toString:function(){return name}}}
    var L1 = makeLiteral("L1");
    var L2 = makeLiteral("L2");
    L1
    >>> L1
    L2
    >>> L2

Some real-world uses might be:

    Functional._ = makeLiteral("Functional._");
    Partial.PLACEHOLDER = makeLiteral("Partial.PLACEHOLDER");

In fact, you could go further and define a defining-form.  I'm just including this for completeness; the version here doesn't work unless `target` itself has a `toString()` method, and would need more work to be made robust.

    function defineLiteral(target, name) {
      target[name] = return {toString:function(){return target+"."+name}}
    }
    defineLiteral(Functional, '_');

---

[^1]: Basically an enumerated type or a member of an algebraic data type, except that in meta-level programming these values are often compared to _any_ other value, not just values of a specific type.

[^2]: This would work the same way with `===` instead of `==`, but here it's not necessary.

