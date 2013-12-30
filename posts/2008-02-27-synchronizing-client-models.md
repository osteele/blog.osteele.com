---
description: A certain race condition from when client-server model sync was a fresh problem.
date: '2008-02-27 14:53:12'
layout: post
slug: synchronizing-client-models
status: publish
title: Synchronizing Client Models
wordpress_id: '265'
categories: [Essays, JavaScript]
tags: [JavaScript, client-server, essays]
---

You're implementing a client-server application.  The client is in JavaScript.  It contains a model class, `Person`.  The model is backed by a server-side `Person` model, and a REST controller at `/person`.  Periodically, the client updates the server's model, but there can be client-side instances that don't yet exist on the server, such as when a model is first created and the server hasn't yet gotten the message.

<!-- more -->

I've written this code a few times now, in JavaScript, and in ActionScript.  if If you write it the obvious way, you run into an interesting set of race conditions.  Here's the code, and the race conditions, and some ad-hoc solutions.  In the next post, I'll introduce a metaobject pattern, queue ball, that I've used to solve these race conditions in a more principled and re-usable fashion.

+Note: As of 2008-02-28, none of this code has been tested.  It's all extracted from code that's *like* the code here, but I haven't copied and pasted these specific examples into an execution environment, which probably means they fail.+

## Getting `Person`al

Here's the model, with some server proxy mojo mixed in:[^1]

    // creates a client-only instance
    function Person(attributes) {
      this.attributes = attributes||{};
      // if a server mirror exists, this.id is set to its id
    }

    // creates a client instance that is mirrored by a new server instance
    Person.create = function(attributes) {
      var person = new Person(attributes);
      person.create();
      return person;
    }

    Person.prototype = {
      // creates a server instance for this client instance
      create: function() {
        jQuery.post('/person/create', this.attributes, function(data) {
          this.id = data.id;
        }.bind(this));
      },

      //  updates attributes of this instance, and, if it exists, its server mirror
      update: function(attributes) {
        Hash.merge(this.attributes, attributes);
        this.id && jQuery.post('/person/update/' + this.id, attributes);
      },

      // deletes this instance's server mirror
      remove: function() {
        this.id && jQuery.post('/person/delete', {id:this.id});
        delete this.id;
      }
    }


This implementation uses [jQuery](http://jquery.com/) for transport, and assumes a `Hash.merge` method from some collection library (say, Prototype's).  It creates a class by setting `prototype` directly, and it doesn't detect or recover from XHR errors.  All these choices are just to have something concrete to write about; they don't affect the substance of this article.

## A Day at the Races

Do you see the race conditions?  There's at least three: `create+update`, `create+delete`, and `update+update`.

### Race Condition 1: Create then Update

    function createThenUpdate() {
      var aPerson = Person.create();
      aPerson.update({name:'Edgar Dijkstra'});
    }


The problem with `createThenUpdate` is that `aPerson` won't have an `id` by the time `update` is called, so `update` won't send the new values to the server.  The call to `create` is synchronous, but the communication with the server, and therefore the call to the callback (that sets `aPerson.id`) is _a_synchronous, and therefore won't occur until `Person.create` returns.

In detail:

# `createUpdate` calls `Person.create`
# `Person.create` calls `new Person`
# `aPerson.create` calls `jQuery.post`
# `jQuery.post` calls `XMLHttpRequest.send` (not shown)
# `XMLHTTPRequest.send`, `jQuery.post`, and `aPerson.create` _return_
# `createUpdate` calls `aPerson.update`
# _[time passes]_
# Client sends HTTP Request to server
# _[more time passes]_
# Client receives HTTP Response
# Callback in `aPerson.create` sets `aPerson.id`

### Solution 1: Explicit Callbacks

One solution to this problem is to thread the code through callbacks (in effect, [performing CPS conversion by hand](http://en.wikipedia.org/wiki/Continuation-passing_style#Use_and_implementation)).  `aPerson.create` calls a callback function once _it's internal callback function_ is called, so `Person.create` takes a callback parameter too, and so on up the call chain.  (In this case, the buck stops here.)

Let's add a callback parameter to `Person.create`, that is called once the HTTP response to `/person/create` is received.

    Person.create = function(attributes, callback) {
      var person = new Person(attributes);
      person.create(callback);
      return person;
    }

    Person.prototype = {
      // creates a server instance for this client instance
      create: function(callback) {
        jQuery.post('/person/create', this.attributes, function(data) {
          this.id = data.id;
          callback && callback();
        }.bind(this));
      }
    }

Then we can rewrite `createThenUpdate` thus:

    function createThenUpdate() {
      var aPerson = Person.create({}, function() {
        aPerson.update({name:'Edgar Dijkstra'});
      });
    }

### Adding the UI

It was easy to spot the race condition in `createThenUpdate` -- and easy to fix it -- because the calls to `create` and the `update` were in consecutive statements, within the same function.  In the real world, they're at the bottom of different call chains, as in this jQuery code that binds some model actions to an HTML view:[^2]

    $('#person create-button').click(function() {
      $(this).disable(); // avoid double-creation
      $('#person update-button').enable();
      gCurrentModel.create();
    });
    $('#person update-button').click(function() {
      gCurrentModel.update($('#person').serialize());
    });

Click "create", edit a field, and then click "update".  Sometimes the update will hit the server, sometimes it won't: it depends on whether the response to the `/person/create` request has returned by the time you click the second button.  We've just created an AJAX version of the [500-mile bug](http://www.ibiblio.org/harris/500milemail.html).

Let's thread the callbacks through this code, in order to avoid enabling the "update" button until the callback is called:

    $('#person create-button').click(function() {
      $(this).disable(); // avoid double-creation
      gCurrentModel.create({}, function() { $('#person update-button').enable() });
    });
    $('#person update-button').click(/* unchanged */);

This is awful!  First, it requires you to weave callbacks through both your view and your model code.[^3]  But worse, it's a _leaky abstraction_.  The view layer has to know about an arbitrary (from the outside) limitation -- that you can't _call_ `update` until `create` has _called its callback_ -- of the model layer.

### Solution 2: Implicit Callbacks

Another solution is to use a library such as [Narrative JavaScript](http://www.neilmix.com/narrativejs) or [JavaScript Strands](http://www.xucia.com/strands-doc/index.html), that does the CPS conversion (adds the callbacks) _for you_.  I like this approach a lot, but I do a lot of work in contexts where those compilers aren't applicable[^4], and many folks (often including, for these reasons and others, me) prefer to work in pure JavaScript. I therefore won't go further down that path here.

### Solution 3: Action Queue

Finally, we can add a queue to the model.  With the modification below, calling `update` while the model is waiting for an id no longer drops server updates; it simply queues them for playback once the response to `/person/create` is received.

    Person.prototype = {
      _updateQueue: null,

      create: function() {
        this._updateQueue = [];
        jQuery.post('/person/create', this.attributes, function(data) {
          this.id = data.id;
          while (this._updateQueue.length)
            this._sendUpdate(this._updateQueue.shift());
          delete this._updateQueue;
        }.bind(this));
      },

      // the caller must treat `attributes` as deep-frozen once
      // this method has been called
      update: function(attributes) {
        Hash.update(this.attributes, attributes);
        if (this.id)
          this._sendUpdate(attributes)
        else if (this._updateQueue)
          this._updateQueue.push(attributes);
      },

      _sendUpdate: function(attributes) {
        jQuery.post('/person/update/' + this.id, attributes);
      }
    }

We can use a "method algebra" to optimize this a bit:  It doesn't matter how many times `update` is _called_ while waiting for the `create` response -- it only needs to _send_ an update _once_.  (The algebra is that there's an operation `+: update` × `update` -> `update` that can combine consecutive updates `update`1 + `update`2 = `update`3.)

    Person.prototype = {
      _pendingUpdates: null,

      create: function() {
        this._pendingUpdates = {};
        jQuery.post('/person/create', this.attributes, function(data) {
          this.id = data.id;
          if (this._pendingUpdates) {
            this._sendUpdate(this. _pendingUpdates);
            delete this. _pendingUpdates;
          }
        }.bind(this));
      },

      update: function(attributes) {
        Hash.update(this.attributes, attributes);
        if (this.id)
          this._sendUpdate(attributes)
        else if (this._pendingUpdates)
          Hash.merge(this._pendingUpdates, attributes);
      },

      _sendUpdate: function(attributes) {
        jQuery.post('/person/update/' + this.id, attributes);
      }
    }

I'm going to back off from this optimization, though.  The reason is that it only works if the two calls to `update` are _consecutive_ -- when there are no intervening calls that also send messages that operate on the same instance.  With a more full-featured API (with more actions that send messages to the server), this won't generally be true.

For example, let's extend `Person` with a `setPermissions` method.  If we could ignore race conditions, this method might look like this:

    Person.prototype = {
      _pendingUpdates: null,

      setPermissions: function(permissions) {
        this.permissions = permissions;
        this.id && jQuery.post('/person/set_permissions', {id:this.id, permissions:permissions});
      }
    }

This naive implementation is vulnerable to a `create+setPermissions` race condition analogous to the `create+update` race condition that we just fixed, though.  We can fix them both by generalizing the post-create queue, so that it can contain arbitrary actions, not just update records:

    Person.prototype = {
      _pendingActions: null,

      create: function() {
        this._pendingActions = {};
        jQuery.post('/person/create', this.attributes, function(data) {
          this.id = data.id;
          while (this._pendingActions.length) {
            var action = this._pendingActions.shift();
            this[action.methodName].apply(this, action.arguments);
          }
          delete this._pendingActions;
        }.bind(this));
      },

      update: function(attributes) {
        Hash.update(this.attributes, attributes);
        if (this.id)
          this._sendUpdate(attributes);
        else if (this._pendingActions)
          this.pendingUpdates.push({methodName:'_sendUpdate', arguments:[attributes]);
      },

      _sendUpdate: function(attributes) {
        jQuery.post('/person/update/' + this.id, attributes);
      },

      setPermissions: function(permissions) {
        this.permissions = permissions;
        if (this.id)
          this._sendSetPermissions(permissions);
        else if (this._pendingActions)
          this.pendingUpdates.push({methodName:'_sendSetPermissions', arguments:[permissions]);
      },

      _sendSetPermissions: function(permissions) {
        jQuery.post('/person/set_permissions', {id:this.id, permissions:permissions});
      }
    }

### Race Condition 2: Create then Delete

    function createThenDelete() {
      var aPerson = Person.create();
      aPerson.delete();
    }

By now, you should be able to spot the problem here.  The reasoning is exactly the same as for `update`: when `delete` is called, `aPerson` won't yet have an id.

We could fix this with a callback:

    function createThenDelete() {
      var aPerson = Person.create({}, function() {
        aPerson.delete();
      });
    }

This has the attendant disadvantages of having to bake knowledge about the client-server protocol into `Person`'s clients, and having to thread callbacks through the UI.  After all, it's rare that we would create a `Person` simply to delete it; the more common case is that the creation and deletion would be at the bottom of different call chains -- often initiated from outside the application, in response to user actions -- such that it's difficult to thread the first as a callback of the second.  And note that, as with `create+update`, we can't simply ignore the `delete` unless the server creation has responded: if we do this, we'll occasionally drop a `delete` on the floor, because it was called _after_ the `create` was _sent_, but _before_ the _response_.

The best local solution is to build on the _action queue_ solution above -- by simply adding another method to the queue.

    Person.prototype = {
      delete: function() {
        if (this._pendingActions)
          this.pendingUpdates.push({methodName:'_sendDelete');
        else
          delete this.id;
      },

      _sendDelete: function() {
        jQuery.post('/person/delete', {id:this.id});
        delete this.id;
      }
    }

This _works_, but it should make you uncomfortable.  We're adding (almost) _the same conditional_ to _every single method_.

### Race Condition 3: Overlapping Updates

    function updateThenUpdate(aPerson) {
      aPerson.update({name:'Edgar Djikstra'});
      aPerson.update({name:'Edgar Dijkstra'});
    }

From looking at `updateThenUpdate`, it looks like the first call to `update` will occur _before_ the second.  And it does! (Duh.)  And it looks like the misspelled name in the first call will be replaced by the correct name in the second call.  And it will!  (Well...on the client...read on.)  Because: the first call to `XMLHttpRequest.send` (with the misspelled name) occurs before the second call to `XMLHttpRequest.send` (with the correction), and the client therefore sends the message with the misspelled name before it sends the message with the correction.  But our run of good luck stops here.  There is, unfortunately no guarantee about the order in which the _server_ will _receive_ these messages.  Generally, the first message will be received before the second.  Sometimes, they will arrive in the other order, and the misspelling will overwrite the correction.

There are two ways to fix this problem: by **sequencing messages**, or by **holding outgoing messages** (holding each outgoing message until the previous one returns).  Sequencing messages is the higher-performance solution (it doesn't hold up messages), but requires more work and involves switching both the client and the server from a straight REST API, which may not be possible[^5].

For simplicity, we'll look at the second solution: holding outgoing messages.  This solution has the advantage that the general-purpose solution to the other race conditions (presented in the next article) happens to implement it too.  (In this article, we'll implement with an explicit `Serialized` object instead.)  Message sequencing doesn't help with those other cases at all: the problem with them is that the second message is never sent, not that it's sent out of order.

Here's a quick-and-dirty implementation of the _hold outgoing messages_ solution.  The following code defines `Serialized.post` as a drop-in replacement for `jQuery.post`, that refuses to post data until the previous post has completed (successfully, or with an error).[^6]

    var Serialized = {
      queue: [], // arguments for pending
      defer: false,
      post: function(url, data, callback, type) {
        if (this.defer) {
          this.queue.push(Array.prototype.slice.call(arguments, 0));
          return;
        }
        this.defer = true;
        jQuery.ajax({url:url, type:'POST', data:data, success:success, complete:complete.bind(this)});
        function complete() {
          if (this.queue.length)
            this.post.apply(this, this.queue.shift();
          this.defer = false;
        }
      }
    }

## Next Up: Queue Ball

I'd like to factor all those conditionals out of the `Person` methods.  Then I'd like to extract the queue code from `create`, so that I can use it on `update` (to solve the `update+update` problem).  Finally, there are some general-purpose techniques here, so I'd like to extract the whole mess from `Person`, where I can apply it to any model (or to code that has some of the same concerns, even if it's not synchronized model code).  But this post is already long enough, so I'll just close with the promise to write that up, so that I have to do it.

---

[^1]: Would you rather have code with a cleaner separation of concerns?  Here it is.  You'll find that it doesn't make the race conditions go away, but that it doesn't change the set of techniques for solving them.  (It does make the "explicit callbacks" solution _even worse_.)  I've therefore stuck with the double-duty `Person` implementation in the body of this article, to make the code easier to follow.

    function Person(attributes) {
      this.attributes = attributes || {};
      this.proxy = null;
    }

    Person.prototype = {
      create: function() {
        this.proxy = new PersonProxy();
        this.proxy.create(this.attributes);
      },

      update: function(attributes) {
        Hash.merge(this.attributes, attributes);
        this.proxy && this.proxy.update(attributes);
      },

      remove: function() {
        this.proxy.remove();
        delete this.proxy;
      }
    }

    function PersonProxy() {
      this.id = null;
    }

    PersonProxy.prototype = {
      create: function(attributes) {
        jQuery.post('/person/create', attributes, function() { this.id = id }.bind(this));
      },

      update: function(attributes) {
        this.id && jQuery.post('/person/update/' + this.id, this.attributes);
      },

      remove: function() {
        this.id && jQuery.post('/person/delete', {id:this.id});
        delete this.id;
      }
    }

[^2]: This implementation somewhat mixes the model with the view.  It's not the clearest code.  It would be cleaner if it used listeners and reactive programming techniques -- but the fact that it's so explicit makes it easier to follow what's going on.

[^3]: I've used this approach, and it wipes the floor with using listeners or delegates or other unthreaded callbacks, where you have to store state in objects in order to match listeners with their context, but it's still a pain to maintain.

[^4]: CPS conversion introduces a lot of function allocations and invocations.  I've been scared to try a system that introduces them globally, instead of letting me judiciously thread a few callbacks in by hand, when developing for a slow ECMAScript implementation such as Flash < 9 or MSIE.  (I even use [my own libraries](/sources/javascript) sparingly in such a situation.)

[^5]: XMPP preserves message order, by sending all the messages over a single stream.  One could also add a sequence number to each message.  The receiver (in this case, the server) should buffer messages that arrive out of order, so that it can process them in the order in which they occur.  This is how a streaming protocol such as TCP is implemented: by adding sequence numbers and buffering on top of an unordered protocol such as IP.  HTTP is implemented on top of TCP, but only uses TCP to preserve the order of packets within a message, so multiple HTTP requests (and responses) can get out of order again.  It seems that keepalive might fix the problem, and that load balancers might re-introduce it, and that affinity might fix it again, but only if you can guarantee that your load balancer is properly configured.  But I'm getting out of my depth here.

[^6]: This code assumes that a request will never take longer than the client timeout setting to reach the server.  Otherwise, `complete` could be called before the server receives the first message, the client would send the next message, and the server would process them out of order.  That's one reason I called this implementation quick-and-dirty.
