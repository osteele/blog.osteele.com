---
layout: default
title: Oliver’s Blog
---

I published this blog from 2003 to 2008.

Maintaining it doubled as a means to keep up with server, web, and publishing
technologies. Over time it migrated from [Movable Type](http://movabletype.org),
to [Wordpress](http://wordpress.org), to
[Django](https://www.djangoproject.com), back to Wordpress, to
[Jekyll](http://jekyllrb.com) and [Ruhoh](http://ruhoh.com), to
[Hakyll](http://jaspervdj.be/hakyll/), and back to Jekyll — with unpublished
attempts in [Ghost](https://ghost.org) and [Hexo](http://zespia.tw/hexo/).

These were written when I was (obviously) much younger; but also, when the web
was younger too. Much of it now strikes me as naive. Even more may strike you as
naive, if you read these though as though they were written today. For context,
this was written before the terms “single-page application" and "AJAX" existed
(and before the concepts were in common use). The earlier posts predate jQuery,
and its predecessor Scriptaculous. For much of this time, I was working on the
Laszlo Presentation Server, which became
[OpenLaszlo](https://en.wikipedia.org/wiki/OpenLaszlo), and was an early
alternate-history exploration of these ideas, as well as data binding and
reactive web programming. It was far from clear that JavaScript would evolve to
become a software engineering language, or gain support for functional
programming.

Popular posts included [The IDE Divide](/2004/11/ides) and [Overloading
Semicolon](/2007/12/overloading-semicolon).

Posts that failed to make a splash include [Service
Clients](/2004/12/serving-clients) (an early attempt to describe what was later
named AJAX), and [Rethinking MVC](/2003/08/rethinking-mvc) (an early attempt to
describe what was later named
[MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel)).

The illustrations in my [My Git Workflow](/2008/05/my-git-workflow) have been
adapted (with permission) and improved many times. You can find better versions,
including interactive versions, elsewhere on the web.

## Posts

<ul class="post-list">
  {% for post in site.posts %}
    <li>
      <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
      <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span>
      <span class="post-description">{{ post.description }}</span>
    </li>
  {% endfor %}
</ul>

<p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS</a></p>
