---
description: An import system for XML-based languages
date: '2004-08-04 18:46:50'
slug: unqualified-imports-for-xml
title: Unqualified Imports for XML
categories: [Essays, OpenLaszlo, XML]
tags: Laszlo, XML, essays
---

In [A Fresh Canvas](/2004/07/a-fresh-canvas) I argued that there's a
human-factors advantage to allowing an XML document to contain names from
multiple namespaces without requiring namespace prefixes on the elements from
all but one of them. In [What's in a Namespace](/2004/08/whats-in-a-namespace) I
looked at how namespaces and namespace imports work in programming languages,
which generally allow both qualified imports (like XML Namespace) and
unqualified imports as well.

I also said that I would demonstrate that unqualified imports could be added to
XML in a well-defined way, if certain conditions were met. (The conditions are
that the set of names in each namespace is known when the document is processed.
This is the same condition that programming languages such as C++ and Java, that
resolve the namespace of unqualified names at compile time, impose.) Here's
where I make good on that promise.

## Running Example

The first example below is an LZX program. The second example is how the same
program would look if XHTML and XInclude elements were qualified with their
respective namespace prefixes. ^1^

_Implicit namespace qualifiers_

    <canvas xmlns="http://www.laszlosystems.com/2003/05/lzx">
      <include href="button.lzx"></include>
      <button>Click <b>me</b></button>
    </canvas>

_Explicit namespace qualifiers_

    <canvas xmlns:xi="http://www.w3.org/2003/XInclude" xmlns="http://www.laszlosystems.com/2003/05/lzx" xmlns:xhtml="http://www.w3.org/1999/xhtml">
      <xi:include href="mytext.lzx"></xi:include>
      <mybutton>Click <xhtml:b>me</xhtml:b></mybutton>
    </canvas>

In order to show that the first document can be dis-ambiguated into the same
infoset as the second example, it's sufficient to show a way to transform the
first document into the second document. I'll use an XSLT stylesheet to do this.

[^1]: I've played a switcheroo. Yesterday's no-namespace LZX example didn't even
      include the default namespace. I've added it today because the mechanism for
      defaulting the default namespace is completely different from the mechanism for
      qualifying prefix-free elements from other namespaces.

## Defining the Name Map

In order to accomplish the transformation, we'll need a map from unqualified
names to qualified names. Here's what the entries in the map look like:

| source    | target       |
| :-------- | :----------- |
| `include` | `xi:include` |
| `b`       | `xhtml:b`    |
| `br`      | `xhtml:br`   |
| `i`       | `xhtml:i`    |
| `u`       | `xhtml:u`    |
| `p`       | `xhtml:p`    |

(where `xi` and `xhtml` are the prefixes that correspond to the XInclude and
XHTML namespaces.)

I'll represent this map in an XML file as a flat list of (_key_, _value_) pairs,
where each key or value is represented by an XML element whose namespace and
name are the namespace and name of the key or value. This representation lets us
use XML Namespaces to define the namespaces for the key and value.

The keys have odd number positions, and values have even number positions.

    <map xmlns:xi="http://www.w3.org/2003/XInclude" xmlns:lzx="http://www.laszlosystems.com/2003/05/lzx" xmlns:xhtml="http://www.w3.org/1999/xhtml">
      <lzx:include></lzx:include>
      <xi:include></xi:include>
      <lzx:b></lzx:b>
      <xhtml:b></xhtml:b>
      ...
    </map>

(Purists take note: This is a schema that has been optimized for readability,
not processing. A schema that was optimized for processing would relate the
corresponding keys and values hierarchically instead of positionally; for
example, `or`. I experimented with these formats while I was writing this post
and found them so unreadable I decided it was worth the extra XSLT to process
the more readable schema above.)

To transform a document that uses unqualified names --- all names are in the
default (LZX) namespace --- into one that uses qualified names --- XInclude
names are in the XInclude namespace and XHTML names are in the XHTML namespace
--- it's sufficient to look each tag name up in this map, and if it's found,
replace it by the value.

## The Stylesheet

Here's the stylesheet that uses the map above to transform the first example
into the second example. It copies every item in the source document unchanged
unless the name and namespace of the source element match the element at an
odd-numbered position in the map. If it does, the name of the element is
replaced by the name of the element at the even-numbered position in the map.

The stylesheet only performs the replacement if it's unique. One might want it
to signal an error if an element in the source document matched more than one
key. This would match the semantics of Java, where multiple namespaces can be
wildcard-imported, but a name that is present in more than one unqualified
import must be qualified at its point of use. Alternatively, one could choose
the _last_ value, for Python semantics, or define a file that contains an
ambiguous map (that is, a relation that isn't a function) as an _error_, whether
or not the ambiguous key is used, for Common Lisp semantics.

    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

      <xsl:param name="map.file">qualify.xml</xsl:param>

      <xsl:template name="copy" match="/|`*|node()">
        <xsl:copy>
          <xsl:apply-templates select="`*|node()"></xsl:apply-templates>
        </xsl:copy>
      </xsl:template>

      <xsl:template priority="1" match="*">
        <xsl:variable name="name" select="local-name()"></xsl:variable>
        <xsl:variable name="ns" select="namespace-uri()"></xsl:variable>
        <xsl:variable name="value" select="document($map.file)/map/*[
                      (position() mod 2)=1 and
                      namespace-uri()=$ns and
                      local-name()=$name]/
                      following-sibling::*[^1]"></xsl:variable>
        <xsl:choose>
          <xsl:when test="count($value)=1">
            <xsl:element namespace="{namespace-uri($value)}" name="{local-name($value)}">
              <xsl:apply-templates select="`*|node()"></xsl:apply-templates>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="copy"></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:template>
    </xsl:stylesheet>

## Taking the Qualifiers Back Out

The same stylesheet can be used to _remove_ the qualifiers, if it's run on the
inverse map. Here's an auxiliary stylesheet that reverses a map file such as the
one above. Here's where we pay the price for the readable map file format. (We
also paid it in the complex `select` expression that initializes `value` in the
renaming stylesheet above.) This stylesheet contains a couple of extra lines,
that aren't needed for functionality, to copy the text and comments between
entries and between keys and values in an entry, so that the result is readable.

    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

      <xsl:template name="copy" match="/|`*|node()">
        <xsl:copy>
          <xsl:apply-templates select="`*|node()|text()"></xsl:apply-templates>
        </xsl:copy>
      </xsl:template>

      <xsl:template match="/map">
        <xsl:copy>
          <xsl:apply-templates select="`*"></xsl:apply-templates>
          <xsl:for-each select="*">
            <xsl:if test="(position() mod 2) = 1">
              <xsl:variable name="pos" select="position()"></xsl:variable>

              <xsl:apply-templates select="../node()[count(preceding-sibling::*)+1=$pos and not(self::*)]"></xsl:apply-templates>

              <xsl:apply-templates select="../*[position()=1+$pos]"></xsl:apply-templates>

              <xsl:apply-templates select="../node()[count(preceding-sibling::*)=$pos and not(self::*)]"></xsl:apply-templates>

              <xsl:apply-templates select="."></xsl:apply-templates>
            </xsl:if>
          </xsl:for-each>
        </xsl:copy>
      </xsl:template>
    </xsl:stylesheet>

When using this reverse map to remove namespace prefixes, an element that
matches more than key should be ignored (in contrast to the possibilities for
add-in prefixes that were listed above). This is so that an element that needs
an explicit namespace qualifier to disambiguate it, keeps this qualifier.

## Extensibility

In the example above, the relation between the LZX, XInclude, and XHTML
namespaces was baked into the processor (or whoever generates the name
resolution map). An system designed for extensibility might allow per-document
declarations, as the XML Include specification does. For example, a document
that uses unqualified imports from XInclude and XHTML might begin with
declarations to this effect:

    <canvas xmlns="http://www.laszlosystems.com/2003/05/lzx">
      <import namespace="http://www.w3.org/2003/XInclude"></import>
      <import namespace="http://www.w3.org/1999/xhtml"></import>
      <xi:include href="mytext.lzx"></xi:include>
      <mybutton>Click <xhtml:b>me</xhtml:b></mybutton>
    </canvas>

The namespace qualification stage of the processing pipeline would in this case
be responsible for retrieving or constructing maps for the XInclude and XHTML
namespaces.

## Stepping Back

Unqualified imports solve one of the XML readability problems when XML is being
used as a programming language. They let the author combine names from multiple
namespaces without writing a prefix for each element, unless this is necessary
to disambiguate the element's name.

As with unqualified imports in conventional programming languages, unqualified
imports in XML involve a tradeoff. In exchange for brevity, they introduce
ambiguity --- even if it's a local ambiguity that downstream processing
disambiguates in a well-specified manner. They complicate the rules for
determining a name's namespace --- both for processing stages (which must be
placed after the disambiguation step given in XSLT in this posting), and for
humans looking to determine which qualified name a given tag name in the
document source refers to.

Unqualified imports also give up some degree of forwards compatibility. An XML
document that uses XML Namespaces won't break if one of the namespaces is
extended with a name that matches a tag name that is used, unqualified, in the
document. A document that uses unqualified imports may.

These tradeoffs --- a more complicated qualification model, decreased chance of
forwards compatibility --- are the same tradeoffs that the use of unqualified
imports raises in programming languages. Unqualified imports aren't always
appropriate, but they would be good as a choice for XML programming just as they
are in conventional programming --- to be used when the context makes them
appropriate.

In the design of LZX, we decided the context was appropriate for unqualified
imports. The current implementation of LZX doesn't actually use this system (you
can't actually use `xi:include` and `xhtml:b`, just `include` and `b`), but LZX
is designed to be forwards-compatible with a system that does.
