---
description: My roundrect library from before CSS had this
date: '2006-03-23 12:52:35'
slug: javascript-gradient-roundrects
title: JavaScript Gradient Roundrects
categories: [JavaScript, Libraries, Projects]
tags: JavaScript, libraries
---

[JavaScript Gradient Roundrects]({{ site.sources }}/javascript/docs/gradients) adds gradient roundrects to an HTML page, without images.  It uses the WHATWG canvas tag if it's available.  Otherwise it uses a stack of divs, whose heights are adaptively chosen according to the height of the graded element, the color components, and the radius curvature.  There's a demo [here]({{ site.sources }}/javascript/demos/gradients.html).

I also wrote a [JavaScript CSS parser]({{ site.sources }}/javascript/docs/divstyle) that lets you attach gradients to an element without writing code.  You do this by including CSS inside a div tag whose class is 'style'.  View the source of the [demo page]({{ site.sources }}/javascript/demos/gradients.html) for an example.
