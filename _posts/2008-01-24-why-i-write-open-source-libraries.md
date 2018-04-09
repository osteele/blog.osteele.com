---
description: Some advantages of open source hobby projects
date: '2008-01-24 22:13:10'
slug: why-i-write-open-source-libraries
title: Why Write Open Source Libraries
categories: [Programming]
tags: open-source
---

1. [Exploration](/2008/01/get-lost).  I can sample platforms and sample [stretch languages](/2006/02/stretch-languages) without sinking my stakeholders if I fail.  Also, it's easier to try something radical in a small, green field project than in a big one.

2. [Altitude training](/2008/01/make-things-hard-for-yourself) (link TBD).  I can make myself jump through hoops that I wouldn't feel ethical asking someone to pay me to jump through.  I did this recently with [Sequentially]({{ site.sources }}/javascript/sequentially); the next time I needed to simulate concurrent processes in a more serious context, it was a *lot* easier.

3. Encapsulating components.  My answer to [Steve Yegge's problem](http://steve-yegge.blogspot.com/2007/12/codes-worst-enemy.html) is to refactor my code into libraries.  When I write programs that run on Linux, or the JVM, or a browser, I get those features, but the code sizes of those libraries don't really count against me.  Why not do that with my own code, too.[^1]

This was the motivation for [LzOsUtils]({{ site.sources }}/openlaszlo/lzosutils) and [Fluently]({{ site.sources }}/javascript/fluently) (both [didn't get to](/2007/12/what-i-didnt-get-to) projects), most recently: they were part of other projects, but they were respectively large/tricky enough that I wanted to be able to compartmentalize them, and think about them separately.

5. The Golden Rule.  I've benefitted hugely from open source projects; why not give back a little?

6. You *can* take it with you!  I've written things that I want to use in more than one project; this is easier if they're in library form.  That was the motivation for [LzTestKit]({{ site.sources }}/openlaszlo/lztestkit) (another [didn't get to](/2007/12/what-i-didnt-get-to) project), most recently.

7. Fame and fortune!  Just kidding.  You get more fame from working on one project (if it's the right one) for a long time.  And there's more fortune in straight consulting.

8. More days.  I'm with [Joel](http://www.joelonsoftware.com/articles/fog0000000339.html) and Leo Babauta ([ZenHabits](http://zenhabits.net/2008/01/top-30-tips-for-staying-productive-and-sane-while-working-from-home/):) sometimes I can only work productively for four hours a day.  The trick is to have more days.  If I've got another project I can switch to when I burn out for the day on the first one, sometimes I can get another work day out of it.  (Another trick for getting another day to move from the home to the office or vice versa, or to switch cafes.)

---

[^1]: Interestingly, the extra work to some code up so that I never need to look inside it again (docs, test cases, examples) and can remember how it works years later is exactly the same work that I need in order for someone else to use it.  I use to think I could take a short cut on things I use myself, but with enough going on or enough years in between, it isn't true.
