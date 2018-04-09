---
description: Namespacing for XML
date: '2004-08-02 00:47:30'
slug: whats-in-a-namespace
title: What’s in a Namespace?
categories: [OpenLaszlo, XML]
tags: Laszlo, XML
---

[Last week](/2004/07/a-fresh-canvas) I discussed the fact that "namespace hygiene" --- the use of XML namespaces --- would cause a simple Laszlo program such as this one:

    <canvas>
      <include href="button.lzx"></include>
      <button>Click <b>me</b></button>
    </canvas>

to balloon to the following mixture of namespace declarations and namespace prefixes:

    <canvas xmlns:xi="http://www.w3.org/2003/XInclude" xmlns="http://www.laszlosystems.com/2003/05/lzx" xmlns:xhtml="http://www.w3.org/1999/xhtml">
      <xi:include href="mytext.lzx"></xi:include>
      <mybutton>Click <xhtml:b>me</xhtml:b></mybutton>
    </canvas>

This namespace explosion isn't a problem for the server-side Java engineer or the XML-savvy processing pipeline plumber.  XML is moving in this direction, and the preceding document isn't overly heavy on punctuation compared to the typical XSLT source file, Jelly file, or JSP file that uses tag libraries.

It is a problem for a number of OO, GUI, and DHTML developers that should also be able to use LZX.  The _concepts_ associated with LZX aren't that difficult, and don't have anything to do with the hard problems in document integration that XML Namespaces are intended to resolve.

I also believe that the extra verbosity slows the speed of even expert developes, because it gets in the way of simple examples, in documentation and pedagogy, and exploratory programming and unit testing during development.  I suspect that this is a contentious statement, because it comes down to a difference in development styles that is masquerading as a religious issue.  I would like to discuss this later, but not today.

For now I'd like to assume there's some merit to making programs that are written in XML look more like the first example above than the second one, and explore whether this can be done in a well-defined way.

## Namespaces reviewed

A namespace is a map from names (string literals or "symbols") to something else.  The something else might be a variable, value cell, type, class, or just a longer name (which might name one of these).  If a name can mean two different things in two different contexts, then namespaces are involved.

An example from the C programming language is the difference between _struct_ names and _variable_ names.  A struct can be named `date`, and this is completely independent of whether a variable is also named `date`.  An example from Java is the _package_.  The `java.lang.awt.List` class is unrelated to the `java.util.List` interface, because one is in the `java.awt` package, and the other is in `java.util`.

Each _interface_ and _class_ in Java defines a namespace.  Two classes `A` and `B`, that are unrelated by class inheritance, can define a field named `x`.  `A.x` is unrelated to `B.x`: the two fields can have different types and visibilities.

In fact, a Java class definition defines more than one namespace.  One namespace is the namespace of fields of that class.  Another is the namespace of class methods.  A Java class `A` can therefore define both a _field_ named `A.year`, and a _method_ named `A.year`.  This is in contrast to Python, where a method is a particular kind of attribute (the Python name for "field") --- fields and methods belong to the same namespace.  (This also illustrates the difference between the space of names and the space of referents for those names.  If `B` extends `A`, then the `year`s in `A.year` and `B.year` are in different namespaces, but refer to the same method or field.)

Namespaces in programming languages solve two problems.  One is the tendency to run out of meaningful identifiers within a package controlled by a single owner.  The other is the problem of packages controlled by multiple owners.  ("Owner" here simply means someone with authority to modify the names used within the package.  If you're able to modify all the source code you use, the second problem reduces to the first one.)  Namespaces address these problems by doing away with the one-to-one correspondence between the spelling of the name and its referent.  The correspondence between the name and the named entity is now a function of the context of the name, as well as its spelling.

### Namespace selection

Given multiple namespaces, what rules are used to determine which namespace is used for a given occurrence of a name?  There are two main methods of namespace selection, or name resolution.

First, the namespace may be a function of its syntactic type.  For example, in Java, methods and fields are in different namespaces, as we saw above.  In XML, tag names and attribute names are in different namespaces.  Lisp dialects are famously divided into Lisp 1 and Lisp 2 dialects, depending on whether variables and functions share a namespace.  This method of namespace resolution is used when there's a small number of implicitly defined namespaces, as in the difference between methods and fields, or the namespaces that a class definition introduces.

The second method of namespace resolution is explicit: Each namespace has a name, and the program language has syntax for specifying the namespaces that are used in different contexts.  Java and Python use the `import` statement for this.  XML uses the `xmlns` and `xmlns:*` attributes.

(Note that if namespaces are named, as in the second method, there still has to be a way to resolve the referent of a namespace --- there has to be a namespace of names, as it were.  Often this bottoms out in a load path or other list of linked libraries.  For example, the resolution of `java.util.List` into an interface is defined by the classes on the `CLASSPATH`.)

Programming languages that use `import` generally have two styles for specifying what is imported, and two styles for specifying how the imported name is named:

### Literal and wildcard imports

Consider the difference between the following two Java statements:

```java
import java.util.List;
```

```java
import java.util.*;
```

The first line makes `List` available as a name for `java.util.List`.  The second line does this too, but makes any other class and interface names in `java.util` available, without the preceding `java.util.`, as well.

This corresponds to the distinction between the Python statements:

```java
from java.util import List
```

```java
from java.util import *
```

and also between the Haskell statements:

```haskell
import Prelude
```

```haskell
import Prelude {List}
```

The point of the multiple examples being that this is a pretty widely accepted design for namespaces, not just an accident of Java.

(Python differs from Java and Haskell in that (1) in Python, a namespace is a runtime object, and (2) `import` is defined to modify an existing namespace at runtime.  Also in Python, like XML and unlike Java and Haskell, the scope of an import can be smaller than the entirety of a source file. These are three of many other differences among the way name lookup happens in different languages, that I'm ignoring here.)

### Unqualified and qualified names

A _qualifier_ is a string that is attached to the name (usually by prefixing it), at the point where the name is used.  For instance, `List` is an unqualified name; `java.util.List` is a _qualified name_: it is the simple name `List`, prefixed by the string `java.util.` to indicate that it names the `List` interface in the `java.util` package.

Java _always_ allows qualified names.  `java.util.List` is valid as an interface name regardless of whether an import statement for `java.util` or `java.util.List` exists.  The import statement, in Java, is only for the purpose of allowing _unqualified_ names as well: in the presence of `import java.util.List` or `import java.util.*`, `List` and `java.util.List` are synonymous.

Python and Haskell require an import statement in order to use a name defined in a different code unit.  Consider the difference between the Python statements:

    import java.util.List
    from java.util import List

The first introduces `java.util.List` (but not `List`).  The second introduces `List` (but not `java.util.List`).  It is perfectly legal to include both statements in a source file.  In this case, `List` and `java.util.List` will refer to the same value.

Rounding out the example set, Haskell allows this same distinction:

    import qualified Prelude
    import qualified Prelude {List}

Note that the distinction between qualified and unqualified imports is orthogonal to the distinction literal and wildcard imports:

    import java.util.List      # Qualified literal
    from java.util import List # Unqualified literal
    import java.util.*         # Qualified wildcard
    from java.util import *    # Unqualified wildcard

### Conflict resolution

What happens when _both_ `java.util.List` and `java.awt.List` are imported?  (As unqualified imports, otherwise there isn't any problem.)  There are a number of logical possibilities, but there are three that I've seen used:

* It's a compile-time error, whether or not `List` is ever used.  The Common Lisp `package` system used this.  It was incredibly painful.

* It's a compile-time error if `List` is used; otherwise it's legal.  C++ and Java use this policy.  It seems to work well.

* One takes precedence.  Python uses this policy.  It sounds like it would be a potential source of errors, but it seems to work in practice.

## Where does XML fit in

XML Namespaces allow both qualified and unqualified names.  `xmlns="http://www.w3.org/1999/xhtml"` defines a namespace that is used by unqualified tag names such as `h1`.  `xmlns:xhtml="http://www.w3.org/1999/xhtml"` defines a namespace that is used by names such as `xhtml:h1` that are qualified by the prefix `xhtml:`.

XML is like Python in that a namespace must be declared to be used.  In the absence of an `xmlns` or `xmlns:xhtml` attribute, it is impossible to use the `h1` tag from the `http://www.w3.org/1999/xhtml` namespace.  `{http://www.w3.org/1999/xhtml}h1` is often used in XML written material to refer to this tag, but this is an abbreviation for `h1` or `xhtml:h1`.  In a context that contains an `xmlns` attribute.  It's not valid XML.

XML differs from the programming languages I discussed in one important way:  *In any given context, only names from one namespace may be used without qualification*.  Unlike Java, Python, Haskell, C++, Common Lisp, and every other language I know that has explicit namespaces at all, in XML, you can't mix and match names from n different namespaces unless you prefix _n-1_ of them at each point that they're used.

For example, In Java you can import both `List` from the `java.util` package and `FastArrayList` from the `org.apache.commons.collections`, and use both `List` and `FastArrayList` without qualifiers.  (This is handy because `FastArrayList` implements the `List` interface.)

    import java.util.List;
    import org.apache.commons.collections.FastArrayList;
    ...
      List children = new FastArrayList();

In XML, you can choose one namespace or the other to use without qualification, but not both --- _even if the two namespaces don't define any tags with the same names_.  This is the same as the conflict resolution rule I found unwieldy in Common Lisp, but worse --- it's not only an error if the two namespaces share a name, it's an error just to import them both unqualified at all!

If Java did this, you would have to choose between writing:

    List children = new FastArrayList();
    java.util.List children = new org.apache.commons.collections.FastArrayList();
    java.util.List children = new org.apache.commons.collections.FastArrayList();

I think there's a reason that none of C++, Java, Python, and Haskell confines you to this choice.

## Is there a way out?

In my [next post](/2004/08/unqualified-imports-for-xml) I'll propose a way to make XML look more like a programming language in its use of namespaces, discuss where it's appropriate to do this (there are plenty of places XML Namespaces are used today where my proposal _wouldn't_ be appropriate), and give a proof of concept, in XSLT, that this can be done with a well-defined semantics.
