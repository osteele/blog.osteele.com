---
description: My try at golfing
date: '2008-02-28 17:59:08'
layout: post
slug: fizzbuzz-station
status: publish
title: FizzBuzz Station
wordpress_id: '267'
categories: [Amusements, Illustrations, Ruby]
tasg: [fun, ruby, fizzbuzz]
---

Uh oh!  I [overthought fizzbuzz](http://weblog.raganwald.com/2007/01/dont-overthink-fizzbuzz.html:)

![](http://images.osteele.com/2008/fizzbuzz-station.png)

<!-- more -->

---

The following Ruby snippets aren't quite the same as the automaton above ([this Haskell version](http://reddit.com/r/programming/info/10d7w/comments/c10g19) is actually closest to that), but here's a couple of Regexp solutions in a style that I haven't seen before.  They have a kind of Turing-tape flavor to them.

    puts (1..100).map { |n| '1'*n+":#{n}\n" }.join.
      gsub(/^(1{5})*:/,'\0Buzz').gsub(/^(1{3})*:/,'Fizz').gsub(/.*:|(z)\d+/,'\1')

    puts (1..100).map { |n| 'x'*n+"#{n}\n" }.join.
      gsub(/^(xxx)*\d/,'Fizz').gsub(/[05]$/,'Buzz').gsub(/^x*|\d*(.+?)\d*/,'\1')

I'm not much of a golfer, so please let me know in the comments if you tighten them up any.
