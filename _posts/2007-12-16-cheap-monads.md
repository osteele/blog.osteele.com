---
description: An idiom that CoffeeScript’s existential operator replaces
date: '2007-12-16 21:49:46'
layout: post
slug: cheap-monads
status: publish
title: "Monads on the Cheap I: The Maybe Monad"
wordpress_id: '225'
categories: [Essays, JavaScript, Programming Languages, Tips]
tags: JavaScript, monads, essays
---

Don't worry, this isn't YAMT ([Yet Another Monad Tutorial](/2007/12/overloading-semicolon) ).  This is a practical post about a code smell that afflicts everyday code, and about an idiom that eliminates that smell.  It just so happens that this idiom corresponds to one of the uses for monads in Haskell, but that's just theory behind the practice, and I've saved the theory for the end.

<!-- more -->

This post is about style: implementation choices at the level of the expression and the statement.  Style doesn't matter much in a small program, or a write-only program (one that nobody will read later).  It isn't necessary to make a program run: by definition, it doesn't make a functional difference.  Style makes a difference to how easy or pleasant a program is to read; this can make a difference to whether it gets worked on (by its author, or somebody else) later.

## The Problem

The types are **Product**, **Offering**, **Merchant**, and **Name**.  A Product _might_ have an Offering; an Offering _might_ have a Merchant; and a Merchant _might_ have a Name.

The code displays the name of the merchant that is offering the selected product.  The input is named product.  This value _might_ be an instance of **Product**, or it might be null.  The specification is this:  If product is a product that has an offering that has a merchant has a name, then display that name; else do nothing.

[This problem is adapted from an eCommerce application I'm writing.]

This code isn't difficult to write.  The challenge isn't in make it run; it's in making it readable.

## The Obvious Implementation

Here's a naive solution.  This particular code is JavaScript, but the structure comes out the same in Python, or Ruby, or C++ or Java, or Lisp.

    var product = ...;
    if (product) {
      var offering = product.offering;
      if (offering) {
        var merchant = offering.merchant;
        if (merchant) {
          var merchantName = merchant.name;
          if (merchantName)
            displayMerchantName(merchantName);
        }
      }
    }

Let's stop for a moment and identify the smells.  There are two of them: I call the first one Narrative Mismatch, and the second Baton Carriers.

The first smell has to do with those nested conditionals.  There's a narrative here, that flows from the beginning of the spec ("the input is named _product_") to the end ("display that name").  The code that corresponds to this narrative starts with `product=...`, and ends `displayMerchantName(...)`.  However, the line of this narrative isn't linear in this implementation; it's a series of [Russian dolls](http://en.wikipedia.org/wiki/Matryoshka_doll).  The climax to the story is buried in a subplot, displayed as though it were some exceptional case.  Narrative Mismatch is when the dramatic structure (the specification) of the program doesn't match its control structure (in the implementation).

The other problem is the temporary variables.  These are the variables such as `offering` and `merchant`.  These variables are "bit players": each variable enters the stage (the local scope) only to perform a trivial bit of business, and then hangs around as clutter.  Or, to use a racing metaphor, this implementation turns what could be a sprint into a relay race, where a series of runners hands off the data baton.

## Can we do better?

If the code did nothing but display the merchant name and then return, we could invert each of the conditionals, and bail out early.  This changes the control structure to match the plot: the beginning and end of the narrative are both at the same (top) level of the control structure.

    var product = ...;
    if (!product) return;
    var offering = product.offering;
    if (!offering) return;
    var merchant = offering.merchant;
    if (!merchant) return;
    var merchantName = merchant.name;
    if (!merchantName) return;
    displayMerchantName(merchantName);


This implementation retains two of the disadvantages from the first, and it introduces a third. First, that's still an awful lot of control flow (four lines) obfuscating a tiny amount of data flow (four lines).  Second, we've still got those baton variables, `offering`, `merchant`, _etc_.  Finally, the new implementation works only if the fragment is an entire function: if `displayMerchantName` is the last statement in the function[^1].

How about if we eliminate the batons altogether?  Then we can combine all the tests into a single conditional:

    var product = ...;
    if (product
        && product.offering
        && product.offering.merchant
        && product.offering.merchant.name)
      displayMerchantName(product.offering.merchant.name);


This implementation has fewer lines, at least, but there's still a lot of repetition[^2] -- the text `product.offering` occurs four times.

It's also inefficient. The previous implementations computed the value of `product.offering` only once, but this one computes it four times, and contains a total of nine member accesses to the alternatives' three.  These multiple accesses may not matter for this particular example: the case where all nine of those accesses are executed is the same case that ends with a a function call to a display routine. But consider the case where the accessor is `product.offering()` instead; or, in Ruby or ECMAScript 4, the case where `product.offering` is a getter.

We can re-introduce the temporary variables, this time within the conditional, to keep the control flow simple:

    var product = ...,
        offering, merchant, merchantName;
    if (product
        && (offering = product.offering)
        && (merchant = offering.merchant)
        && (merchantName = merchant.name))
      displayMerchantName(merchantName);


...but now we've brought back the batons.

(You may also have a stylistic object to the assignments inside of conditionals in this latest attempt. I'm not completely against the construct, but I avoid it unless it makes the code clearer, and it's not clear that it does that, here.)

## Stepping Back

I'd like to be able to write something that matches the language of the specification:

    var product = ...,
        merchantName = product.offering.merchant.merchantName;
    if (merchantName)
      displayMerchantName(merchantName);


and have the system just know that `product.offering` evaluates to null if `product` is null; and that `product.offering.merchant` evaluates to null if `product.offering` is null, _etc_.  Now, we might not like `null.property` to evaluate to null _everywhere_ (that might move bug symptoms too far away from their defect sites), but we'd like it _here_.

This property --- that member access to a property of null is itself null -- could be called "null contagion".  Many languages have "float contagion", where an arithmetic operation produces a float if either of its arguments is a float.  (_i.e._ `a+b` is equivalent to `float(a)+float(b)` if _either_ of `a` or `b` is a float.)  "Null contagion" is similar to float contagion except that it only applies to the member access (`.`) operator, and only from left to right.

You may be used to null contagion from other contexts --- for example, from the declarative languages such as CSS and XPath and SQL, that adjoin the mainstream languages.  It's just not present in any of the procedural languages that I listed at the top of this post.  For example, if `product` were XML and we were using E4X, we could write this as `product.offering.merchant.name` as desired.  Or if we could apply CSS to a JavaScript object, we might write something like `$('offering > merchant > name', product)`.  Or with XPath (and an Hpricot-like syntax, this time): `product/'offering/merchant/name/text()'`.

So one solution would be to write a function that applies CSS or XPath paths to JavaScript objects.  This works and there's even Java libraries that do this, but here I'm looking for something less heavyweight than a library, and something that doesn't require parsing strings at runtime.  I'm looking for an idiom that approximates null contagion within the language.

Without further ado, here's how to write an expression that evaluates to `object`'s `property` property if `object` is not null, and to null otherwise[^3]:

    (object||{}).property


And this can be chained as follows:

    ((object||{}).property1||{}).property2


So let's apply this, in two steps, to the problem above.  First, get rid of all the intermediate conditionals, in order to match the control flow to the narrative:

    var product = ...,
        offering = (product||{}).offering,
        merchant = (offering||{}).merchant,
        merchantName = (merchant||{}).name;
    if (merchantName)
      displayMerchantName(merchantName);


And now that each intermediate variable is used only once, we can inline its value and eliminate its name:

    var product = ...,
        merchantName = (((product||{}).offering||{}).merchant||{}).name;
    if (merchantName)
      displayMerchantName(merchantName);


This isn't as clean as the E4X example, but it's relatively concise: no batons, and no non-narrative control flow.

It's also, in the case where _most_ products have offerings that have merchants that have names, potentially more performant.  A `||` (which short circuits) is comparable to an `if` statement, and the number of conditionals of either form (`||` or `if`) is conserved across all the implementations in this post.  The "null contagion" version defines `{}` literals, but these are only interpreted to create objects when the property target is null --- here, assumed to be the exceptional case.  And since this attempt has fewer instances of variable name lookup than in the others, it should be more efficient than the others except when in the presence of more optimization that most of the scripting languages provide right now.

What about the case where most products _don't_ have offerings, or the offerings don't have merchants, _vel cetera_?  If this were a frequent case, and this were inner-loop code, I might introduce a global empty object in order to reduce the object instantiation overhead (which happens right away) and the GC load (which shows up over time).  _E.g._ define `var $N={}`, and use:

    var product = ...,
        merchantName = (((product||$N).offering||$N).merchant||$N).name;
    if (merchantName)
      displayMerchantName(merchantName);


(The Ruby equivalent of `{}` is `{}` for a Hash, with array-style access; and `OpenStruct.new` for an Object, with property getter syntax.  You definitely want a reusable singleton for the latter.)

On the minus side, even this version always performs all four tests and all three property accesses.  That's three extra tests (beyond the attempts at the top of this post) when `product` is `null`, and two extra when `product.offering` is `null`, and so on.  So it might still slower be than the solutions that don't use null contagion --- but on the other hand, it still avoids the temporary variables of those solutions.  In other words, there's no substitute for actually measuring the difference, within the program and on each platform that you're optimizing for.  Oh well.

## What Does this Have to Do With Monads?

An expression such as `product.offering.merchant.name` is a pipe.  It can be read as "get the value of `product`; and then get that value's `offering`; and then get that value's `merchant`; and then get that value's `name`".  The dot says two things: (1) evaluate the expression (`product`) to its left, _and then_ (2) use that as target for the projection function (`['offering']`) immediately to its right.

We've made up a new construct, `(object||{}).property`, which is like `object.property` except that if you put a null in (as the value of `object`), you get null out (as the value of `(object||{}).property`).  In effect, we've replaced dot's interpretation of "and then".  The interpretation of `object.property`'s "and then"  includes "and if `object` is `null`, then error".  The interpretation of the new "and then" adds "and if `object` is null, evaluate to null".

This construct, `(object||{}).property`, _isn't_ a monad.  It isn't a monad because it isn't associative; and it isn't associative because the property accessor (dot) isn't either [dot isn't the morphism of a category].  `(A.b).c` isn't the same as `A.(b.c)` --- in fact, the latter isn't even well formed.

However, the class of property projection _functions_ --- just the `.b` part --- _does_ form a category.  If you consider just the `.b.c.d` part of `A.b.c.d`, it doesn't make any difference whether you read it as "apply the 'b' projection, and then apply the application of the 'd' projection to the 'c' projection, to that"; or "apply the 'c' projection to the 'b' projection, and then apply the 'd' projection to that".

You won't find "null contagion" proposed as an implementation technique on the web.  What you'll find is the Maybe Monad.

---

[^1]: It would be sad if this were an entire function.  That would indicate that the function that _contains_ `displayMerchantName` is just a _wrapper_ for `displayMerchantName`, to protect it from being called when there isn't a Product with an Offering with a Merchant.  Having to define a new function to wrap each instance of a common pattern is like having to define a new word to name the reference of each noun phrase. It's reminiscent of the boilerplate getters and setters in logorrheic enterprise code.

[^2]: "Repetition" is defined as "a host site for a defect infection".

[^3]: JavaScript has more than one null object.  This code takes advantage of the fact that an Object (even one with no properties) is _never_ null, while `undefined` --- the value of an undefined property access --- _is_ null.
