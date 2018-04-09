---
description: How we defined tags in OpenLaszlo XML
date: '2004-07-25 07:29:31'
slug: a-fresh-canvas
title: A Fresh Canvas
categories: [OpenLaszlo, XML]
tags: Laszlo, XML
---

Dave Hyatt has been taking some heat for introducing new HTML tags into the set of tags supported by Apple's [Dashboard](http://www.apple.com/macosx/tiger/dashboard.html).  Read the post that started it [here](http://weblogs.mozillazine.org/hyatt/archives/2004_07.html#005913).  Eric Meyer and Tim Bray take issue with the proposal [here](http://www.meyerweb.com/eric/thoughts/2004/07/07/wrapped-in-canvas/) and [here](http://www.tbray.org/ongoing/When/200x/2004/07/12/ExtendingHTML), and Hyatt responds [here](http://weblogs.mozillazine.org/hyatt/archives/2004_07.html#005928).

As the author of an [XML-based presentation language](http://laszlosystems.com/demos/), this is an issue dear to my heart.  Like Dashboard, LZX is intended for the creation of cinematic interfaces --- HTML-embedded applications that are more interactive and have a design esthetic beyond what can be achieved with portable HTML+CSS.  And like Dashboard, LZX applications leverage current browser technology.

(One difference between LZX and Dashboard is that LZX is for deploying applications into today's browsers, so it's compiled to the [swf file format](http://www.openswf.org/), instead of requiring a browser rev.  This is at the level of implementation strategy; it's not reflected in the language or API design.)

A major difference between LZX and the Dashboard extensions, at the language design level, is that LZX is an application of XML, not a dialect of HTML.  This avoids some of the issues, such as how an LZX file should render when interpreted without extensions.  However, as we shall see, the "tag import" issue is exactly the same, and LZX uses the same solution that Tim Bray objects to.  Here are the issues, and here's why.

## Foreign Tags

The "foreign" tags that LZX currently supports are limited to three:

* [XHTML](http://www.w3.org/TR/xhtml1/) tags within a `dataset` tag or a tag that extends or contains it.  For example, `**click** me`.

* The `include` tag from [XInclude](http://www.w3.org/TR/xinclude/): `include`

* Domain-specific tags within an XML island: `...`.

The presence of tags defined by a W3 standard --- XHTML or XInclude --- immediately raises the question of how to integrate them into an XML document in the LZX namespace.  These tags are intended to have the same syntax (attributes and content) and semantics (processing and rendering effect) as the tags in those standards.  Is there a way to indicate that the similarity between the LZX `**` tag and the XHTML `**` tag isn't just in the spelling?

## Namespaces

Integrating tags from multiple tag sets is exactly the issue that XML namespaces are designed to solve.  In a language designed for W3 experts, the button example would be `**click** me` --- or, perhaps more realistically, `click me`.  (The latter avoids repeating the bulky namespace declaration at the root of each fragment that includes XHTML tags.)

Consider the second, more realistic example.  There are two differences between this solution and the namespace-free solution that I listed.  First, the namespace solution prefixes each XHTML tag name with  "`xhtml:`".  Second, the namespace solution includes a namespace declaration on the document root element.  The "header" for any LZX file that contained an XHTML tag would include a namespace declaration for `xmlns:xhtml="http://www.w3.org/1999/xhtml"`.

There are two problems with this solution.  One is that it raises the bar for learning LZX from the developer who understands XML, to require an understanding of XML namespaces as well.  This may be fine if your developers are back-end XML processing gurus or server engineers who speak JSTL and Struts.  It's an artificial barrier for a number of OO and GUI developers with a background in Swing, JavaScript, or MFC.

The other problem is that even short programs are now long: there's a bit of arcana (a difficult-to-remember URL and notation) that must be stuck at the beginning of every program.  "Hello World" in LZX is `Hello World`; "Hello World" that fades out when you click on it is the single line of text below.  Requiring namespace declarations doesn't just add a couple of lines to each finished program or library file (where the tax is only a fraction of a percent); it adds to the expense of exploratory programming too, and it increases the cost of writing unit tests, which ought to be (able to be) short.

[FLASH]%http://boston.laszlosystems.com/lps-doc/goodbye.lzx?lzt=swf%,%500%,%020%[/FLASH]

    <canvas>
      <text onclick="animate('opacity', 0, 1000)">Goodbye World</text>
    </canvas>

The first problem is the "barrier to entry" that namespaces present to the newcomer.  The second problem is the "barrier to file creation" that remains even for the expert, and that manifests itself as a barrier to exploration, and to unit testing.

## Boilerplate

The namespace declaration and prefixes are boilerplate: they're common to every LZX file, and therefore don't add information about what distinguishes a specific LZX file from all others.  The use of namespaces trades self-declaring semantics (useful for automated processing and tooling) against the kinds of communication characteristics useful to programming languages and human-oriented markup.  This is a true tradeoff: there are advantages on both sides.  It's obviously the right tradeoff for a one-off document that represents the only convergence of a particular set of tag sets, or for a document whose processing is implemented by a modular set of tag handlers that are bound at runtime.  For an XML application with a cohesive tag set --- one that is more akin to a programming language --- this tradeoff is arguably wrong.

Tools can address the boilerplate problem to a certain extent.  My copy of emacs is set to insert boilerplate with the stroke of a key or if the file suffix is known, and to elide standard header text from the display of a file.  I still find that I avoid the heavy-boilerplate languages.  Emacs can't help with the tutorials and reference materials, and the boilerplate-hiding tools are imperfect and difficult to configure.  They also don't help with all the "`xhtml:`"s stuck in the _middle_ of a program.

## Wholesale Importing

What we did instead is the same thing that [Hyatt proposes](http://weblogs.mozillazine.org/hyatt/archives/2004_07.html#005951): LZX defines a number of XHTML tags, and an `include` tag, that have the same meaning in LZX as they do in XHTML and XInclude.  Tim Bray justly [objects to Apple doing this](http://tbray.org/ongoing/When/200x/2004/07/12/ExtendingHTML):

> Apple has invented a couple of hundred new elements, namely all the XHTML elements, only in the Apple namespace. Uh, I assume they're defined to have exactly the same semantics as the XHTML versions? Seems kind of unwieldy.

-Tomorrow (if I get enough sleep) take a fresh look at the design of XML namespaces in the light of the programming language features that influenced it, and explain how although what we did (and what Apple may be moving towards) is a kludge if viewed from the perspective of XML namespaces as they exist today, it can also be viewed as a prototype of a more XML namespaces as they could have been designed.-

Next week I will take a [fresh look](/2004/08/xml-namespace-reviewed.html) at the design of XML namespaces the context of other program languages, and examine how they're the same and how they differ.  [Following that](/2004/08/unqualified-imports-for-xml) I will examine how the Dashboard and LZX solutions are special cases of a general design that is useful with XML programming in general.
