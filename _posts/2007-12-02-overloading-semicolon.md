---
description: My Monad tutorial, back (2007) before these became quite so much a thing
date: '2007-12-02 22:38:47'
layout: post
slug: overloading-semicolon
status: publish
title: Overloading Semicolon, or, monads from 10,000 Feet
wordpress_id: '222'
categories: [Essays, JavaScript, Programming Languages]
tags: JavaScript, monads, essays
---

`amichail` on reddit asks about [understanding monads in one minute](http://programming.reddit.com/info/61ydi/comments/).   My thoughts ran longer than a comment and more than a minute, so I've placed them here.

<!-- more -->

The main message of this posting is that you already use monads, just without the labels.  The complexity in most explanations comes from factoring out the different pieces of what you already know, and from the mathematical exposition in terms of category theory and monad laws.  (I like the math, but you won't find any of it here.) This posting trades away accuracy for ease; I hope it's a helpful start.

---

A monad, as used in Haskell, is a rule that defines how to get from one statement in a program to the next.  For example, there's an implicit monad in the (JavaScript) sequence `var x = 1; var y = x+1`.  It describes how to get from `var x = 1` to `var y = x+1`.

A monad describes the flow of control, and the flow of data.  Typically, the flow of control is something like "execute the first statement once, and then execute the next statement once", and the flow of data is something like "the first statement computes a value, and makes it available to the next statement" (through a variable binding, say).

Sometimes the rules are more complicated.  For example, if one statement is `throw` or `raise`, the statements that follow it are skipped.  If one statement sets a global variable, the statements that follow it can get additional data by reading that variable.  And if one statement changes the world outside the program (say, that statement creates a file), this will affect what happens when the following statements peek at the world, maybe even in other ways (say, by reading the free space on that volume).

Also, "following statements" is a dynamic notion, not a static one.  If function `f` calls `g`, then all the statements in `f` that follow `f`'s call to `g`, follow all the statements in `g` (at least, up until `g`'s `return`).

You've used monads.  You've used the `State` monad (which manages global variables), the `Error` monad (which enables exceptions), and the `IO` monad (which handles interactions with the file system, and other resources outside the program).  You may not have thought much about these properties, because they come "for free": in most languages, you don't need to do anything special to get them.

In Haskell, you do need to do something special.  All you get by default is the "typical" case from above: one statement computes a value; the next statement can read it.  If you want additional behavior (`State`, or `Error`, or `IO`), you have to say so.  You can say so by declaring the type of your statement block.  Just like every _variable_ in a statically-typed language such as C or Java has a compile-time type (`int` if its values are integers, or `String` if its values are strings), every _statement_ in Haskell has a compile-time type too:  `Error Int` if it might raise an exception; `IO Int` it it might interact with the world.

Why introduce this complexity into statement sequencing?  The complexity comes with two benefits: a _check_ on dynamism, and the ability to _extend_ it.

The first benefit is that, if the only statements that might change the world have `IO` in their type, you can assert to the compiler that some compound statement or function not only doesn't change the world within its body, but doesn't call any functions that contain statements that do.  And so on for other properties ("raises an exception", "accesses global data"). This turns out to be useful.

The other benefit is that you can define your own sequencing rule.  Remember that part about "execute the first statement once, and then execute the next statement", and "the first statement computes a value, which the next statement can use"?  You can replace these with "execute the first statement, but only execute the next statement if the value so far isn't null".  This is the `Maybe` monad; it turns out to be useful too.

Or, you could replace the rule with "the first statement computes a *list* of values, and the second statement runs once *using each of them*".  This is the `List` monad; it's --- yes, you're ahead of me here --- it's useful too.

I made an analogy between statements and variables, above. Java and C++ have typed variables, while Haskell adds typed statements.  Let's extend that analogy.  Operators, such as plus and times, combine values.  Some languages let you _overload_ operators: `Integer+Integer` does one thing; you can define `String+String` to do another (hopefully string concatenation), and `Vector+Vector` to do a third (hopefully vector addition).

You can think of the semicolon as an operator that combines two _statements_.  A definition for the semicolon operator is a monad: it defines the meaning of a compound statement composed of two simpler ones.  **Haskell lets you overload semicolon.**

I hope this helps.  If it did, now go read a [monad tutorial](http://www.google.com/search?q=monad+tutorial) and see how it works for real.  If didn't, go read a [monad tutorial](http://www.google.com/search?q=monad+tutorial) to see if it's easier with actual examples, and the details and syntax filled in.

## Some Lies

Here's some of what I said above, that just isn't true:

A monad isn't just a rule.  It's a structure that *includes* a rule.  Its data are a set (or type) of statements, and an operation that combines them --- the "rule" above.  (There's more accurate and technical definitions, but that gets into the heavy math.)

Furthermore, the rule part of the monad isn't just any rule.  It has to have certain properties: the [monad laws](http://www.google.com/search?q=monad+laws).  However, you can perfectly well understand how to *use* a monad without being able to enumerate the monad laws[^1], just like you can use numbers without being able to enumerate the properties of a field or ring.

The descriptions of the `State` and `IO` monads above are particularly oversimplified.  I think they're useful for coming *from* *procedural programming*, but you'll want to refine them in order to get *to functional programming*.  Again, follow any monad tutorial.

In Haskell, you don't even get statements by default.  (I said above that you did.)  Everything is an expression.  As soon as you start using statements (which are just monad-valued expressions), you're in monad land (even if it's just the identity monad).  The step from expressions to statements is the big one, and the differences between different monads aren't as big a (syntactic) deal.

In Java, you _do_ have to declare the types of _some_ collections of statements.  The collections are functions, and the type that you have to declare is the type of a statement that throws a checked exception.  This fact about Java is widely despised, but it does give you a taste of Haskell.

Finally, thinking about monads as defining (or overloading) semicolon is a start, but sequencing is more general than that.  Even in a language where every two *lexical* statements are separated by a semicolon, one statement can _dynamically_ follow another without any particular relation between their sources, such as when one is in a function, that is called by the other.

---

[^1]: The monad laws just say that (1) there's a way to turn any expression (that computes a value) into a monad (that passes that value on); and (2) a sequence  of statements acts the way you think it should.

