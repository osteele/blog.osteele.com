---
description: A library to test web apps JSON against a schema
date: '2008-04-17 12:07:30'
layout: post
slug: jcon-json-type-conformance
status: publish
title: JCON: Ruby Gem for JSON type conformance
wordpress_id: '289'
categories: [JavaScript, Libraries, Ruby]
tags: JavaScript, Ruby, libraries
---

[JCON](http://jcon.rubyforge.org) (the **J**avaScript **Con**formance gem) tests JSON values against ECMAScript 4.0-style type definitions
([PDF](http://www.ecmascript.org/es4/spec/overview.pdf)) such as `string?`, `(int, boolean)`, or `[string, (int, boolean), {x:double, y:double}?]`.

<!-- more -->

## Usage

    type = JCON::parse "[string, int]"
    type.contains?(['a', 1])     # => true
    type.contains?(['a', 'b'])   # => false
    type.contains?(['a', 1, 2])  # => true

JCON also defines an [RSpec](http://rspec.info) matcher, `conforms_to_js`:

    [1, 'xyzzy'].should conform_to_js('[int, string]')
    [1, 2, 'xyzzy'].should_not conform_to_js('[int, string]')  # 2 isn't a string
    {:x => 1}.should conform_to_js('{x: int}')

Use JCON together with the [JavaScript Fu Rails plugin](http://osteele.com/archives/2008/04/javascript-fu-rails-plugin) to test the argument values to functions in generated JavaScript:

    # this will succeed if e.g. response contains a script tag that includes
    #   fn("id", {x:1, y:2}, true)
    response.should call_js('fn') do |args|
      args[^0].should conform_to_js('string')
      args[^1].should conform_to_js('{x:int, y:int}')
      args[^2].should conform_to_js('boolean')
      # or:
      args.should conform_to_js('[string, {x:int, y:int}, boolean]')
    end

## Whence

Github for the [sources](http://github.com/osteele/jcon).

Rubyforge for [docs](http://jcon.rubyforge.org).

`gem install jcon` to install.

## License and version

MIT License, of course.

JCON is at version 0.1 because it's just a few days old and I had to guess about the ECMAScript 4.0 type syntax from the examples in the [overview](http://www.ecmascript.org/es4/spec/overview.pdf).  I can't imagine that I got everything right.
