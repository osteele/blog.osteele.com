---
description: A proposal for XML schema versioning
date: '2004-08-20 09:14:44'
slug: xml-schema-versions
title: XML Schema Versioning with RELAX NG
categories: [Essays, XML]
tags: XML, essays
---

XML schemas change over time, for the same reasons that library APIs evolve in programming language.  Over time, the schema designers introduce new content, and change or remove existing content, as they acquire greater familiarity with the domain model and the use cases, as they add additional functionality, and as they fix design bugs.

Often it is necessary to maintain instances of old versions alongside instances of new versions.  (I'll discuss _why_ this is necessary.)  An example is XSLT, where XSLT 1.0 and XSLT 2.0 documents may be present on the same file system.  Other examples are XHTML, and SVG.  The presence of _instances_ of multiple schema versions frequently requires the presence of _descriptions_ of multiple versions, and the problem of maintaining these multiple schema versions arises.

This posting is about the issues of maintaining and applying side-by-side versions of a schema.  It describes a stylesheet that implements one solution, _version annotation_, where a single source schema is annotated with version information that is used to create version-specific output schemas.

I use RELAX NG Compact Syntax in the examples, but most of the techniques are applicable to other schema definition languages too.

## Side-by-Side Versions

Once more than one version of a schema exists, the problem of defining multiple versions of a schema emerges.  In the simple case, previous versions of the schema definition can be abandoned, if support for them no longer exists, or frozen, where the files remain unchanged.

Sometimes edit and processing tools must support the old and new schema versions at the same time.  This is the case when the programs that process documents in the schema are distributed, so that a document author must author some documents for an older version, to take advantage of wider support, and others documents for a more recent version, to take advantage of additional features.  It's also the case for XML processors that have a compatibility code, where a single version of the processor supports more than one version of a schema.  Both of these are cases of side-by-side versioning, where documents with different schema versions are present in the same computing environment.  To the extent that the tools involved in the creation or processing of these documents use schema definitions, these scenarios require the presence of multiple schema definitions, as well.

When multiple versions of a schema definition are present in the same environment over an extensive length of time, it is useful to represent these versions in a single source file.  It is useful to the schema designer, who can make changes within the context of their interactions with previous versions of the schema definition.  It is useful to the human reader, who can see which features are available in which versions of a schema.  It is useful for schema documentation tools, which can parse both constant and changed elements of the schema from a single definition.

Maintaining a single schema source is analogous to the maintenance, in a modern programming language such as C# or Java, of a single source file that incorporates information about how the API has changed.  Java, for example, supports annotations such as `@deprecated`.  In affect, these annotations allow multiple versions of an APIs to be maintained within a single source file.  A Java source file that is annotated with `@deprecated` defines two versions of an API: one that includes the deprecated element, and another that doesn't.  These two versions can be selected for documentation generation and compilation, respectively, through the use of javadoc and compiler options which tell these tools how to process language elements marked with `deprecated`.

## Modular Schemas for Versioning

A RELAX NG schema definition can be implemented as a _set_ of RELAX NG files.  One file references the others through the use of `include`, `import`, and `external` keywords.  These files act like classes in an OO language: extensions of the schema can incorporate these documents (akin to subclassing them), and supplement or override the definitions that they contain.

If a _single_ schema definition is factored into multiple files, _multiple_ schema definition can be implemented as a sets of files that overlap.  This applied to multiple schema definitions that implement versions of a single definition.  The include mechanisms allows the version-independent portions of a schema to be placed in documents that the version-specific schema definitions include.

In a world without tradeoffs, every schema would be modular.  A modular schema definition provides the additional benefits that it can be more easily extended, and that portions of the schema can be reused in different document types.

The problem is that modularity comes with a cost in development time, and also in readability, with the accompanying increase in maintenance cost.  Separating the version-independent portions of a schema from the version-specific portions can be expensive, and the result can be unreadable.  There's an example of this below.

Modularity is often the right choice for schema _extensibility_.  However, it is an expensive price to pay for schema _versioning_ --- especially versioning of simple schemas.  Below I will describe a middle ground, that is more expensive than the single-version schema but less expensive than the fully extensible schema, that can be used when versioning is required but the expense of extensibility is not.

Modularity is also unlikely to allow extensibility in areas which the designer didn't have in mind.  In [On Versioning XML Vocabularies](http://www.xml.com/pub/a/2004/07/21/design.html), Dare Obasanjo describes the difference between schema versioning, where the schema designer maintains a linear sequence of schemas, and schema extensibility, where multiple designers make independent, concurrent changes to a schema.  Obasanjo recommends placing extensions in their own namespace.  This recommendation doesn't help with version changes, though.

## Version Selection

The changes between schema versions and document versions must be coordinated.  A document is only valid relative to a particular version of a schema that has multiple versions.

In [On Versioning XML Vocabularies](http://www.xml.com/pub/a/2004/07/21/design.html), Obasanjo analyzes some techniques for specifying schema versions .  In brief, two of these techniques are to change the namespace of the XML tags, and to attach a `version` attribute to the XML document root.  In RELAX NG, a third technique, _implicit versioning_, is equally easy to implement, but is generally inferior.

### Namespace versioning

In _namespace versioning_, the namespace is changed with each new version.  This has the disadvantage that it changes the name of every element in the namespace. It makes it difficult to share modular documents, modular schema definitions, and modular stylesheets between versions of a schema, and it complicates the implementation of editing tools and of namespace-aware processors such as XSLT stylesheets.

### Attribute versioning

In _attribute versioning_, a `version` attribute on the document root specifies the schema version.  The value of the `version` attribute matches the value of the `version` attribute that the schema definition defines.  In effect, the _pair_ of the document namespace and the `version` attribute value specifies a schema, just as the namespace alone does for an unversioned schema (or one that doesn't use attribute versioning).

The version annotation technique below works with attribute versioning.  It doesn't work as it stands with namespace versioning.

### Implicit Versioning

In _implicit versioning_, a document doesn't include any schema version information at all.  If the document is valid with respect to a schema version, then it belongs to that version.

The advantages of this solution are that the version doesn't need to be declared (instance documents are therefore more concise), and that a document that is doesn't depend on any properties of a particular schema version is valid with respect to any of those versions, and can be used in a variety of processing environments.  This is similar to the way Java works.  Many Java source files can be compiled against both JDK 1.3 and JDK 1.4, for instance.  Dependencies on a particular version of the JDK are not explicitly marked in the source, but they are detected during compilation, by the fact that they generate compilation errors when compiled against other JDK versions.

A disadvantage of implicit versioning are that it requires a validation pass to determine the version of a document.  This is a problem for editing tools and human readers.  It also increasing the processing demands on document processors that process different versions differently or that only accept documents written against one version of a schema, by making the validation step mandatory.

A second disadvantage of implicit versioning is that it can be difficult to determine, for an invalid document, _which_ version of the schema the document is an invalid instance of.

Nonetheless, the version annotation technique below works equally well for implicit versioning as it does for attribute versioning.  In fact, it can be used with a combination of attribute versioning and implicit versioning, where an explicit `version` attribute is allowed, but not required --- allowing documents that require a specific version to say so, but letting documents that are valid with respect to any version underspecify this.

## An Example

We will define a simple schema that has two versions, "version 1" and "version 2".  A version 1 document looks like this:

_v1.xml_

    <root x="1" version="1.0">
      <a></a>
    </root>

A version 1 document has a mandatory `x` attribute, an optional `z` attribute (not present in `v1.xml`), and an optional `a` child.  No other attributes or children are allowed.

In a version 2 document, the `x` attribute has been removed, and there is a new mandatory `y` attribute.  A root may have more than one `a` element (as opposed to a version 1 document, which may have just one), and a `b` element as well (as opposed to a version 1 document, which does not allow this element).  The `z` attribute is still optional.

_v2.xml_

    <root y="1" version="2.0">
      <a></a>
      <a></a>
      <b></b>
    </root>

A version 2 document is distinguished from a version 1 document by the value of its `version` attribute.  A version 1 document has a `version` of "1.0".  A version 2 document has a `version` of "2.0".

The RELAX NG Compact Syntax schemas for version 1 and version 2 documents, respectively, look like this:

_v1.rnc_

    start = root
    root = element root {
      attribute version {"1.0"} &
      attribute x {string} &
      attribute z {string}? &
      element a {empty}?
    }

_v2.rnc_

    start = root
    root = element root {
      attribute version {"2.0"} &
      attribute y {string} &
      attribute z {string}? &
      element a {empty}* &
      element b {empty}?
    }

## Schema Definition Alternatives

The annotated schema definition defines both the version 1 and version 2 schemas.  Before introducing the annotated schema, it will be useful to investigate some alternatives.  These will help to illustrate how the annotated schema works, and how it can be used to produce version-specific schemas.

### Alternative 1: Pointwise Union

The following schema accepts the union of the version 1 and version 2 schemas.  Where a version 1 document requires a version of "1.0", and a version 2 document requires a version of "2.0", this schema requires a version of either "1.0" or "2.0".  Where a version 1 document requires an `x` attribute, and a version 2 document requires a `y` attribute, the schema allows both attributes and makes them both optional.

    start = root
    root = element root {
      attribute version {"1.0" | "2.0"} &
      attribute x {string}? &
      attribute y {string}? &
      element a {empty}* &
      element b {empty}
    }

The problem with this solution is that, although it accepts any version 1 or version 2 document, it also accepts a number of documents that are neither version 1 nor version 2.  It does this because each portion of the schema accepts the content model of either version or version 2, regardless of whether the same or a different content model version was used in a different portion of the schema.  For example, the schema accepts the following hybrid document, which declares itself to be version 1 but includes some content version 1-specific content (the `x` attribute) and some version 2-specific content (the `y` attribute and the `b` element):

    <root y="2" x="1" version="1.0">
      <b></b>
    </root>

### Alternative 2: Local Disjunction

What is needed is to coordinate the different version-dependent portions of the schema file, so that, for example, the `x` attribute is only present when the `version` attribute has the value "1.0".

This can be done with a disjunction:

    root = element root {
      ((attribute version {"1.0"} & attribute x {string}) |
       (attribute version ("2.0") & attribute y (string)))
      ...
    }

This solution doesn't have any of the problems of the pointwise union.  It accepts all version 1 and all version 2 documents, and nothing else.

The problem with this solution is that it is unmaintainable as the grammar increases in complexity.  Consider a schema such as the following:

    start = element root {
      attribute version {"1.0"} &
      a*
    }
    a = element a {a* & b* & c*}
    b = element b {b* & c*}
    c = element c {a*}

Imagine that the only change, aside from the value of the `version` attribute, is the addition of an `x` attribute to `c`:

    c = element c {
      attribute x {string}? &
      a*
    }

If the document root has a `version` of "1.0", the `x` attribute is not permitted anywhere in the document.  If it has a `version` of "2.0", the `x` attribute is allowed on every `c` element, but nowhere else.

This is a very simple change, yet to implement it, an additional copy of each definition is required, in order to pass the information about which version of the schema is being used to the one definition (for `c`) that uses it:

    start = element root {
      (attribute version {"1.0"} & a1*) |
      (attribute version {"2.0"} & a2*)
    }
    a1 = element a {a1* & b1* & c1*}
    a2 = element a {a2* & b2* & c2*)
    b1 = element b {b1* & c1*}
    b2 = element b {b2* & c2*}
    c1 = element c {a1*}
    c2 = element c {a2* & attribute x {string}?}

The complexity is linear in the number of definitions.  It is also linear in the number of versions, so that a document that defines three versions of a schema whose version-specific definition defines 100 entities, will require up to 300 definitions.

### Alternative 3: Global Disjunction

RELAX NG also allows the two sets of definitions to be placed in separate files and incorporated into a single file by means of the `external` keyword.  For example, if `v1.rnc` and `v2.rnc` are the file names of the version 1 and version 2 schema definitions above, a schema that accepts either a version 1 or a version 2 file, but not both, is:

    start = external "v1.rnc" | external "v2.rnc"

(This solution is [due to Norm Walsh](http://norman.walsh.name/2004/07/25/xslt20).  I'll refer to it as the "Walsh disjunction".)

Maintaining both the `v1.rnc` and `v2.rnc` files has the same maintenance problems as the "local disjunction" solution above.  Two similar sets of sources must be maintained.  However, although it is cumbersome as a source-level solution for _writing_ the multi-version schema, we will use it as an _output format_, and _compile_  the multi-version schema to it.

#### The Modular Solution

The problem with the "global disjunction" is the maintenance of two sets of sources, one for each version.  How about factoring out the common portions of each version-specific specific schema into a set of files that each includes?  A modular version of the problem schema in the previous example is:

    start = element root {
      root.version &
      a*
    }
    root.version = attribute version {"1.0"}
    a = element a {a* & b* & c*}
    b = element b {b* & c*}
    c = element c {c.content}
    c.content = a*

(This schema has been modularized just to the extent necessary to support the version change.  That's why the definition of `c` uses `c.content`, but the definitions of `a` and `b` haven't been similarly updated.)

The updated schema, that accepts an `x` attribute within the `c` element when `version` is "2.0", can be written:

    include "base.rnc" {
      root.version = attribute version {"2.0"}
      c.content &= attribute x {string}?
    }

However, this modularization comes with a price.  Attempting to factor the v1 and v2 schemas yields something like this:

_common.rnc_

    root = element root {
      root.version &
      root.content
    }
    root.content = a?
    a = element a {empty}

_modularized-v1.rnc_

    include "common.rnc"
    root.version = attribute version {"1.0"}
    root.content &= attribute x {string}?

_modularized-v2.rnc_

    include "common.rnc"
    root.version = attribute version {"2.0"}
    root.content &= a*
    root.content &= element b {string}?

The content of the `root` element has been distributed to the point where it's difficult to read the content of either a version 1 or a version 2 document.  The greater abstraction and extensibility comes at the price of readability.

## Version-Annotated Schema

The solution we will use is to write a single file that defines both versions of the schema, but uses _annotations_ to mark the content that is specific to only one version.  We will use attributes from the `http://osteele.edu/namespace/versioning/1.0` namespace to annotate version-specific content.  We will use these annotations, and an XSLT stylesheet, to create version-specific schema files.  We can then use the Walsh union from the "global disjunction" alternative above to validate against the union of these version-specific files.

Here is a source file that combines the v1 and v2 schemas above:

_combined.rnc_

    namespace v = "http://osteele.edu/namespace/versioning/1.0"
    start = root
    root = element root {
      attribute version {
        [v:version="1.0"] "1.0" |
        [v:version="2.0"] "2.0"
      } &
      [v:version="1.0"]
      attribute x {string} &
      [v:version="2.0"]
      attribute y {string} &
      [v:version="1.0"] a? &
      [v:version="2.0"] (
        a* &
        element b {empty}
      )
    }
    a = element a {empty}

Note that, with the exception of the `v:version` annotations, this schema is almost exactly the same as the _local disjunction_ alternative from above.  It accepts any version 1 or version 2 document, but it also accepts hybrid documents that are neither valid version 1 nor version 2 documents.  Nonetheless, it is useful as it stands, as a human-readable description of the schema, and as an overly permissive approximation for documentation tools or schema-aware editors.

The `v:version` attribute annotates version-specific content.  `v:version="1.0"` marks content that is specific to version 1 of the schema.  Any RELAX NG element can be annotated: `element`, `attribute`, `value`, and `definition` (including partial definitions introduced by `|=` and `&=`).

The following stylesheet, when applied to the XML representation of this definition, produces the XML representations of either `v1.rnc` or `v2.rnc`, depending on the value of the `version` parameter.  For example, `xsltproc --param version 1.0 combined.rng v1.rng` creates a version 1 schema, and `xsltproc --param version 2.0 combined.rng v1.rng` creates a version 2 schema.

    <xsl:stylesheet xmlns:v="http://osteele.edu/namespace/versioning/1.0" exclude-result-prefixes="v" version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

      <xsl:param name="version"></xsl:param>

      <xsl:template name="copy" match="/|`*|node()">
        <xsl:copy>
          <xsl:apply-templates select="`*|node()"></xsl:apply-templates>
        </xsl:copy>
      </xsl:template>

      <xsl:template match="*[`v:version]">
        <xsl:if test="`v:version=$version">
          <xsl:call-template name="copy"></xsl:call-template>
        </xsl:if>
      </xsl:template>

      <xsl:template match="`v:*"></xsl:template>
    </xsl:stylesheet>

(The code can be trivially extended to allow additional annotations such as `v:since`, `v:until`, and `v:deprecated`.  With more work, it can be extended with annotations such as `v:count="1"` that manipulate the cardinality depending on the version.  This latter extension removes the cumbersome duplicate definition of the `a` element in the example.)

Applying this stylesheet to the combined schema above, with `version` set to `1.0`, creates the `v1.rnc` schema file.  Applying it with `version=2.0` creates the `v2.rnc` schema file (plus some extra parentheses that reflect the way the combined schema was written).

    > trang combined.rnc combined.rng
    > xsltproc --param version 1.0 combined.rng v1.rng
    > trang v1.rng v1.rnc

A Walsh union can be used to create a schema that validates against either of `v1.rnc` or `v2.rnc`, depending on the value of the `version` attribute.  In fact, one could use the Xalan, Saxon, or XSLT 2.0 output redirection extensions to write a stylesheet that created all the versions of a schema (by iterating over the values of `//@v:version`), and whose main output was a Walsh union that included them all.

If the `version` attribute is marked as optional in the schema definition, this same technique can be used to implement optional versioning.  If the attribute is missing altogether, it can be used to implement implicit versioning.

## References

Dare Obasanjo, [On Versioning XML Vocabularies](http://www.xml.com/pub/a/2004/07/21/design.html)

David Orchard, [Providing Compatible Schema Evolution](http://www.pacificspirit.com/Authoring/Compatibility/ProvidingCompatibleSchemaEvolution.html)

Norm Walsh, [Validating XSLT 2.0](http://norman.walsh.name/2004/07/25/xslt20)
