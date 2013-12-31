---
description: When RDF looked feasible
date: '2003-05-16 00:27:55'
layout: post
slug: the-semantic-depths
status: publish
title: The Semantic Depths
wordpress_id: '13'
categories: [Technology]
tags: RDF, essays, technology
---

Dave Winer [misses the point](http://scriptingnews.userland.com/2003/05/12#When:4:32:21AM) of the Semantic Web.  Winer criticizes RDF as though it were an application, intended for direct interaction with users creating and searching content.  RDF isn't an application; it's an operating system, on which applications can be built.

### Semantic Silos

> "Proponents of The Semantic Web want to boil the ocean by getting people to change the way they write for the Web."

Getting people to change the way they write would be hard, but you don't have to boil the ocean with _people_.  There are already companies that uses server farms to boil the ocean into lexical tokens (one of them is a company called [Google](http://www.google.com)). One way to create the semantic web is to boil the ocean into semantics (disambiguated senses and semantic relations) instead.  The challenge is creating a social and technological context where the tools to do this boiling can get built.  RDF facilitates this.

There are already research communities that have built knowledge bases, inference and deduction algorithms, and natural language understanding technologies.  RDF is being adopted as a collaboration platform by these communities; it will reduce the amount of overlap among their efforts, focusing them on the necessary parts of a total solution.  Semantically indexing the web may still be too hard, but lexically indexing a billion pages was too hard a decade ago, so there's hope.

It can be easy to miss this aspect of RDF because a lot of the discussion of the semantic web demonstrates hand-written files, and shows how to add little bits of semantics to a document by hand.  Some of this makes for better prototyping and better pedagogy, and some of it's because RDF is used today to represent information that's about as easy to represent in RDF as in any other format, but it can be misleading about how RDF can apply to the existing web.  There was a lot of machine code written before tools to programmatically generate the stuff became ubiquitous, but that's when things really took off.

### The Architecture of Search

> ["W]hile the hype was raging, Google, which is the counter-argument, was becoming the main gateway for the Web."

The "gateway" metaphor ignores the fact that the world _wide_ web is getting _deeper_ too.  The average distance of a target page from any fixed-size entry point (such as the first page or the first ten pages of a Google search) is growing greater.  The previous generation of search engines was beginning to bog down when Google pushed the problem out, but Google is beginning to b(l)og down too as the web continues to grow.

In a deep web, an initial search will typically need to be followed by search refinement that's more sophisticated than clicking on the next 'o' in "Google" to see if the result is listed on _that_ page. People will still type "apple" to move a set of initial results into their first page, but that page will let them say whether they meant the fruit or the computer, and refine the search accordingly.  This doesn't automatically mean that there will be real semantics behind the scenes, but if you believe in this future then you should agree that the fact that Google works today doesn't mean RDF won't have a place tomorrow.
