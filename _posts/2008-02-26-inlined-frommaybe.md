---
description: CoffeeScript builds this in
date: '2008-02-26 20:26:42'
slug: inlined-frommaybe
title: "More Monads on the Cheap: Inlined fromMaybe"
categories: [Essays, JavaScript]
tags: JavaScript, monads, essays
---

This article is about how to deal with null values. It follows up on [this
one](/2007/12/cheap-monads). It's intended for code stylists: people who care a
lot about the difference between one line of code and two, or keeping control
statements and temporary variables to a minimum. (A code stylist is kind of like
the dual of a software architect, although one person can be both.) It's not
about code golf -- although you might learn some strokes to use on that -- but
about keeping the structure of your code, even at the expression level, close to
the way you think about the problem, if you think like me.

<!-- more -->

If you're _not_ a code stylist -- and I'm not saying that being a code stylist,
any more than being a prose stylist, is either a good or a bad thing -- you
might find it baffling that someone would put so much time into such simple
topic. I won't try to convince you otherwise. In that case, you might want to
check back next week, when I'll move back up to the bigger picture.
(Specifically, some fun stuff involving how to use meta-object programming to
solve race conditions in client-server models.)

---

A nullable or optional, type is one that might have a value of a certain basis
type, but might be null. For example, a nullable array is either an array or
null. Even if you don't use a language with type declarations, you probably use
a language with types. If a variable or field (JavaScript property) is expected
to hold only arrays, it has type array; if it sometimes ends up holding null as
well, it has type nullable array instead.

Haskell has a function `fromMaybe` that turns a nullable type into a
non-nullable type, but replacing it with a default value when it's null. What
would this look like in a more conventional language, and where would you use
it?

I'm using JavaScript as an example language here, but the techniques here apply
to Ruby and, to a lesser extent, Python as well.

## The First Problem Set

Here's your assignment. It has three parts. In all of them, `products` is a list
of products . In JavaScript, this list is represented by an instance of `Array`.

First, if `products` is non-empty, display its first item; otherwise, do
nothing. This is easy enough:

    if (products.length) {display(products[^0])}

Or, for a more Lisp- or Ruby-like style, with the advantage that it can be
nested in an expression:

    products.length && display(products[^0])

Second, apply a `preload()` function to each item in `products`. This is easy
too:[^1]

    products.forEach(preload)

Finally, extract the `id` from each product, and pass the list of ids to a
function `preloadAll`.[^2]

    preloadAll(products.pluck('id'))

## Raising the Bar

Let's make this problem harder. This time, `products` _might_ be an array, but
it _might_ be `null`.

"Hey!" you (ought to) protest. "That's a _stupid design_. You're giving me
_poorly typed data_, and this introduces complexity and its attendant costs
(development time, code size, test cases) to deal with it."

Well, yes. But this is the real world. Maybe you're reading an attribute from a
de-serialized XML element. XML schemas allow for this kind of abbreviation, and
using it makes documents more concise (and therefore both lower bandwidth and
easier to inspect for debugging), so you'll probably see this at some point.
Maybe you're reading or a property from a JSON object, where the server omits
null lists (for the same reasons -- message size and debuggability -- as for
XML). Or maybe you're reading `products` from a library that represents empty
lists by `null` -- for performance reasons (to avoiding making empty lists), or
for backwards compatibility, or just out of laziness. I've seen all of the
cases, a number of times.

Or maybe you used the technique in [Monads on the Cheap](/2007/12/cheap-monads)
to write something like `(order||{}).products`. Now that you've propagated a
null `order` into a null `products` -- to avoid wrapping an `if` statement
around the code that dealt with `order` -- you've got to pay the piper. You
followed my advice and I dug you into a hole; now I'd better toss you a rope
ladder.

## Solution 1: Fixing the input on entry

You could fix `products` before you use it: insert `products = products || []`
at the top of your function to change a nullable array into a non-null array, by
replacing null by a default value. If `products` is a local variable (as opposed
to a function parameter), you could even do this where it's initialized: replace
`var products = order.products`, say, by `var products = order.products ||
[]`.[^3] So the three solutions above become simply:

    // products may be null
    products = products || [];
    // products instanceof Array
    if (products.length) {display(products[^0])}

    products = products || [];
    products.forEach(preload)

    products = products || [];
    preloadAll(products.pluck('id'))

## Raising the Bar Again

Where `products` is a local variable, "fixing the input" really is the best
solution. However, it's not the _most general solution_ (for reasons I'll get
to). So I'll move the bar again.

This time, instead of the _variable_ `products`, it's the _expression_
`offer.products` that evaluates to the nullable array. What's the smallest
change required to adapt our code to null values, in this scenario?

## Solution 2: Introducing a temporary variable

This one looks absurdly easy too. Changing a line of code to accommodate
nullable arrays involves a simple program transformation. Replace
`offer.products` by `products`, and insert `var products = offer.products || []`
on the line before. Here are the _before_ cases, where `offer.products` is not
allowed to be null:

    // requires products instanceof Array
    if (products.length) {display(offer.products[^0])}
    offer.products.forEach(preload)
    preloadAll(offer.products.pluck('id'))

And here are the _after_ cases, where `offer.products` is allowed to be null:

    // accepts null products
    var products = offer.products || [];
    if (products.length) {display(products[^0])}

    var products = offer.products || [];
    products.forEach(preload)

    var products = offer.products || [];
    preloadAll(products.pluck('id'))

## Non-local Transformations

There's something funny about the "temporary variable" program transformation.
`offer.products` is an _expression_ -- you can nest it in another expression: as
the argument to a function, before a property accessor, or as part of a
conditional. `var products = offer.products||[]; ...; ...(products)...` is a
_statement sequence_. In fact, it's a _statement sequence with a hole_ -- it
doesn't strictly embed the original code, but it isn't strictly embedded by it,
either; instead, it's woven in.

These differences -- that this transformation _changes the syntactic type_ of
the code that you're applying it to (from an expression to a statement), and
that you have to weave it into the existing code -- make it non-local.[^4]
Here's what I mean by this:

To apply this transformation -- to change code that expects an array into code
that accepts a `null` -- we look for an occurrence of `offer.products`; we
replace it by `products`; and then we travel up the syntax tree (we look at the
expression that contains `offer.products`, and then the expression that contains
_that_) until we find a statement. Finally we insert `var products =
offer.products||[]` before that statement.

Admittedly, there hasn't been much to this in the statements so far. We've
simply replaced the first snippet below (with one line of code) by the second
snippet (with two lines). And the lines are adjacent, so it's easy enough to
read them as a unit.

    // requires products instanceof Array
    preloadAll(offer.products.pluck('id'))

    // accepts null products
    var products = offer.products || [];
    preloadAll(offer.products.pluck('id'))

It gets worse, though. Let's make `offer` nullable too, and add some more
computation. (I'm trying to get `offer.products` far enough inside of an
expression that we can get a feel for where the problems arise.)

In the first block below (which _doesn't_ deal with nullable arrays), `offer` is
either an object with a `products` property (which is always an `Array`), or
null. If it's not null, we load its products. We then set `loaded` to true _if
there was_ an offer, _and if_ any of its products were already loaded.
(`preloadAll` returns true in this case.) Simple enough:

    // accepts null offer; requires products instanceof Array
    var loaded = offer && preloadAll(products.pluck('id'));

Now, how do we change this if not only `offer`, but `offer.products`, are
nullable? We apply the transformation above, inserting the statement `var
products = ...` and changing `offer.products` to `products`. But where do we
insert the statement? It has to go _before_ the call to `preloadAll`, but
_after_ the test for whether `offer` is null.[^5] But in the listing above,
there isn't any such location!

To create one, we have to split the initialization expression in half, in order
to get the test for `offer` and the use of `offer.products` into separate
statements, so that there will be room for a statement (not added yet) between
them:

    // accepts null offer; requires products instanceof Array
    var loaded = false;
    if (offer)
      loaded = preloadAll(offer.products.pluck('id'));

And now we can hoist `offer.products` out of the second new statement, without
moving it before the first:

    // accepts null offer, offer.products
    var loaded = false;
    if (offer) {
      var products = offer.products || [];
      if (preloadAll(products.pluck('id'))
        loaded = true;
    }

This is awful! Not only did it go from one line to five, but `loaded` changed
from a non-mutable variable with an initializer into a mutable variable with two
different assignments, such that its initialization is split across the inside
and the outside of a conditional. This is the kind of code that, if I let it
take over 5% of my program, takes up 50% or my debugging time.

You might think these problems are because of the distinction between statement
and expression in Algol-style languages (C, C++, Java, JavaScript). This is
partly right, but it's only somewhat better in Lisp-style languages (Smalltalk,
Lisp itself, Ruby). Here's a straight translation of the JavaScript code into
Ruby:

    // before: accepts offer == nil; requires offer.products.is_an? Array
    loaded = offer && preloadAll(products.map &:id));

    # after: accepts offer == nil, offer.products == nil
    loaded = false
    if offer
      products = offer.products || []
      loaded = preloadAll(products.map &:id)
    end

Now let's use the fact that Ruby statements are expressions to re-write the
second case:

    # also accepts offer == nil, offer.products == nil
    loaded = offer && preloadAll(begin products = offer.products || []; products.map &:id));

Sure, this is back down to one line. And it avoids the cascading rewrite of the
first transformation (where changing the innermost expression into a statement
required changing the expression that contains it into a statement). However
it's far from idiomatic Ruby.

Worse, like the JavaScript snippet (and this is another problem with temporary
variables), it introduces a `products` into the surrounding environment, or
overwrites the existing value of `products` if there's already a variable with
that name there -- a subtle source of bugs, especially when you apply this
transformation more than once.

## Solution 2: Ifs and Ands

You could use conditional statements to transform the original solutions from
these:

    // requires non-null product
    if (offer.products.length) {display(offer.products[^0])}
    offer.products.forEach(preload)
    preloadAll(offer.products.pluck('id'))

into these:

    // accepts null product
    if (offer.products && offer.products.length) {display(offer.products[^0])}
    if (offer.products) offer.products.forEach(preload)
    if (offer.products) preloadAll(offer.products.pluck('id'))

The first line (`if (products) {...}`) already had a conditional, so we stuck
the new test into the existing conditional. The other two lines didn't, so we
wrapped the original code in new conditionals to hold the new test.

## Scalability

The "ifs and ands" solution _works_, but it _doesn't scale_. ("Doesn't scale" is
Enterprise for "I don't like it." In this case, I'll
<strike>rationalize</strike> define "scale" as "grows linearly and
compositionally with the number of variables and/or the complexity of the
syntactic context".)

First, like the "temporary variable" solution, it's non-local -- it involves
changing an expression into a statement, and therefore the expression that
_contains that expression_ into a statement, and so on up the line.

It's also non-linear (in the sense of linear logic[^6], not linear algebra).
Where an expression occurs once in the original code, it occurs twice in the new
code. It evaluates `offer.products` three times instead of twice in the first
case, and twice instead of once in the other two.

To see why this is bad, imagine if instead of `offer.products` it were
`offer.getProducts`, or `customer.offer.products`, or
`((customer||{}).offer||{}).products`. Or imagine if it were an expression that
had side effects -- then the first example wouldn't have worked anyway, but we
would have just broken the other two.

To get another taste of how the expressions replicate with this strategy, take a
look at what happens when here's more than one of them. What if there are two
such properties, `offer.products` and `offer.merchants`, and we only want to
execute our code if they're both non-empty? Here's the case for non-nullable
arrays:

    // offer.products and offer.merchants are non-null
    if (offer.products.length && offer.merchants.length) {...}

This code transforms into this:

    // offer.products and offer.merchants may each be null
    if (offer.products && offer.products.length &&
        offer.merchants && offer.merchants.length) {...}

Or let's say we wanted to sum the lengths of two properties, `offer.ordered` and
`offer.saved`. The code for the non-nullary case is simply `offer.ordered.length
+ offer.saved.length`. The nullary case balloons into a statement sequence:

    // offer.products and offer.merchants may each be null
    var count = 0;
    if (offer.ordered) count += offer.ordered.length;
    if (offer.saved) count += offer.ordered.length;

Or we could use the ternary operator, but still at the cost of typing (and
evaluating) each nullable subexpression twice:

    // offer.ordered and offer.saved can each be null
    (offer.ordered ? offer.ordered.length : 0) : (offer.saved ? offer.saved.length : 0)

The problem with all of these is that we've had to write out each variable name
twice, inviting defects. In fact, I made a paste-o in one of the examples above.
I could fix it, but I bet I'd make it again if I later changed the code to
include `offer.wishlist` in the count.

## Solution 3: Inlined fromMaybe

Here's an alternative. To change code that expects a non-nullable array to a
nullable array, change `array` to `array||[]`. This is a local transformation:
it changes an expression into an expression (not a statement), so you don't need
to re-write the code that contains it. It's also a linear transformation (again,
in the sense of linear logic, not linear algebra): an expression that only
occurs once before the transformation, only occurs once after it.

The original solutions transform thus:

    // offer.products can be null
    if ((offer.products||[]).length) {...}
    (offer.products||[]).forEach(...)
    if ((offer.products||[]).length || (offer.saved|[]).length) {...}

Note that each transformation is local: no new control structures are
introduced, so there's no cascade of expression -> statement transformations up
the syntax tree. We can see that by the fact that the troublesome `loaded` case
remains largely intact.

    // offer and offer.products can each be null
    var loaded = offer && preloadAll(offer.products||[]).length);

Here's the summation code:

    // offer.ordered and offer.saved can each be null
    count = (offer.products||[]).length || (offer.saved||[]).length;

## Beyond Arrays and JavaScript

This technique works in any language where arbitrary values can be used in a
boolean context (that is, practically every language except Java) and where
`null` is considered false, and for any type whose values test true. This
includes Object and Array in JavaScript, additionally Number and String in Ruby
(since 0 and "" are considered true in that language), and -- well, the moral
equivalent of Object types in Python, since Python collections [implement
**nonzero**() or **len**()](http://docs.python.org/lib/truth.html).

But actually we can go ahead and use the technique even with types that contain
a false value, where we want to replace that false value by a default anyway
(either the same false value, or a different value that tests as true). For
example, even though JavaScript `""` tests false, we can use `inputString || ""`
to coerce a nullable string to a non-null string, since it will `null` and `""`
are the only two values that it will change to `""`

Here are some examples that go beyond arrays. First, using the ternary operator.
(Which isn't so bad here, since the expression is in a variable already -- bear
with me and pretend the expressions are more complex):

    var count = products ? products.length : 0; // the original example: an array
    var value = inputString ? parseInt(inputString, 10) : 0; // string
    var option = options ? options.key : 'default'; // Object used as dictionary
    var result = fn ? fn(argument) : defaultValue; // Function
    sprite.moveTo(x ? x : 0, y ? y : 0); // number

And now, using the inlined `fromMaybe` technique, in JavaScript, Ruby, and Python:

```javascript
// JavaScript
var count = (products || []).length;
var value = parseInt(inputString || '0', 10);
var option = ({key:'default'}.key;
var result = (fn || Function.K(defaultValue))(argument);
sprite.moveTo(x || 0, y || 0);
```

```ruby
# Ruby
count = (products || []).length
value = (inputString || '0').to_i
option = (options || {:key => 'default'})[:key]
sprite.move_to(x || 0, y || 0)
```

```python
# Python
count = (products or []).length
value = int(inputString or '0')
option = (options or {'key': 'default'})['key']
sprite.moveTo(x or 0, y or 0)
```

## The Real Thing

For reference, here's how these examples look in Haskell.

    let count = length (fromMaybe [] products)
    let value = read (fromMaybe "0" inputString)
    let option = lookup (fromMaybe [["key", "default"]] options) "key"
    moveTo sprite (fromMaybe 0 x) (fromMaybe 0 y)

This is fairly unidiomatic Haskell. You can do a lot better, by modifying the
_functions_ instead of the _values_:

    let count = maybe 0 length products

Scala also has a nullable type
([`Option`](http://blog.lostlake.org/index.php?/archives/50-The-Scala-Option-class-and-how-lift-uses-it.html)),
with a `getOrElse` method.

    val count = (products getOrElse List()).length

Although, as with Haskell, you'd write this differently in idiomatic Scala:

    val count = products.map(_.length) getOrElse 0

---

[^1]: `forEach` was [added in JavaScript 1.6](http://developer.mozilla.org/en/docs/New_in_JavaScript_1.6), and works in Firefox. You can get cross-browser implementations from [Dean Edwards](http://dean.edwards.name/weblog/2006/07/enum/) or the [Mozilla Developer Center](http://developer.mozilla.org/en/docs/Core_JavaScript_1.5_Reference:Objects:Array:forEach#Compatibility;) or with frameworks such as the JQuery (in the [jQuery collection plugin](http://plugins.jquery.com/project/Collection)), [Prototype](http://www.prototypejs.org/api/array#method-each) (where it's called `each`), or [MochiKit](http://www.mochikit.com/doc/html/MochiKit/Iter.html#fn-foreach) (where it's a top-level function).

[^2]: `anArray.pluck` is from Prototype. In pure JavaScript 1.6 (or another library that extends JavaScript with the 1.6 collection functions), this would be `products.map(function(product) { return product.id })`. Or in [Functional]({{ site.sources }}/javascript/functional/), it's `map('_.id', products)`

[^3]: In conjunction with monads on the cheap, in the scenario where `products` might be null because `order` might be null, the code looks like this: `var products = (order||{}).products || []`. In fact, this is simply an extension of _monads_, where the default value is the empty array, instead of `{}`.

[^4]: This disruption is in addition to the fact that now you've got to come up with a variable name (usually easy), and make sure that if you do this to two different pieces of code in the same scope you use two different variables (harder), and hold a larger set of variable names in your head when you're reading this code a year later (hardest).

[^5]: In this particular case, we could instead use the _cheap monads_ idiom `(offer||{}).products`. But not every embedding expression is a test for nullity.

[^6]: Linear logic is just a system where you can't replace once occurrence of an expression by two. I didn't link to the wikipedia page in the text because it's written for logicians, not programmers, and makes it look scary-complicated, but [here it is](http://en.wikipedia.org/wiki/Linear_logic). Failing linearity is what goes wrong in [C macros](http://en.wikipedia.org/wiki/C_preprocessor#Multiple_evaluation_of_side_effects).
