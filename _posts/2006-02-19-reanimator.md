---
description: Visualizing regular expressions as NFA’s and DFA’s
date: '2006-02-19 16:50:19'
slug: reanimator
title: Visualizing Regular Expressions
categories: [OpenLaszlo, Projects, Python, Visualizations]
tags: regular-expressions, tools, visualizations
---

![](http://images.osteele.com/2006/rematch-small.png)

Here's something I've wanted for a long time.  So I finally [built it](/tools/reanimator).  [reAnimator](/tools/reanimator) is a tool for visualizing how [regular expression](http://en.wikipedia.org/wiki/Regular_expression) engines use [finite-state automata](http://en.wikipedia.org/wiki/Finite_state_automaton) to match regular regular expression patterns against text.

<!-- more -->

This is intended to demonstrate the _implementation_ of regular expressions.  If you want to learn _how to use them_ instead, I recommend these references instead:

* [Regular-Expressions.info](http://www.regular-expressions.info/)

* A.M. Kuchling's [Regular Expression HOWTO](http://www.amk.ca/python/howto/regex/)

* Steve Mansour [A Tao of Regular Expressions](http://sitescooper.org/tao_regexps.html)

* Jeffrey Friedl's [Mastering Regular Expressions (Amazon)](http://www.amazon.com/gp/product/oliversteele-20/0596002890)

* The Regular Expression Library's [list of resources](http://www.regexlib.com/Resources.aspx)

* **New** My own [reWork](/tools/rework) online regular expression workbench.

## The User Interface

The screen has these areas:

### The Pattern

The "pattern" shows the regular expression.  Click on it to set another regular expression to match against.

<object width="377" height="46" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
  <param name="src" value="https://osteele.com/images/2006/rematch/pattern.mov"/>
  <param name="controller" value="1"/>
  <embed src="https://osteele.com/images/2006/rematch/pattern.mov" width="377" height="46" controller="1" pluginspage="http://www.apple.com/quicktime/download/"/>
</object>

### The Input

The "input" is the string that is matched.  As you type into the input string, the color of this string indicates whether it's a complete match (green), a partial match (blue), or a non-match (red).

<object width="377" height="54" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
  <param name="src" value="/images/2006/rematch/input.mov"/>
  <param name="controller" value="1"/>
  <embed src="/images/2006/rematch/input.mov" width="377" height="54" controller="1" pluginspage="http://www.apple.com/quicktime/download/"/>
</object>

### The Graphs

There are two graphs, which each display a finite-state automaton (FSA) that corresponds to the regular expression in the "pattern" area.  As you type into the "input" area, the graphs also update, to display the state of the match.

A *deterministic FSA* (a DFA) is like a board game, with a counter that is moved according to the successive letters of the input string.  The counter starts at the initial state (the leftmost circle with the arrow from off the board).  Each consecutive letter of the input string tells where to move the counter to next.  If the counter ends up in a terminal state (a double circle), there was a match.

<object width="309" height="248" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab">
  <param name="src" value="/images/2006/rematch/dfa.mov"/>
  <param name="controller" value="1"/><embed src="/images/2006/rematch/dfa.mov" width="309" height="248" controller="1" pluginspage="http://www.apple.com/quicktime/download/"/>
</object>

A *nondeterministic FSA* is the same except that when there's more than one legal move, you take them both.

<object width="222" height="250" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab"><param name="src" value="/images/2006/rematch/nfa.mov"/>
  <param name="controller" value="1"/>
  <embed src="/images/2006/rematch/nfa.mov" width="222" height="250" controller="1" pluginspage="http://www.apple.com/quicktime/download/"/>
</object>

The nondeterministic FSA bears the most direct resemblance to the regular expression.  In exchange for this simplicity in its *construction*, it's more complex to *evaluate*: instead of keeping track of just one counter, you have to keep track of a set of them.  (This is an instance of the compile-time versus execution-time trade-offs that computer science is rife with.)

If you want to learn more about finite-state automata, the [wikipedia entry](http://en.wikipedia.org/wiki/Finite_state_automaton) has some useful information, but this also seems like a good place to plug my [father-in-law's book](http://www.amazon.com/gp/product/oliversteele-20/0131655639/).

## Implementation details

![](http://images.osteele.com/2006/rematch-architecture.png)

The front end is written in [OpenLaszlo](http://www.openlaszlo.org), and compiled to Flash.  It uses AJAX and JSON to request the FSAs and the graphs.

The back end is written in Python and C.  The Python part is my [PyFSA](https://osteele.com/software/python/fsa/) library, plus a bit of glue to turn various JavaScript objects and graph files into JSON strings.  There's also a cache so that my shared server doesn't get quite so stressed even if the site becomes popular.  (Having the front end logic on the client should help here too.)

The C portion is the wonderful [GraphViz](http://http://www.graphviz.org).  PyFSA creates a .dot file for each FSA, and uses GraphViz to lay out the graph.  The server parses the annotated .dot file into a JavaScript object, and uses JSON to download the resulting graph to the client.

An OpenLaszlo class on the client interprets the JavaScript graph description into a sequence of drawing instructions.  It also saves the node positions, so that it can animate against them.

**Update**: Some of the support libraries are now available as open source.  See [JSON for OpenLaszlo](/2006/02/json-for-openlaszlo), [JavaScript Beziers](/2006/02/javascript-beziers), and [Canvas with Text](/2006/02/textcanvas).  [OpenLaszlo](http://www.openlaszlo.org) and [PyFSA](/software/python/fsa/) were available previously.

### Implementation choices

**Client vs. server**: There's no reason that this couldn't be a client-side-only application.  I just happened to have PyFSA lying around, and didn't feel like porting it to JavaScript.  My goal for this was one day of implementation time, and I didn't think porting PyFSA would fit into this.  (It ended up taking three days anyway, because I forgot about implementing cubic beziers and JSON, and because I got carried away and added animation.)

**CGI vs. FastCGI**: I've been doing most of my server-side programming with either PHP or FastCGI and Ruby, so that pages don't take so long to serve.  This is the first Python service I've deployed since I started using FastCGI, and I was planning to use it.  <strike>But Python doesn't include FastCGI in its library, and the fact that there were four different third-party libraries with different APIs, none of them endorsed, and that the [latest PEP to mention FastCGI](http://www.python.org/peps/pep-0222.html) was deferred five years ago, made me unwilling to take on the project of evaluating them.</strike>I'm glad to hear that I was completely off base about Python and FastCGI.  See Phillip J. Eby's comment below.  I stuck with CGI, which is in the standard library.

**OpenLaszlo vs. DHTML**: It would be just as easy to draw the graph itself using the [canvas class](http://www.whatwg.org/specs/web-apps/current-work/#scs-dynamic) in DHTML.  I balked at doing the animation and user interface in DHTML, though.  (There's little touches like laying the graphs out horizontally only if there's enough room, which were only a few lines of declarative code in OpenLaszlo.)  And then it wouldn't have worked on as many browsers.  I decided to wait until [OpenLaszlo compiles to DHTML](http://wiki.openlaszlo.org/DHTML_Target), for a DHTML version of this.

**PyFSA vs. â€¦**: Higher-performance (C) implementations of FSA minimization and determinization exist.  I went with my own because it's the only one I know of that has the option of preserving source location information across transformations.  I use source location information minimally in the interface, and might add more.

## Credits

Thanks to Margaret Minsky and Gary Drescher for commenting on a draft of the application.  I used Patrick Logan's [json-py](http://sourceforge.net/projects/json-py/) for server-side JSON.  The credits for [GraphViz](http://www.graphviz.org/) are [here](http://www.graphviz.org/Credits.php).  Thanks to my former colleages at [Laszlo Systems, Inc.](http://openlaszlo.org) for helping create the [OpenLaszlo](http://openlaszlo.org) platform.  I adapted Philip J. Scheider's code for subdividing cubic beziers; this is a compact implementation of [de Casteljau's algorithm](http://en.wikipedia.org/wiki/De_Casteljau%27s_algorithm) for Algol-like languages.  Thanks to Guido and company for Python.  Lastly, since people always ask, I drew the architecture diagram with [Omigraffle](http://www.omnigroup.com/applications/omnigraffle/) (gee I wish I got a commission!) --- which I like because I'm not much of a designer, and diagrams I draw with it are passable without much work.

**Update**: I changed the name to reAnimator.  (It was reMatch.)  Thanks to Apache RewriteRule for letting me do this without breaking the old URLs!
