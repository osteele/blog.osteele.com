---
description: Subversion web gui — defect
date: '2006-01-31 23:00:01'
layout: post
slug: visualizing-project-activity
status: publish
title: Visualizing Subversion Project Activity
wordpress_id: '165'
categories: [OpenLaszlo, Projects, Visualizations]
tags: Laszlo, tools, obsolete
---

Last week I wrote a couple of tools to keep track of [subversion](http://subversion.tigris.org/) checkins:

<!-- more -->

[![](/projects/images/svn2ics-thumb.png)](/tools/svn2ics)

The [Subversion Log Viewer](/tools/svn-viewer) is a master-detail list of recent subversion revisions.  It's based on the OpenLaszlo [contactlist](http://www.laszlosystems.com/lps/examples/contactlist/contactlist.lzx) example.  The nicest feature is really an afterthought: at the last moment, I added faces for authors; I think this makes projects a lot friendlier.  Right now it only adds the faces to the [OpenLaszlo](http://openlaszlo.org) log; let me know if you're interested in using this for your own project, and I'll make a public API for adding faces to a repository.

[![](/projects/images/svn-viewer-thumb.png)](/tools/svn-viewer)

The [Subversion iCalendar Gateway](/tools/svn2ics) transcodes subversion logs into iCalendar files, that you can subscribe to with Apple iCal or Mozilla Sunbird.  I find it useful for a projects that I want to check in on occasionally.  Unlike an RSS feed, it gives you a sense of the activity level and the change frequency, at least if you're a spatial person like me.

Both of these point at the [OpenLaszlo](http://openlaszlo.org) log by default, but they've got a UI for putting in any subversion repository (http: or svn: protocol only), and generating a permalink for that repository.

One caveat:  It takes a long time to request a complete subversion log, so the iCalendar gateway only requests the first 500 revisions the first time you (or anyone) view a given calendar, and then the next time anyone or refreshes the same calendar, it catches up to the present 500 revisions at time.
