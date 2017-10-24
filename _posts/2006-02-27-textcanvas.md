---
description: Library for overlaying text on an HTML5 canvas — from before canvas had drawText
date: '2006-02-27 23:13:35'
layout: post
slug: textcanvas
status: publish
title: Canvas with Text
wordpress_id: '183'
categories: [JavaScript, Libraries, OpenLaszlo, Projects]
tags: JavaScript, libraries
---

The two times that I've used the WHATWG canvas element recently, I've wanted a canvas with string rendering.  The most recent time that I've used the OpenLaszlo drawview class (which has substantially the same API), I've wanted string rendering too.

<!-- more -->

The graph in [reAnimator](/tools/reanimator) is a drawview, but with text labels for the edges.  And the graph and parse tree in the Graph and Parse tabs of [reMatch](/tools/rematch) both use WHATWG canvas for lines, but text for labels.  (These tabs are only visible in Firefox, for now.)

[TextCanvas.js]({{ site.sources }}/javascript/textcanvas.js) implements the canvas context extended with labels, for DHTML.  And "textdrawview.lzx" implements drawview extended with labels.  They share the same API, so that I can write graphics libraries (such as graph drawing) that work with both DHTML and OpenLaszlo.  That API is described [here]({{ site.sources }}/javascript/textcanvas-api).

The first example below is an OpenLaszlo application that uses textdrawview; view source [here]({{ site.sources }}/openlaszlo/textdrawview-example.lzx).

If you're using Firefox, you can also view the DHTML example.  This uses TextCanvas; open it in a separate page [here]({{ site.sources }}/javascript/textcanvas-example.html).

Files:

* [textcanvas.js]({{ site.sources }}/javascript/textcanvas.js) --- DHTML implementation

* [textcanvas-example.html]({{ site.sources }}/javascript/textcanvas-example.html) --- DHTML example (shown running above)

* [textdrawview.lzx]({{ site.sources }}/openlaszlo/textdrawview.lzx) --- OpenLaszlo implementation

* [textdrawview-example.lzx]({{ site.sources }}/openlaszlo/textdrawview-example.lzx) --- OpenLaszlo example (shown running above)

* [textcanvas-api]({{ site.sources }}/javascript/textcanvas-api) --- API documentation

Some example code:

    // <div id="canvasContainer"></div>
    var container = document.getElementById('canvasContainer');
    var textCanvasController = new TextCanvasController(container);
    var ctx = textCanvasController.getContext('2d');
    ctx.moveTo(0, 0);
    ctx.lineTo(100, 100);
    ctx.stringStyle.color = 'red';
    ctx.drawString(0, 0, "red");
    ctx.stringStyle.color = 'blue';
    ctx.drawString(100, 100, "blue");
