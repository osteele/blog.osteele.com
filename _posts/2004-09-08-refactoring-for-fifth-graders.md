---
description: Rambling about elementary school programming
date: '2004-09-08 22:12:59'
layout: post
slug: refactoring-for-fifth-graders
status: publish
title: Refactoring for Fifth Graders
wordpress_id: '102'
categories: [Family, Programming]
tags: math, family, programming
---

I gave Miles a set of Logo programming problems:

* `sv 3` draws a square divided vertically into three columns

* `sh 4` draws a square divided horizontally into four rows

* `svn 3 4` draws a square with three columns and four rows

(These are going to build towards some work with fractions, but he won't know that unless he reads my web site.  Hi, Miles!)

The first thing he did was place a slider and a button on the screen.  The slider ranges from 1 to 10, and the button calls `sv` with the value of the slider.  He used these to test the program while he wrote `sv`, to quickly try it on different arguments without typing.  When he added `sh` he added another button, and so on for `svn`.

This looked to me like some sort of hybrid between test-driven development (with a unit testing framework or FIT), and using the command line.  It's more parameterizable than unit tests, but easier to fit into a development cycle than the command line.

What was really interesting, though, was that [Extract Method](http://www.refactoring.com/catalog/extractMethod.html) wasn't a new concept. The initial implementation of `sh` was copy-pasted from `sv`, and `svn` was copy-pasted from both of them.  I started on my [DRY](http://c2.com/cgi/wiki?DontRepeatYourself) lecture --- "see how this part of `sh` is the same as this part of `sv`" --- and he jumped the gun.  "Oh, cool, you can use aliases?!" he exclaimed, before I even modified any code.

The analogy is between files in a directory and callees in a method.  If directory could transclude its contents --- list one of its children's contents as its own --- then the analogy would be exact.
