---
description: This was kind of cool when Flash was still a useful web technology
date: '2008-04-13 07:27:07'
layout: post
slug: flashbridge
status: publish
title: FlashBridge: proxying Flash  OpenLaszlo
wordpress_id: '270'
categories: [JavaScript, Libraries, OpenLaszlo]
tags: [JavaScript, flash, Laszlo, libraries]
---

I've updated my [OpenLaszlo utility grab-bag](http://github.com/osteele/lzosutils) to make browser <-> applet communication even easier.  How easy?

<!-- more -->

## Proxies

Put this in your browser JavaScript:

    var gObject = {
      f: function() { console.info('gObject.f', arguments) },
      g: function() { console.info('gObject.g', arguments) }
    };

And this in an OpenLaszlo applet:

    var gObject = FlashBridge.createRemoteProxy('gObject', ['f', 'g']);
    gObject.f(1, 2);
    gObject.g(3);

When you run the applet code, it prints this to the browser console:

    gObject.f [1,2]
    gObject.g [^3]

That's right, Flash is invoking the function calls, but they're executing in the browser.

Now switch these around -- put the first block in the applet, and the second block in the browser JavaScript -- and it still runs the same way, except that it's the *browser* that invokes the functions, and they run in the *applet* (and print to the OpenLaszlo debug console, if the applet was compiled with debugging on).

(By the way, the full sources for the examples are [here](http://github.com/osteele/lzosutils/tree/master/test/flashbridge).)

## Return Values

Callbacks, or continuations for return values, make it easy for the applet to operate on the return value from a call into the browser, even though these calls are asynchronous.

Put this in the browser:

    var gService = {
      add: function(a, b) {
        logCall('gBrowserObject.add', arguments);
        return a+b;
      },
      error: function(msg) {
        logCall('gBrowserObject.error', arguments);
        throw msg;
      }
    };

And this in the applet:

    gBrowserObject.add(1, 2).onreturn(function(value) {
      console.info('1 + 2 -> ' + value);
    });
    gBrowserObject.error('error msg').onexception(function(value) {
      console.info('error !> ' + value);
    });

The argument to `onreturn` is called (asynchronously) with the return value.  The argument to `onexception` is called with the message from the exception, if an exception occurred.

Callbacks, unlike proxies, only work one direction -- for calls from the applet to the browser.  That's not for a technical reason -- I've just only needed it one direction so far.

## Call Storage

Browser code can call into the applet even if the applet hasn't initialized yet, and vice versa.

To implement this, each side of the bridge stores calls (and return value handlers) in a [mailbox](http://en.wikipedia.org/wiki/Mailbox_%28computing%29) until it hears back that the other side has loaded.  Once this happens, the mailboxes are flushed and the remote call methods switch to direct invocation.

This works around a couple of race conditions.  First, the applet won't generally have run its initialization code by the time the browser receives its load event, so a naive implementation of the bridge wouldn't allow the browser to make calls into the applet until the browser had heard back that the applet had loaded -- which is hard to detect.  (It isn't enough to wait for the object's onload event, because this can trigger before the first frame of the movie plays, so the applet may still not have initialized enough to receive messages.)  Conversely, depending on your page organization and initialization raindance, the applet might load before page side has registered -- so the applet couldn't call into the page until an unknown time.

## Security Implications

FlashBridge, by default, allows the browser to call anything sitting in the applet, and vice versa.  This increases the attack surface of your application, because it allows an embedded Flash applet to invoke any part of it.  This means that an XSS can tunnel through your applet to gain access to any site with a `crossdomain.xml` file that allows your applet to connect to it -- something that XSS on a pure JavaScript page can't do.

It you prefer not to audit your application against this, you can call `FlashBridge.secure` to prevent it from accepting arbitrary calls, and then `FlashBridge.register` to register callins.

There's no lockdown facility in the other direction -- to lock down the browser JavaScript against calls from the Flash application.  That's because it's trivial for a Flash application to invoke arbitrary JavaScript in the browser context -- in fact, that's how the applet -> browser communication is implemented, and if that were secured at the FlashBridge layer, the vulnerability would still be accessible one layer down.

## Gitting It

All this is in the [LzOsUtils project on GitHub](http://github.com/osteele/lzosutils), with examples [here](http://github.com/osteele/lzosutils/tree/master/test/flashbridge).  Download it via the Download button, clone it via `git clone git://github.com/osteele/lzosutils.git`, or add it as a submodule to an existing git repo via `git add submodule git://github.com/osteele/lzosutils.git`.

FlashBridge is written for OpenLaszlo, but would probably run in straight Flash too. And it uses my own funky alternative to `ExternalInterface` for calling from Flash to the browser (since the built-in API is [seriously broken](http://codinginparadise.org/weblog/2005/12/serious-bug-in-flash-8.html)), but it could be ported to run on top of Dojo or something pretty easily.
