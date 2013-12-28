---
date: '2006-02-26 22:05:48'
layout: post
slug: javascript-beziers
status: publish
title: Javascript Beziers
wordpress_id: '179'
categories: [JavaScript, Libraries, OpenLaszlo, Projects]
tags: [JavaScript, Laszlo]
---

The OpenLaszlo application below demonstrates animation along a line, a quadratic Bezier, and a cubic Bezier (the top three paths).  It also demonstrates (the bottom path) animation along a path composed of multiple segments.

<object width="320" height="300" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0">
  <param name="movie" value="http:/sources/javascript/bezier-demo.swf"/>
  <param name="quality" value="high"/>
  <param name="controller" value=""/>
  <embed src="/sources/javascript/bezier-demo.swf" width="320" height="300" quality="high" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"/>
</object>

<!-- more -->

Drag the slider back and forth to display the point on each path at t=slider.value/100, or click the "Animate" button to animate t from 0 to 1.

I wrote this in order to animate the state markers along the edges of the graph in [reAnimator](/tools/reanimator).  The GraphViz dot tool, which I'm using for graph layout, generates cubic beziers, so I had to write code to render and evaluate them.

If you're writing for <strike>FireFox</strike> a browser that supports the canvas element, you can use the same code with the new HTML canvas element.   Click on "Start Animation" to animate the points on the canvas below.  And click [here](/sources/javascript/bezier-demo.html) to open the HTML applet in its own window.

<iframe src="/sources/javascript/bezier-demo.html?inline=true" width="315" height="300" style="border: 0" scrolling="no"></iframe>

Files:

* [bezier.js](/sources/javascript/bezier.js) --- measurement, interpolation, sampling, and subdivision for arbitrary-order Beziers

* [path.js](/sources/javascript/path.js) --- measurement, interpolation, and sampling for paths composed of multiple lines and Beziers

* [bezier-demo.js](/sources/javascript/bezier-demo.js) --- the code to draw the paths in the demo.  This is platform-agnostic, and works in OpenLaszlo (bezier-demo.lzx) and HTML (bezier-demo.html).

* [bezier-demo.lzx](/sources/javascript/bezier-demo.lzx) --- the OpenLaszlo demo

* [bezier-demo.html](/sources/javascript/bezier-demo.html) --- the HTML demo

* [drawview-patches.js](/sources/openlaszlo/drawview-patches.js) --- patches to the OpenLaszlo LzDrawView.  This includes an implementation of LzDrawView.bezierCurveTo.

A couple of caveats:

* This animates along the Bezier parameterization, not the path length.  This was good enough for my application, but you could get animation that speeds up and slows down, depending on how you choose your control points.

* <strike>The demo code is written for brevity, not speed.  In particular, it re-renders the background each time, which involves some expensive math to render the cubic.  In reAnimator, I placed the animated elements on a separate view in front of the background.  I didn't do that here because I wanted to share code between the OpenLaszlo and HTML demos, and the techniques for doing overlays were too different.</strike>
Using a separate overlay for the background didn't actually speed this up.  The hot spot is the parametric position calculation.

---

[^1]: I think the reason the code doesn't work in Safari is that Bezier.draw uses the Function.apply method to apply methods on the graphics context, such as quadraticCurveTo, to argument lists.  It looks like Safari doesn't implement apply when the function is a native method.  <strike>I didn't try to work around this because in cases where I've actually tried to *use* canvas (such as the "Parse" and "Graph" tab in [reWork](/tools/rework)), there were other problems with Safari anyway.</strike>

**Update**: The inline examples weren't showing up.  Thanks to Bret Victor for both finding and diagnosing the problem.  (I was linking to my laptop, osteele.dev.  The post looked fine from my laptop!)
