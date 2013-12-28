---
date: '2004-03-27 18:37:36'
layout: post
slug: optimizing-for-broadband
status: publish
title: Optimizing for Broadband
wordpress_id: '75'
categories: [OpenLaszlo]
tags: Laszlo
---

One feature of the recent [LPS 2.0][lps-2.0] release is the KRANK feature, for optimizing application startup performance.

[lps-2.0]: http://www.laszlosystems.com/products/

Normally, when a Laszlo application launches within a browser, it runs initialization code that creates view and logic objects, binds them to dataset data,and attaches constraints.   Some of this initialization depends upon the context of the application launch (query parameters, and the contents of runtime data and media requests).  Much of it is the same each time the application is launched.

KRANK launches the application once on the developer's machine, stops the launch process after launch-context-insensitive application state has been created, and snapshots the state of the application at this point.  It then uses this state information to create a new executable that reproduces the same application state, but with instructions that optimally create the same memory structures that the original application created by running general-purpose code.  This produces an application that is typically larger than the original application, but reaches the point of first user interaction up to six to eight times quicker, because fewer instructions are executed.

This feature is similar to the Windows *hibernate* feature, where the operating system saves its memory state to disk before turning off, so that it can resume with the same state.  It's different in that KRANK snapshots a _reusable_ state that can be run on a different machine (in that respect it's more similar to operating system work on process migration), and that can be restarted multiple times and reapplied to different contexts (in that respect it's similar to continuations).

It's also similar to the *image snapshot* features of many Smalltalk and Lisp environments (including emacs).  Like KRANK, this feature creates a memory image that can be relaunched many times, often within different operating systems.  Unlike image snapshot, the KRANK feature is implemented mainly by a computation in process outside the application itself.  This eliminates the overhead of the compiler and development environment within the snapshot --- this is important for a client-side web application --- or for tree-shaking techniques to separate the application from the development environment that embeds it.

There are other techniques for optimizing Laszlo applications (and rich internet applications in general).  For example, you can toggle whether media and data sets are baked into the application (for a smaller server transaction count and a faster startup experience over broadband) or requested when the application initializes or later (for a smaller initial download size, and a faster dailup startup experience).  You can also use *deferred instantiation* --- a technique we added about two years ago, during the initial implementation of the [Behr application][behr] --- to declaratively specify that objects should be created in the background, either on a per-instance or a per-class basis.

[behr]: http://www.behr.com

The nice thing about these techniques is that they are minimally intrusive into the source code.  (In fact, KRANK is not intrusive at all, since it's more like a compiler switch such as `-o` in traditional compilers.)  They decorate the hierarchical and functional layout of the source code, rather than requiring it to be rearranged.  This is handy for a stairstep development approach, with alternating functionality sprints and performance sprints.  It also makes it easier to deploy the same application to both broadband and dialup clients, separately optimized for each.
