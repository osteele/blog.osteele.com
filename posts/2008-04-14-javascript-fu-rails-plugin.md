---
description: Some syntax for using JavaScript with Rails
date: '2008-04-14 19:36:05'
layout: post
slug: javascript-fu-rails-plugin
status: publish
title: JavaScript Fu Rails Plugin
wordpress_id: '278'
categories: [JavaScript, Libraries, Ruby]
tags: [JavaScript, Ruby, libraries]
---

[JavaScript Fu](http://github.com/osteele/jcon) extends Rails with a few facilities to better integrate JavaScript into Rails development:

<!-- more -->

1. The `notes` and `statistics` rake tasks compass JavaScript files in the `public/javascript` directory:

~~~
    $ rake notes
    public/javascripts/controls.js:
      * [782] [TODO] improve sanity check

    $ rake stats
    | Name                 | Lines |   LOC | Classes | Methods | M/C | LOC/M |
    [...]
    | JavaScript           |  7287 |  6322 |       0 |       0 |   0 |     0 |
    [...]
~~~

2. The `call_js` [RSpec](http://rspec.info/) matcher asserts that a string or response contains a script tag, that contains JavaScript that calls the named function or method:

~~~
    response.should call_js('fn')
    response.should call_js('fn(true)')
    response.should call_js('gApp.setup')
~~~

If you pass a block to `call_js`, it's called back with the argument list, parsed as though it were a JSON array:

    # matches <script>fn(1, 'aString', {x:10,y:20})< /script>
    response.should call_js('fn') do |args|
      args[^0].should == 1
      args[^1].should == 'aString'
      args[^2].should == {:x => 10, :y => 20}
    end

Use this with [`jcon`](http://jcon.rubyforge.org/) to test for type conformance, using ECMAScript 4.0 type definitions.  <strike>(Well, you can't use it with `jcon` yet, because I haven't released it -- this is just a teaser.  But you can [peek](http://github.com/osteele/jcon).)</strike>

    response.should call_js('fn') do |args|
      args[^0].should conform_to_js('[Array, (int, boolean)]')
      args[^1].should conform_to_js('{x: double, y: double}')
      # or just:
      args.should conform_to_js('[[Array, (int, boolean)], {x: double, y: double}]')
    end

3. The `page.onload` page generator method generates code that executes the content
of the block upon the completion of page load:

~~~
      page.onload do
        page.call alert', 'page loaded!'
      end
~~~

These lines generate one of these (depending on whether the [jRails](http://ennerchi.com/projects/jrails) plugin has been loaded):

    Event.observe("window", "load", function() { alert("page loaded!"); });

    $(document).ready(function() { alert("page loaded!"); });

## Gitting It

JavaScript Fu is [hosted on github](http://github.com/osteele/javascript_fu).  If you have git installed, you can clone it into your Rails directory thus:

    git clone git://github.com/osteele/javascript_fu.git vendor/plugins/javascript_fu

If you're running off Edge Rails (or, presumably, Rails > 2.0.2), you should be able to do this instead:

    script/plugin install git://github.com/osteele/javascript_fu

Otherwise, you can simply download the tarball from [here](http://github.com/osteele/javascript_fu/tarball/master).

Update: changed the `conform_to_js` example so that it actually works with the (albeit unreleased) plugin..
