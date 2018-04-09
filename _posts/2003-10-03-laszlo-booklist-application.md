---
description: An OpenLaszlo app I wrote
date: '2003-10-03 21:32:35'
slug: laszlo-booklist-application
title: Laszlo Booklist Application
categories: [OpenLaszlo, Projects]
tags: Laszlo
---

The animated book list at the bottom of my [home page](https://osteele.com/) was written in [Laszlo](http://www.laszlosystems.com/). It’s 42 lines of code, and was written entirely in a text editor (emacs) — all the images are courtesy of [Amazon](http://www.amazon.com/).

I was inspired to write this by [Mark](http://drdreff.blogspot.com/) and [Sarah](http://www.ultrasaurus.com/sarahblog/archives/000079.html)‘s blogroll widget and by Tucker’s [iTunes tool](http://www.ultrasaurus.com/sarahblog/archives/000079.html), and by a problem I had with my web site. A few weeks ago I added a list of books I was reading, and had recently finished. I initially created this list in HTML — it looked like [this](https://osteele.com/includes/books/index.html). I liked the visual appearance of this list, and in particular the fact that it displays the images of the book. But displaying all this author and image information took up far too much room.

The new list starts out with only titles, and you can scrub with the mouse to see the rest of the information. Clicking on a book takes you to Amazon, of course, where if you buy it I’ll get some tiny amount of money. (The point of this is to see whether anyone finds the book list useful. I’m keeping the day job either way.)

I also experimented with a version that flipped through all the books in the same screen area, but I found it too distracting. One of the advantages of the Laszlo platform is that it’s easy to try things like this out — there’s only sixteen lines of difference between that application and this one.

The application gets its information from an XML file that contains the title, author, image url, and Amazon landing page url for each book. For example, one of the entries is the XML fragment below. The whole file is [here](https://osteele.com/includes/books/index.xml).

    <book title="Cognition in the Wild"
      url="http://www.amazon.com/exec/obidos/ASIN/0262581469/"
      author="Edwin Hutchins"
      image="http://images.amazon.com/images/P/0262581469.01.THUMBZZZ.jpg" />

These `<book>` entries are sorted into categories, so the structure of the file looks like this:

    <books>
      <category name="Reading">
        <book.../>
        <book.../>
      </category>
      <category name="Recent".../>
    </books>

(I just have two categories, “Reading” and “Recent”.)

I use the same Movable Type blog that I used to use to generate the [html file](https://osteele.com/includes/books/index.html) to generate this XML file as well. Using Movable Type allows me to enter just the ASIN number for each book, instead of typing in the title, author, url, and image attributes — the [MTAmazon](http://mtamazon.sourceforge.net/) and [key values](http://www.bradchoate.com/past/keyvalues.php) plugins do the rest, roughly as described [here](http://www.bradchoate.com/past/000899.php). A handwritten XML file would work just as well if you didn’t mind editing it by hand, of course.

The url of the list of books is a query parameter in the application URL. Since the application is hosted at [myLaszlo.com](http://mylaszlo.com/), the application url ends up being `http://mylaszlo.com/lps/ows/booklist/booklist.lzx`. To retrieve a swf file that I can use embed the application into my page within an `<object>` or `<embed>` tag, I add the query parameter `?lzt=swf`. And to specify the location of the list of books, I add `&amp;blurl=https://osteele.com/includes/books/books.xml`. This becomes the value of the `<param name="movie" value="...">` attribute with an `<object>` tag, and of the src attribute of an `<embed>` tag. (View the HTML source for this page to see all.)

Now for some LZX code. The source for the entire application is [here](http://mylaszlo.com/lps/ows/booklist/booklist.lzx?lzt=source).

<dataset name="booklistdata" src="$once{global.blurl}"
           type="http" autorequest="true"/>

This fragment within the LZX file retrieves the XML document named in the `blurl=` query parameter. `<dataset>` defines an XML dataset that can be referenced via the name booklistdata later in the source code. `src` names the source of the dataset. A string value for `src` would name a static URL that the application consults; I could have written `src="https://osteele.com/includes/books/books.xml"`. The `${}` syntax specifies a JavaScript expression that is evaluated to produce the url, and `global.blurl` is a JavaScript expression that evaluates to the value of the blurl query parameter.

Later in the file, there’s an element `<view datapath="booklistdata:/books/category">`. The value of datapath is the name of a dataset (`booklistdata`), followed by an XPath expression. This expression matches each `<category>` element in the XML file; since there are two categories, two views are created.

Within this `<view>` element, there’s a child element `<view datapath="book">`. This creates one view for each `<book>` element within the `<category>`. And lastly, within this element there are elements such as `<image datapath="@image"/>` and `<text datapath="@title"/>`, which extract the values of the @image and title attributes of the `<book>`, and use them as the address of an image and the content of a text view.

In order to toggle a book’s author according to whether the mouse is over the presentation of that book, I could have given a name to the author view and added event handlers to the book view to set the author’s visibility:

    <view datapath="book"
          onmouseover="this.author.setAttribute('visible, true)"
          onmouseover="this.author.setAttribute('visible', false)">
      <text name="author" datapath="@author"/>

I did something a bit trickier, because I wanted both the author view and the image view to toggle with the mouse location. Instead of writing event handlers that set them explicitly, I added an expanded attribute to the book view, and change its value according to mouse position. Both the author and image visibility are constrained to this value.

    <view datapath="book"
          onmouseover="this.setAttribute('expanded', true)"
          onmouseover="this.setAttribute('expanded', false)">
      <image datapath="@author" visible="${parent.parent.expanded}"/>
      <text datapath="@author" visible="${parent.parent.expanded}"/>

There’s an interactive step-by-step walk through the features of LZX [here](http://laszlosystems.com/lps/lzxplorer2/lzxplorer.htm) (and my [talk](http://ll2.ai.mit.edu/) at the Lightweight Languages Conference covers these features too). I’ve written about this style of data-driven presentation [here](https://osteele.com/archives/2003/08/rethinking_mvc.html).
