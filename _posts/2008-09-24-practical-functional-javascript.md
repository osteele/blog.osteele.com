---
description: My Functional Javascript talk
date: '2008-09-24 15:06:06'
slug: practical-functional-javascript
title: Practical Functional JavaScript
categories: [JavaScript]
tags: JavaScript, functional, talks, conferences
---

I'll be giving a talk next Wednesday October 1 at [The AJAX Experience](http://ajaxexperience.techtarget.com/east/index.html), on "Practical Functional JavaScript".  This could be subtitled "distributing JavaScript across time and space", or maybe just "how to do things with functions"[^1].

<!-- more -->

A couple of years ago I found that all the interesting AJAX programs that I wanted to write involved asynchronous communication with the server (or sometimes with a Flash plugin, or sometimes within the client but with a few seconds or minutes delay). Trying to think about and debug these programs made me feel like I was just learning how to program again (or hadn't yet), and hurt my head.  But now I can emerge, sadder but wiser, head fully healed, and with this talk in hand.

I'll be covering:

* Talking REST asynchronously to your server -- *without* dipping into bleeding-edge technologies such as [Comet](http://en.wikipedia.org/wiki/Comet_(programming)) and [Bayeux](http://svn.xantus.org/shortbus/trunk/bayeux/bayeux.html).[^2]

* Deferred execution and lightweight multithreading without [Google Gears](http://code.google.com/apis/gears/api_workerpool.html).[^3]

* Messaging between the Flash and the HTML within a page.  I'll put this last so that if you aren't interested in Flash you don't have to worry about when to wake up.

This talk is really the flip side of [functional javascript](https://osteele.com/sources/javascript/functional/) and [sequentially](https://osteele.com/sources/javascript/sequentially/). Those were *non-production* experiments to take functional javascript _to an extreme_.  "Practical", on the other hand, will be about real-world techniques I've used to write web sites such as [Browsegoods](http://browsegoods.com), [FanSnap](http://fansnap.com), Style&amp;Share, and the [goWebtop Calendar](http://www.gowebtop.com), and that resulted in some of the JavaScript-related libraries [here](http://github.com/osteele).

The *main* purpose of this talk is to be useful to practicing developers.  But it should also be fun.  AJAX lets you do a lot on the web that's fun to look at and use.  It can be fun to program too, and I'd like to get some of that across.

If you're interested in the *type* of things I've posted [here](/category/javascript), but found that those zoomed through the material too quickly or that you wanted to see more of a connection to real-world production programming, then this is the talk for you.

The bad news: [It's at 8am](http://ajaxexperience.techtarget.com/east/html/eventsataglance.html).  I promise not to think badly of you if you take a nap, and to make loud noises when it's time for you to go your next talk.

Update: A draft of the talk is [here](https://osteele.com/talks/Oliver_Steele_Functional_JavaScript_v2.pdf) (PDF).  It doesn't include most of the code samples.

Update 2: The final version with screenshots of all the code is [here](http://www.slideshare.net/osteele/oliver-steele-functional-javascript-presentation).  I'll publish a runnable version of the examples soon.

Update 3: The runnable examples are [here](/2008/10/code-samples-from-practical-functional-javascript).

---

[^1]: With a nod to [Austin](http://en.wikipedia.org/wiki/J._L._Austin#How_to_Do_Things_With_Words) -- but you don't have to get that, if you aren't a linguistics geek.

[^2]: COMET and Bayeaux are cool, but the server-side support can be scary.

[^3]: Another cool technology, but for the typical occasional-use consumer-facing site, you can't count on it.
