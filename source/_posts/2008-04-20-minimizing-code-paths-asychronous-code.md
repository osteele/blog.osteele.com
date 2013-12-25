---
date: '2008-04-20 18:28:18'
layout: post
slug: minimizing-code-paths-asychronous-code
status: publish
title: Minimizing Code Paths in Asychronous Code
wordpress_id: '302'
categories:
- Libraries
- Tips
tags: [JavaScript, concurrency]
---

Have you ever written a function that looks like this?

    function requestProductDetails(id, k) {
      var value = gProductDetailsCache[id];
      if (value)
        k(value)
      else
        ajax.get('/product/'+id, function(data) {
          gProductDetailsCache[id] = data;
          k(data);
        });
    }

`requestProductDetails` calls its callback with the product details, which are stored in a cache.  Since it might need to request this information from the server, it has to "return" it by passing it to a callback; in order to present a uniform API whether or not the product is cached, it "returns" the data this way whether it came from the cache or not.

`requestProductDetails` is intended to be used this way:

    requestProductDetails(id, function(details) {
      infoPanel.setDetails(id, details);
    });
    infoPanel.setName(id, gProductNames[id]);

(I gave `infoPanel` a somewhat silly API in order to demonstrate a point.  The general pattern is that there's some computation in the callback, and some other computation after the call.)

There's a subtle problem in this code, which is that two different code paths run through it.  In the cached case, `infoPanel.setDetails` is called before `infoPanel.setName`.  In the uncached case (the first time through), it's the other way around.  If there's a bug that causes `setDetails` to work only after `setName` has been called, you may well miss it during casual testing, because it will only trigger the second time you trigger the code -- and once it does trigger, it will appear intermittently (especially if you have a more sophisticated cache), and be darned difficult to find.

I recommend this implementation of `requestProductDetails` instead.  It makes the _inside_ of the function more complex -- and the `setTimeout` looks gratuitous -- but it makes its _outside_ simpler : `requestProductDetails`s _callers_ are _much_ easier to debug.

    function requestProductDetails(id, k) {
      var value = gProductDetailsCache[id];
      if (value)
        setTimeout(function() { k(value) }, 10);
      else
        ajax.get('/product/'+id, function(data) {
          gProductDetailsCache[id] = data;
          k(data);
        });
    }

The general principle here is if a function _sometimes_ has to call its callback asynchronously, _always_ call it asynchronously, to minimize the number of possible code paths through the application.
