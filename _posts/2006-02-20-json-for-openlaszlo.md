---
description: My JSON library for OpenLaszlo
date: '2006-02-20 12:43:40'
layout: post
slug: json-for-openlaszlo
status: publish
title: JSON for OpenLaszlo
wordpress_id: '174'
categories: [JavaScript, Libraries, OpenLaszlo, Projects]
tags: JSON, JavaScript, Laszlo, libraries
---

[JSON for OpenLaszlo]({{ site.sources }}/openlaszlo/json/) is a [JSON](http://www.json.org/) library for OpenLaszlo.

<!-- more -->

I wrote this in order to implement my [regular expression visualizer](/tools/reanimator).

There's a live example below.  Clicking on a button requests some JSON text from the server and parses it on the client.  The source code to the example is [here](http://osteele.com/sources/openlaszlo/json/json-example.lzx).

<object width="300" height="300" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0">
  <param name="movie" value={{ site.sources }}/openlaszlo/json/json-example.swf"/>
  <param name="quality" value="high"/>
  <param name="controller" value=""/>
  <embed src={{ site.sources }}/openlaszlo/json/json-example.swf" width="300" height="300" quality="high" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"/>
</object>

(When it runs off my web site, the debugger in the example displays a warning about not being able to connect to the LPS server.  This means that the debugger can't evaluate expressions, as it could if you were running it off the SDK.  I'm just using the debugger here to print inspectable representations of the JSON parse results, and the warning doesn't affect this.)

## Rationale

OpenLaszlo implements most of JavaScript 1.5 (ECMAScript 3), but it's missing regular expressions and throw/catch, so it can't run [JSON in JavaScript](http://www.json.org/js.html).  And the OpenLaszlo compiler doesn't (yet) implement the proposed JavaScript 2.0 (ECMAScript 4) extensions such as class and type declarations, so [JSON in ActionScript](http://www.theorganization.net/work/jos/JSON.as) doesn't work either.  Hence, this implementation, which doesn't require either regular expressions or JavaScript 2.0 extensions.

It's open source, of course.  (MIT License.)
