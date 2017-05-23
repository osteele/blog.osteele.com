---
description: An early data-binding app
date: '2003-08-08 18:56:44'
layout: post
slug: laszlo-blogging-widget
status: publish
title: Laszlo Blogging Widget
wordpress_id: '49'
categories: [OpenLaszlo, Projects]
tags: Laszlo
---

Last month I did a code sprint on a blogging aggregator written in LZX.  You can see the results at [myLaszlo.com](http://www.mylaszlo.com).  There's a screenshot on this page.  ![](http://mylaszlo.com/lps-v1/ows/lbw/lz_screenshot.jpg)

The aggregator was based on a [suggestion by Marc Cantor](http://blogs.it/0100198/2003/07/27.html).  It's a widget intended for the gutter of a blog.  Like a blogroll, it displays a list of blog titles.  Like a full-page aggregator, it displays the last few items within each blog.  And since it's a Laszlo application, it can be driven by an XML feed, and animates smoothly between visual states.

This is a record of the development process for this widget.

_Note: This isn't a tutorial.  For tutorial information about LZX, you should look at the [Laszlo web site](http://laszlosystems.com/developers/tutorials/)._

## Initial Spec

Here's the initial lightweight spec for the project:

---

The initial state of the widget is a vertical list of channel titles, followed by the Laszlo credit line, which is presented as a "virtual channel":

     Marc Cantor's Voice
     Ben Hammersley
     David Isenberg
     Joi Ito.com
     Powered by Laszlo
       [Laszlo logo]

When you scrub over a item such as "Marc Cantor's Voice", it expands to show additional detail and entries. If any other item is expanded, it unexpands to make room for this (similar to tabslider). When transitioning from the initial state, this means that the Laszlo logo collapses to a single "Powered by Laszlo" credit line.

     [Picture of Marc]
     Marc Cantor's Voice
       Home LANs + Broadband + Devices <- blog summary, from site
       Sarah Gets Into It <- last n blog headlines
       Technorati Developer's Wiki
       Forum View of Blog Posts
       Slashdot has banned my...
     Ben Hammersley
     David Isenberg
     Joi Ito.com
     Powered by Laszlo

If the channel doesn't supply a picture, then a larger number of recent posts are shown instead.

### Issues:

* Should the blog posts shown with a scrollbar, so we can show more than four (or however many)?

* Should scrubbing a blog post expand it to show details, instead of overlaying them?

* Should the blog post details show a comment count? Or should the title, through a number or icon? (I think not for the first version.)

* Sarah would like the picture always to be shown. (This doesn't allow space for as many channels.) Or maybe the picture should be replaced by the postings when you roll over it. Sarah also has more notes in her email, that I haven't integrated here.

---

## Architecture

I had already written a JSP that applied a stylesheet to an XML document, and returned the transformed document.  (I used this to write the [](/2003/06/prettyprinting_wth_xslt.html)LZX source viewer.)  I decided to use this JSP to normalize the RSS dialects into a single structure that could be used to drive a [Data-Driven Presentation](/2003/08/rethinking_mvc.html).  I also used it to aggregate multiple RSS channels into a single document, in order to minimize the client-server requests.

The front end was relatively trivial.  It ended up at [94 lines of source code](http://mylaszlo.com/lps-v1/viewer/viewer.jsp?file=/ows/lbw/lbw.lzx), after I added formatting and animation.

![](images/2003/model-view-server-client.png)

## Development Process

### Hour one:

Grabbed an RSS feed, and created an application that bound views to the XML elements in the feed.  This got me something that could display either an RSS 0.91 or an RSS 1.0 feed, depending on how I edited a few lines of the application.

I used `dataset` to create a dataset named `channels` and bind it to an XML feed, and code like this to bind a view to the data in the feed:

    <view datapath="rss:/rdf/channel">
      <simplelayout axis="y"></simplelayout>
      <text datapath="title/text()"></text>
      <text multiline="true" datapath="description/item()"></text>
      <view datapath="item">
        <simplelayout axis="y"></simplelayout>
        <text datapath="title/text()"></text>
        <text multiline="true" datapath="description/text()"></text>
      </view>
    </view>

(This is an instance of the [Data-Driven Presentation](/2003/08/rethinking_mvc.html) pattern.  [This tutorial](http://laszlosystems.com/developers/tutorials/data.php) describes the use of the `datapath` attribute, and [this one](http://laszlosystems.com/developers/tutorials/data_app_1.php) shows how to use data binding to build an application.)

Matching the view structure to the XML structure was a hassle, because the failure mode for failing to match the structure of the XML was silent, and because the APIs for inspecting XML data were difficult to figure out so I couldn't use the debugger to inspect the structure.  (The APIs are being fixed for the next release.)

### Hours two and three:

Got a more complete understanding of the difference between RSS 0.91 and RSS 1.0, and wrote an XSLT stylesheet that normalized them both into RSS 1.0.  With this as a backend, I could use the same front end to display either dialect, without changing the application source.

I could have done this by adding logic to the application, but XSLT seemed like the right tool for the job.  It was more work to set up and learn, but making changes was very easy.

### Hour four:

Designed an XML description of a list of channels, and extended the stylesheet to read this description and aggregate the channels.  Learned how to use the XSLT `document` tag.

The XML channel description looked like this:

    <channels>
      <channel url="..." title="..."></channel>
      <channel url="..." title="..."></channel>
    </channels>

The aggregated channels feed looked exactly the same, except that each `channel` tag was replaced by the target of the url, normalized to RSS 1.0.

If I'd investigated OPML more I would have used it instead.  I was on an airplane at this point with only the RSS feeds I'd cached to work with, and my example OPML files didn't have title attributes so I thought this wasnt part of the format, and I might as well make up my own.

### Hours five and six:
Extended the front end to show multiple channels.  Added the channel description and image.  This took a while because I had to try several different layouts before I got something that looked nice both with and without a blog picture, and then I had to learn some new features to resize the image correctly.

_At this point I had something functionally complete, but ugly.  It looked like it had been designed by a programmer.  (It had.)_

_I showed the result to our visual designer, Peter Andrea, for a consult.  Peter recommended a different way to animate between blogs, a border here, some color choices there, and gave me some artwork for the "Powered by Laszlo", and I went back to work._

### Hour seven:

Plugged in the artwork and the color changes.  Changed the "Powered by" area from a "virtual channel" generated on the server, to a hardcoded UI element in the application source.  (One of Peter's suggestions was that it should look and behave more differently.)

### Hours eight and nine:

Added borders.  This was the other major hassle (aside from debugging data binding -- see hour one) that had to do with presentation language.  I had to nest a couple of existing views inside of other views and this threw off both the automatically computed sizes and the code that traversed the hierarchy to refer to views.  (There wasn't much of this code, but it was hard to change correctly.)

Later I realized I should have written a "bordered view" class.  This might have avoided these problems, since the view hierarchy wouldn't have changed if I'd used this class.

    <class defaultplacement="'content'" name="borderedview">
      <attribute name="leftMargin" value="2"></attribute>
      <attribute name="rightMargin" value="2"></attribute>
      <attribute name="topMargin" value="2"></attribute>
      <attribute name="bottomMargin" value="2"></attribute>
      <attribute name="innercolor" value="0xFFFFFF"></attribute>
      <view name="content" width="${parent.width - leftMargin - rightMargin}" height="${parent.height - topMargin - bottomMargin}" bgcolor="${innercolor}" y="${topMargin}" x="${leftMargin}"></view>
    </class>

## What Next?

Marc and some folks at Laszlo are collaborating on a more complete version, that includes more features and an industrial strength back end.  (My aggregator only works with valid XML feeds.  In the real world, [you can't count on valid feeds](http://www.xml.com/pub/a/2003/01/22/dive-into-xml.html).)  My goal with the prototype was to evaluate [our current product](http://www.laszlosystems.com) as a development platform, by putting together something simple yet functional, and attractive enough to be at home on a well-designed web page.

If I were to keep working on this application, I would clean up the code and create a "bordered view" class, and add some of the features I didn't get around to, such as rollover information about individual blog entries.  Then I would plug an RSS tidier into the back end, so that I could point it at any (even ill-formed) RSS feed.  That's the point at which I would put it on my own web site.  Skinning, to match different web page styles, and a graphical configurator, would make it more useful to other people too.
