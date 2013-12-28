---
date: '2005-03-08 06:25:13'
layout: post
slug: ruby-and-laszlo
status: publish
title: Ruby and Laszlo
wordpress_id: '134'
categories: [OpenLaszlo, Programming Languages, Ruby]
tags: Ruby, Laszlo
---

I first heard of Ruby at the second [Lightweight Languages Workshop 2](http://ll2.ai.mit.edu/), where Matz and I were both speakers.  This was [first public disclosure](http://people.csail.mit.edu/people/gregs/ll1-discuss-archive-html/msg04769.html) of the then-proprietary [Laszlo](http://openlaszlo.org) platform language.  I'm afraid I was more worried about preparing my talk then listening to Matz at the time!

Since then, [a](http://www.openlaszlo.org/pipermail/laszlo-dev/2004-October/000088.html) [number](http://www.almaer.com/blog/archives/cat_web_ui.html) [of](http://dnm.sieve.net/tdw/2004_10_01_entry.html) [different](http://www.warneronstine.com/cgi-bin/blosxom.cgi/tech/java/ria_laszlo.html) [people](http://www.wiremine.org/2004/07) have expressed interest in both Laszlo and [Ruby](http://www.ruby-lang.org/).  I figured I had finally better take a look at it.

I understand what the fuss is about.  Ruby is one of the rare languages with a readable embedded syntax for metaprogramming, it's well designed, and it has a mature [library for web programming](http://www.rubyonrails.com/).  What this translates to in practice is that you can program in a language with "keywords" (really just functions) suitable to the task at hand.

Compare the two class definitions below:

    class Person < Object
      attr_reader :name
      attr :location
    end

    class Person < ActiveRecord::Base
      has_one :name
      has_many :address
    end

The first definition uses the core language syntax to define a Person class that contains a getter for `name`, and both getters and setters for `location`.  The second uses Rails to define a Person [Active Record](http://www.martinfowler.com/eaaCatalog/activeRecord.html) that has one `name` record and many `address` records.  (It uses the [Foreign Key](http://www.martinfowler.com/eaaCatalog/foreignKeyMapping.html) and [Association Table](http://www.martinfowler.com/eaaCatalog/associationTableMapping.html) patterns, respectively.)  The cool thing is that `attr` and `has_one` look the same to the library user.  Ruby allows the library _developer_ to [grow a language](http://homepages.inf.ed.ac.uk/wadler/steele-oopsla98.pdf).  This lets the library _user_ write in a concise domain-specific language that embeds Ruby.

What does this mean in practice?  During my last vacation it took about five lazy vacation days with  [Ruby on Rails](http://www.rubyonrails.org/) to implement a fairly sophisticated 40-page web application with five models, two metamodels, [CRUD](http://www.google.com/search?hl=en&lr;=&safe;=active&c2coff;=1&q;=crud+create+retrieve+update+delete&btnG;=Search), cookies, image upload, and login.  (I'll write more about the application itself, if I find a few free weekends to harden it for public use.)  For comparison, it took me about the same amount of time during my previous vacation to write a much simpler ten-page PHP web application that had only _one_ model.  And I already knew a little bit of PHP, whereas I was learning Ruby and Rails from scratch.

Now, what does this have to do with Laszlo?  Laszlo certainly doesn't have any metaprogramming facilities.  It has *states*, *constraints*, and *data binding*, which extend the reach of declarative programming beyond static layouts.  (Yeah, yeah, I should write about this too; in the meantime there's docs and examples [here](http://www.laszlosystems.com/lps-2.2/docs/guide/) and [here](http://www.laszlosystems.com/lps/laszlo-in-ten-minutes/).)  I suspect that some of the people who "get" how to use metaprogramming in Ruby also get how to do declarative programming with the Laszlo features.  But I also think a large part of what Laszlo brings to the table is simply that it allows you to use conventional OO techniques in client-side browser programming.  For example,

    <canvas layout="axis: y">
      <view width="10" bgcolor="red" height="10">
        <view y="1" x="1" height="8" width="8"></view>
      </view>
      <view width="20" bgcolor="red" height="20">
        <view y="1" x="1" height="18" width="18"></view>
      </view>
      <view width="30" bgcolor="red" height="30">
        <view y="1" x="1" height="28" width="28"></view>
      </view>
    </canvas>

[DRY](http://c2.com/cgi/wiki?DontRepeatYourself)s out to:

    <canvas layout="axis: y">
      <class width="${this.size}" name="box" bgcolor="red" height="${this.size}">
        <attribute name="size" value="10"></attribute>
        <view y="1" x="1" height="${parent.height-2}" width="${parent.width-2}"></view>
      </view>
      <box></box>
      <box size="20"></box>
      <box size="30"></box>
    </canvas>

This (OOP) is old hat in the server-side world --- just like MOP is old hat to Smalltalk and Common Lisp developers --- but it's relatively new in the world of zero-install client-side platforms.  So I think the analogy between Ruby on the server, and Laszlo on the (much more resource-constrained) client, is that each of them advances advances the reach of non-academic programming:

![](/images/2005/ruby-and-laszlo.png)

**Update**:  Now that I've done more [Ruby](http://packagemapper.com) and [DHTML](/tools/rework) programming, I can see that the diagram above gives OpenLaszlo short shrift.  Although OpenLaszlo is _lower level_ that Ruby with respect to code generation and a MOP, the use of databinding [and](http://weblog.openlaszlo.org/archives/2006/01/another-approach-to-state/) [constraints](http://weblog.openlaszlo.org/archives/2006/01/conditionalize-visibility-with-constraints/) makes it _higher level_ in a different set of ways.
