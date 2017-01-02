---
layout: default
title: Oliver’s Blog
---

I published this blog from 2003 to 2008.

Maintaining it doubled as a means to keep up with server, web, and publishing technologies.
Over time it migrated from [Movable Type](http://movabletype.org), to [Wordpress](http://wordpress.org), to [Django](https://www.djangoproject.com), back to Wordpress, to [Jekyll](http://jekyllrb.com) and [Ruhoh](http://ruhoh.com), and finally to [Hakyll](http://jaspervdj.be/hakyll/) — with unpublished attempts in [Ghost](https://ghost.org) and [Hexo](http://zespia.tw/hexo/).

The software and projects described here have mostly been superceded, and the thoughts seemed more original and interesting to me when the internet and I were both younger, and fewer people had shared their experiences with programming, software engineering, and internet technologies. Whenever I remove them people ask where they went, though. So here they are.

Popular posts included [The IDE Divide](./posts/2004/11/ides) and [Overloading Semicolon](./posts/2007/12/overloading-semicolon).

Posts that failed to make a splash include [Service Clients](./posts/2004/12/serving-clients) (an early attempt to describe what was later named AJAX), and [Rethinking MVC](./posts/2003/08/rethinking-mvc) (an early attempt to describe what was later named [MVVM](http://en.wikipedia.org/wiki/Model_View_ViewModel)).

The illustrations in my [My Git Workflow](./posts/2008/05/my-git-workflow) have been adapted (with permission) and improved many times. You can find better versions, including interactive versions, elsewhere on the web.

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
