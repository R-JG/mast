# %mast

Mast is a front-end model inspired by HTMX. It is also quite different from it. Mast takes the idea of applying minimal updates to the DOM with content rendered on the server, but instead of the developer writing swap logic, a diffing algorithm automatically creates the update and pushes it through an Eyre SSE channel to the Mast script on the browser which then executes the swaps. In addition to this, Mast's event attributes let you specify event listeners on elements such that the triggered events are poked into handlers in your ship, meaning that all of your client-side interface logic can be implemented in Hoon, within Urbit.

In this updated version, Mast can be used to serve to the clearweb with it's built in session system.

---

## Setup

All that is needed to use Mast is /lib/mast/hoon and /lib/mast/js.

## Usage

For an example of how mast is used check out this chess ui-agent: https://github.com/R-JG/chess/blob/mast-agent/src/backend/chess/app/chess-ui.hoon

### In your agent

Mast is an agent wrapper. To use mast, at the top of your agent's file below the type core include a `=+  (pin:mast your-session-state-type)` followed by `%-  agent:mast`. The argument for `pin:mast` is a mold of any client state that you might want saved on a session by session basis. This state will be accessible from `storage:mast` which is a `(map ship your-session-state-type)`. `storage:mast` is meant for UI related state, e.g. for conditional rendering; it will not persist through save-load cycles.

(Side note: the mast agent wrapper now takes care of saving ui state, so you no longer need to track this in your agent.)

#### ++ on-poke

Mast uses a combination of direct http and the channel system. Pokes will be received under two marks: `%handle-http-request` for when the app is first accessed from the client, and `%mast-event` for any subsequent client event pokes that the Mast script will send.

##### %handle-http-request

In response to a `%handle-http-request` `%GET` poke, you will use `gale:mast` to send a full page to the client. Using this arm, mast will insert its script and establish an Eyre channel connection to receive diff updates. `gale:mast` is used with a `=^` to pin new cards and change `rig.mast`.

##### %mast-event

Events from the client are handled under the `%mast-event` mark. The `vase` will be of the type `event:mast` which is `[=path data=(map @t @t)]`. 

The `path` is what you will have defined in the `event` attribute on the Sail element which triggered the event poke, and `data` contains any of the paths defined in the `return` attribute mapped to the value of the object's property in the DOM, or the name of an input from a submit event mapped to its value. Refer to the Sail attribute section below for more details.

You can `?+` over the `path` to define your event handlers.

#### Display updates with `gust`

Display updates are made with `gust:mast`. This arm creates a diff from your newly rendered Sail to sync the client with the latest state of your UI. `gust:mast` is also used with a `=^` to pin new cards and change `rig.mast`.

Typically, you would use these arms after updating some part of your app's state which is involved in your Sail components.

This can be done asynchronously from mast events and sent from any part of your agent where you would produce a subscription card to update the client.

### In your Sail

Mast uses three main attributes: `event`, `return`, `key`, along with `debounce`, `throttle`, `js-on-event`, `js-on-add`, and `js-on-delete`.

#### The event attribute

The `event` attribute lets you specify event listeners on elements. In Mast, all that an event listener on the client does is poke your agent, leaving the entirety of the event handling to be done in your ship which is where your app's display state lives.

Event attributes are formatted as a path where the first segment is the name of the event listener minus the "on" prefix, followed by any number of segments which, along with the first segment, identify the event handler in the agent (see the `%mast-event` mark section).

For example:

```hoon
;div(event "/click/example-event");
```

> Note: in your Sail, the path needs to be written as a tape, as is the case with all attribute values in Sail.

> Note: you can specify multiple event listeners on a single element by writing multiple paths separated by whitespace.

#### The return attribute

The `return` attribute lets you to specify what data to return from the event. 

A number of paths may be specified, separated by whitespace. The first segment of the path refers to the object on the client to return data from. There are three options:

1) `"/target/..."` for the current target, i.e. the element on which the event was triggered,
2) `"/event/..."` for the event object,
3) `"/your-element-id/..."` for any other element by id.

The second segment of the path is the property to return from the object. For example: `"/target/value"` or `"/my-element/textContent"` or `"/event/clientX"`.

> Note: the property name is exactly the same as what you would access on the object in JavaScript, so you will need to use camel case in some situations.

#### The key attribute

The `key` attribute is not necessary to use, but it is best practice when you have a list of elements that will change, for example: when you are dynamically generating elements with `turn`.

A `key` is a globally unique value which identifies the element (two distinct elements in your Sail should never have the same key). Mast adds location based keys to your elements by default, but when you provide information about the identity of the element by specifying the `key`, it allows Mast to make more efficient display updates.

#### Other attributes

The attributes `debounce` and `throttle` let you add debouncing and throttling to your events when added on an element with an `event` attribute. These attributes take a number for their duration in seconds.

The `js-on-event`, `js-on-add`, and `js-on-delete` events allow you to run arbitrary JavaScript when placed on an element that either has an `event` triggered on it, when the element is added to the DOM through a diff, or deleted through a diff.

#### Implementing forms

There are two ways to implement forms in Mast. You can use both the typical `<form>` element API, or Mast's `event` and `return` attributes. To use a form element, add a "/submit/..." `event` attribute. The value of each input will be included in the data attribute of the `mast-event` poke, with the input's `name` attribute as the key.

---
