---
description: Nowadys the browser developer consoles do this
date: '2008-05-01 06:02:08'
layout: post
slug: jquery-profile-plugin
status: publish
title: jQuery Profile Plugin
wordpress_id: '311'
categories: [JavaScript, Libraries]
tags: [JavaScript, jquery, plugin, github]
---

Yesterday I was profiling a page that used jQuery.  The page took a long time to initialize.  Firebug Profile (a _great_ tool) told me that the time was in jQuery, but that wasn't much help -- the page initialization code had a _lot_ of calls to jQuery, to bind functions to various page elements, and most of them were harmless.

Hence, [jQuery.profile](http://plugins.jquery.com/project/profile).  Stick this in your page, call `$.profile.start()` to start profiling calls to `$(selector)`, and then `$.profile.done()` to stop profiling and print out something like this:

<!-- more -->

    Selector                 Count  Total  Avg+/-stddev
    script, script, scri...    100    101ms  1.01ms+/-1.01
    script                   200     58ms  0.29ms+/-0.53
    html body #output        100     55ms  0.55ms+/-0.74
    script, #output          100     54ms  0.54ms+/-0.73
    #output                  100      6ms  0.06ms+/-0.24

Or just include a `?jquery.profile.start` query parameter in your page URL to begin profiling automatically as soon as the plugin is loaded.

The repository is on [GitHub](http://github.com/osteele/jquery-profile), so you can can comment here or fork it from there if you've got something to say.
