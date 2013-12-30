---
description: Defining XML-based view components in OpenLaszlo
date: '2004-03-28 15:13:33'
layout: post
slug: classes-and-prototypes
status: publish
title: Instance-First Development
wordpress_id: '76'
categories: [OpenLaszlo, Programming, Software Development]
tags: [Laszlo, programming-languages, software-engineering]
---

[LZX](http://www.laszlosystems.com/developer/) is a [prototype-based language](http://en.wikipedia.org/wiki/Prototype-based_programming): any attribute that can be attached to a class definition, can be attached to an instance of that class instead.  This is handy in UI programming, where there are a number of objects with one-off behaviors.  It's also handy in prototyping and incremental program development, where it creates the possibility for a novel kind of refactoring.

The following two XML documents are complete LZX applications.  Each defines a view named `myview`, that contains a method named `f`.  Evaluating `myview.f()` in either application will result in `100`.

    <canvas>
      <view id="myview">
        <method name="f">return 100;</method>
      </view>
    </canvas>

    <canvas>
      <class name="myclass">
        <method name="f">return 100</method>
      </class>
      <myclass id="myview"></myclass>
    </canvas>

## Instance-First Development

The equivalence between the two programs above supports a development strategy I call **instance-first development**.  In instance-first development, one implements functionality for a single instance, and then refactors the instance into a class that supports multiple instances.

One instance-first development technique is to use global variables.  It's often easier to develop and debug a program that stores state in global variables, than to attach variables to a state, session, or user object.  This avoids threading the state object through all the API calls, and it makes it easier to find and manipulate the state during interactive debugging.  Eventually one refactors the globals into members of a state object, but this refactoring is relatively easy, especially if the program has been written with the knowledge that this would eventually happen, and is cheaper than maintaining the state threading and writing the extra access during all the other refactoring of the program (as extra parameter to each method that is added or refactored).  This is a special case of the principle that if one is going to refactor a program anyway, you can optimize the order in which the refactorings are applied, and where within the development pipeline they occur.

In the global variable approach to instance-first development, the entire program is an instance.  Prototype-based programming supports another approach, that doesn't rely on global variables.  With prototype-based programming, the developer can add functionality to and interact with a single instance of an object, refactoring its members and functionality into a class when another instance with the same or similarfunctionality is called for.   This avoids a pitfall of programming, *premature abstraction*, where behavior is generalized too early and has to be rewritten at the framework level, where it's difficult to reason and expensive to debug, rather than at the level of the specific instance.  _It's easier to generalize from two examples than from one._

In a language without prototypes, one can apply this strategy for instance-driven development by implementing singleton classes.  Prototypes simply cut out the middleman, reducing the line count, the abstraction, and the indirection that is necessary during development.  This is particularly useful during user interface programming, where there may be a number of one-off visual objects.  Using a singleton class for each of these can increase the size of a program (and therefore the development time) substantially, but one wants the freedom to rapidly refactor any these into classes.  Prototypes in a language that also supports classes lets you seamlessly move between these representations.

Instance-first development is similar to test-driven development, but is orthogonal to it. (Instance-first development can be used independently from test-driven development, or to complement it.)  In test-driven development, one incrementally adds test-specific functionality to encompass a growing test suite.  In insance-first development, one adds instance-specific functionality to an instance and then generalizes from it.  Both are cases of implementing specific cases first and then generalizing from them.

## The Instance Substitution Principal

During the design of LZX, classes first showed up as user-defined XML tags.  We added functionality to them until they were equivalent to class definitions in non-XML languages.  However, LZX already supported methods and attributes (aka field or property) on instances definitions, so class definitions looked like instance definitions.

In defining the semantics of LZX class definitions, I found the following principle useful:

> **Instance substitution principal**: An instance of a class can be replaced by the definition of the instance, without changing the program semantics.

The two programs at the beginning of this entry illustrate the instance substitution principle.

The instance substitution principle can be applied at the level of semantics, or at the level of syntax.  At the level of semantics, it means that a member can equivalently be attached either to a class or its instance.  At the level of syntax, it means that the means of defining a class member and an instance member are syntactically parallel.

Many prototype-based languages don't obey the instance substitution principle, either because they don't have classes, or because class and instance definitions are not parallel.  (Typically there's not a declarative means for defining an instance member.)  JavaScript versions 1.0 through 1.5 (the versions in browsers) is also a prototype-based language, but lacks classes as a first-class syntactic entity, and lacks the hierarchical syntax that Java, C++, and LZX use to define class members.  JavaScript 2.0, JScript.NET, and Python have a class definition syntax, but don't use the same syntax to define instance members.  For example, contrast the following two Python programs, which parallel the LZX programs above.

    myobject = object()
    myobject.f = lambda f: 100

    class MyClass(object):
      def f():
        return 100
    myobject = MyClass()

The syntactic version of the instance substitution principle makes a class look like a function or a macro.  Class, function, and macro definitions are all mechanisms for abstracting program structure so that it can be reused.  (In a pure lazy language such as Haskell, a variable is a similar abstraction, in that it looks like a nonary function.)  Some languages hide this, because they're missing mechanisms to the specific or general case, variously.  (These are the programming-language equivalents to _defective paradigms_ in natural-language grammar.)  For example, the instance substitution principle only makes sense in a language with both prototypes and classes; the derivation of a function definition from a sequence of statements is muddier in a language such as C++ or Java that is missing anonymous functions to represent the intermediate step.

## More on LZX

[Laszlo Explorer](http://www.laszlosystems.com/lps/laszlo-in-ten-minutes/) has more compelling examples of the _LZX class definition_ aka _user-defined tag definition_ mechanism.  Look under "Object Orientation."
