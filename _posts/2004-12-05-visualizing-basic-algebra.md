---
description: Visualizing basic algebra
date: '2004-12-05 22:03:37'
slug: visualizing-basic-algebra
title: Visualizing Basic Algebra
categories: [Math Education, Visualizations]
tags: math, illustrations
---

Last weekend, I shared some interesting properties of numbers with my kids.

The great thing about explaining something to a non-expert is that you have to actually understand the topic. (This is why making teaching universities and research universities the same actually makes sense.) If you hide behind a formalism, the explanation won't work. Usually, this means that you didn't understand why the formalism worked either.

This is why I thought "why are far away things smaller?" was such a [great question](/2003/07/hard-questions). "Similar triangles" answers are brittle, and if a tiny error makes far away things come out _bigger_ instead, you won't catch yourself until you got to the end of the proof.

Some of the interesting properties of numbers are: that (_n_ + 1)Ã—(_n_-1)=_n_2-1: that the perfect squares (0,1,4,9,...) go up by successive odd numbers (1,3,5,...); and that the area of a triangular number (1+2+...+\_n_) has a closed form. These properties are easy to show using algebra, but to a child, the algebra doesn't make sense.

Multiplication and division are grounded in visuospatial concepts, which is why these number theoretical _results_ are easy to understand. What would a _proof_ that stayed grounded in visuospatial concepts look like?

## Properties of Addition

Addition is associative:

![]({{site.image_url}}/2004/grounded-proofs/line-assoc.png)

and commutative:

![]({{site.image_url}}/2004/grounded-proofs/line-commute.png)

## Multiplication is Commutative

The commutative law is that *a*Ã—_b_=*b*Ã—_a_. If a rectangle _a_ high and _b_ wide represents *a*Ã—_b_ , this is the same as saying that rotation is area-preserving:

![]({{site.image_url}}/2004/grounded-proofs/ab=ba.png)

Or, in the case of three factors, volume preserving:

![]({{site.image_url}}/2004/grounded-proofs/abc=bca.png)

## Distributive Law

![]({{site.image_url}}/2004/grounded-proofs/ab+ac.png)

## Associativity

![]({{site.image_url}}/2004/grounded-proofs/3d-assoc1.png)
![]({{site.image_url}}/2004/grounded-proofs/3d-assoc2.png)

## Difference of Squares

The perfect squares are 0, 1, 4, 9, 16, …. The differences between successive squares are the odd numbers: 1, 3, 5, 7, 9, ….

In algebra, this is because the _n_2 terms in (\_n_+1)2=_n_2+2_n_+1 and in _n_2 cancel, leaving 2_n_+1. Here's why this is true in geometry:

![](<{{site.image_url}}/2004/grounded-proofs/(n+1)^2.png>)

## Product of Alternates

| 1x1=1 | 0x2=0 |
| 2x2=4 | 1x3=3 |
| 3x3=9 | 2x4=8 |
| 4x4=16 | 3x5=15 |
| 5x5=25 | 4x6=24 |

The product of two numbers adjacent to a median, is one less than the square of the median. For example, 52=25, and 6Ã—4=25-1=24. Algebraically, this is because (_n_+1)(_n_-1)=\_n_2-1. Geometrically:

![]({{site.image_url}}/2004/grounded-proofs/4x4.png) !/images/2004/grounded-proofs/4x3.png! !/images/2004/grounded-proofs/3x3-4x3.png!

## Triangle Numbers

In closed form, the sum of the numbers from 1 to _n_ is _n_(_n_+1)/2. One algebraic proof for this uses induction: substitute each of _k_+1 and _k_ for _n_, and compute the difference.

There are two geometric proofs. The first requires two cases: one for even _n_, and one for odd. The second is simpler, but requires a bit of algebra: you need to draw _two_ triangles, and compute twice the area; at the end, you divide by two.

First, the two-case proof, and some terminology. Cut a line at an integer mark as nearly in half as you can. The big piece is the superhalf. The little piece is the subhalf.

![]({{site.image_url}}/2004/grounded-proofs/subhalf.png)

For an even number such as 6, the subhalf and superhalf are the same as the half (3). For an odd number such as 5, the subhalf (2) and superhalf (3) differ by one. The subhalf and superhalf of any integer sum to that integer: 3+3=6, and 2+3=5.

Now the first proof. If _n_ is even, take the top half of the triangle and fold it over onto the bottom half. Each row has the same length, because the base increases by one going up, and the flipped top increases by one going down. That length is the width of the original base, plus one from the tip. Since there are _n_/2 rows, the triangle has the area of a rectangle that is _n_/2 high and _n_+1 wide.

![]({{site.image_url}}/2004/grounded-proofs/1..n-even.png)

For odd _n_, take the top _sub_half of the triangle and fold it onto the bottom \_super_half, extending each row except the bottom. The new rectangle is (\_n_+1)/2 high (the superhalf), but only _n_ wide. Multiply these out, and out the same as the first case.

![]({{site.image_url}}/2004/grounded-proofs/1..n-odd.png)

A proof that doesn't require two cases is to use two triangles. Consider the two triangles, which collectively have the area *n*Ã—(_n_ + 1):

![](<{{site.image_url}}/2004/grounded-proofs/n(n+1).png>)

This is the same, in algebraic terms, of taking the sum [1+_n_]+[2+(_n_-1)]+…+[(_n_-1)+2]+[_n_+1]=*n*Ã—(_n_+1).

Next week: grounded fractions.

## Addendum

[Hans Martin Kern](http://www.extragroup.de/weblog/hmk/) [suggested](http://www.extragroup.de/weblog/hmk/archives/001484.html) calling this "Visualizing Basic Algebra." That's a _much_ better name, and I've changed the title.
