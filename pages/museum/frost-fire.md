---
date: '2003-05-07 10:38:00'
layout: page
slug: frost-fire
status: publish
title: Frost & Fire
wordpress_id: '254'
---

<applet ARCHIVE="applets/FrostAndFire.jar" CODE="edu.brandeis.cs.steele.applets.Corona.class" WIDTH="250" HEIGHT="250">
<table WIDTH=150 BORDER=0 CELLPADDING=0 CELLSPACING=0>
<tr><td VALIGN=TOP ALIGN=CENTER>
<img SRC="images/corona-large.jpg" WIDTH="250" HEIGHT="250" ALT="[Large still from Corona animation.]">
<caption ALIGN=BOTTOM STYLE="text-align: justify">[This image is a still from the Corona animation.  Reload this page with Java installed to see an original animation.]</caption>
</table>
</applet>

![[Large still from Corona animation.]](images/corona-large.jpg)  

[This image is a still from the Corona animation.  Reload this page with Java installed to see an original animation.]  

In 1989 I wrote a program that simulated video feedback to produce a pattern of reminiscent of paint swirling on a spinning piece of paper.  This later shipped as a module for Berkeley System's "After Dark" screen saver.  The same effect (although doubtless not the same code) is used now as a visual effect in all the music managers --- iTunes, Media Player, and so on.

I originally wrote the program because I was working on a fast bitmap rotation algorithm for [Quickdraw GX](quickdraw_gx.html).  We were trying to get bitmap rotation working at reasonable speeds on the 68000 class of processors, with no hardware acceleration, at 20MHz.  I heard that a new company called Live Picture was displaying rotated images at interactive speeds, so I rethought our algorithms from the ground up and came up with an application of the Bresenham line algorithm, simultaneously computing coordinates along virtual lines in the two spaces defined by (sourceX, destX) and (sourceY, destX) for each destination scanline, and using yet another pair of lines to update the endpoints of these two lines for each new scanline.  This gave (un-antaliased) bitmap rotation at interactive speeds on stock hardware.  (Later, I found out that Live Picture actually cached its rotated images, so the existence proof that spurred me to work on this wasn't actually valid.)

I rewrote my program in Java five or six years later, and the interpreted Java version ran faster than the handcoded assembly version of 1989 did.  Then I simplified the program by using floating-point numbers instead of fixed-point numbers, and it's still faster.  That's what you see above.  So there's no longer any coding challenge in implementing this kind of thing, but it's still a nice effect.
