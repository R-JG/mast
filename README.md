# `Mast`

A library for building fully dynamic Sail front-ends

*full-stack Urbit* — *zero JavaScript required* 

## Overview

- Using Mast, an app stores its current display state on an agent, and when the display state changes, updates to the browser containing only the necessary amount of html to achieve this state are sent and swapped in.

- A small script that is generic to any application is inserted into your Sail and used to establish an Eyre channel, receive display updates from your ship, and sync the browser with them.

- In your Sail components, you may add event attributes on elements specifying event listeners with paths corresponding to an event handler in your agent; the script will add these event listeners and poke your agent when the event is triggered. A return attribute may also be used to specify any data from the event object, the target element, or any other element associated by id to return to the ship for the event handler to process.

- Display updates do not need to be in response to an event from the client, though. Your ship can stream updates to the browser as an effect of any state change in the agent.

---

## Setup

All that is needed to use Mast is the /lib/mast.hoon file.

## Usage

> Note: check out the lib file and the example app for more detailed information.

### In your agent 🤖

First, you will need to define your app's routes as `(list [path gate])` where the gates are your root-level Sail components, i.e. gates which produce a complete document with html, head, and body tags.

> Note: you will also need to bind the base url, e.g. /example-app, with arvo in order to access your app from the client.

#### ++ on-poke

Mast uses a combination of direct http and the channel system. Pokes will be received under two marks: `%handle-http-request` for when the app is first accessed from the client, and `%json` for any subsequent client event pokes that the Mast script will send.

##### %handle-http-request

For `%handle-http-request`, the main arms that you will use are `rig` and `plank`.

The `rig` arm is used to produce a new instance of the display state, to then be used with `plank` and saved as the current display state in the agent.

The `plank` arm is used to serve any of the pages in your routes list according to the request url. It produces a list of cards with the http response.

##### %json

Events from the client are handled in on-poke under the %json mark.

The json data can be parsed with the `parse-json` arm in Mast into `[tags=path data=(map @t @t)]`.

> `tags` is the path that you had defined in the `event` attribute on the Sail element which triggered the event poke, and `data` contains any of the paths defined in the `return` attribute mapped to the value of the object's property in the DOM — refer to the Sail attribute section below.

You can then `?+` over `tags` to define your event handlers.

#### Display updates with `gust`

Display updates are made by using `rig` to produce a new instance of the display, which is then used with `gust` to produce a card to sync the client with the new display state.

Typically, you would use these arms after updating some part of your app's state which is involved in your Sail components.

This can be done in any part of your agent where you would produce a subscription update card (not only in on-poke) to send a display update to the client.

### In your Sail ⛵

There are three special element attributes that Mast uses: `event`, `return`, and `key`.

#### The event attribute

The `event` attribute lets you specify event listeners on elements. Its format is a path where the first segment is the name of the event listener minus the "on" prefix, followed by any number of segments which, along with the first segment, identify the event handler in the agent (see the %json mark section).

For example:

```hoon
;div(event "/click/example-event");
```

> Note: in your Sail, the path needs to be written as a tape, as is the case with all attribute values in Sail.

> Note: you can specify multiple event listeners on a single element by writing multiple paths separated by whitespace.

#### The return attribute

The `return` attribute lets you to specify what data to return from the event. A number of paths may be specified, separated by whitespace. There are three options for the beginning of the path:
1) `"/target/..."` for the current target, i.e. the element on which the event was triggered,
2) `"/event/..."` for the event object,
3) `"/your-element-id/..."` for any other element by id.

The second segment of the path is the property to return from the object. For example: `"/target/value"` or `"/my-element/textContent"` or `"/event/clientX"`.

> Note: the property name is exactly the same as what you would access on the object in JavaScript, so you will need to use camel case in some situations.

#### The key attribute

The `key` attribute is not necessary to use, but it is best practice when you have a list of elements that will change, e.g. when you are dynamically generating elements with `turn`.

A `key` is a globally unique value which identifies the element (two distinct elements in your Sail shouldn't ever have the same key). Mast adds location based keys to your elements by default, but when you provide information about the identity of the element by specifying the `key`, it allows Mast to make more efficient display updates.

### Tips and tricks 💡

#### Handling CSS

You should serve any CSS for your front-end in `%handle-http-request`, separate from your Sail components. Adding large amounts of CSS to your Sail will slow your app down. See the example agent for an example of how to serve CSS from the agent.

#### Implementing forms

The way that forms are implemented in Mast is *not* through the traditional `<form>` element api. Instead, forms are implemented simply with Mast's `event` and `return` attributes.

The general pattern would be to have one element with an event attribute, and a return attribute which links all form inputs by id. For example:

```hoon
;div
  ;input#first-input;
  ;input#second-input;
  ;button
    =event  "/click/submit-example-form"
    =return  "/first-input/value /second-input/value"
    ;+  ;/  "Submit"
  ==
==
```

> It is best not to use the semantic HTML associated with forms, nor the submit event.

The input values can then be accessed from the parsed json data in your event handler.

As a side note, one strategy for making the inputs on the client reset their values after submitting the form is to save some value in state, like a boolean, that you change in the form event handler. If you then concatenate this value with some other identifier in the key attribute of the input elements, the inputs will be reset upon a display update with gust.  

#### Dynamic route segments

In your list of routes, you can make a segment variable by using a buc: `/$`. When you do this, `rig` will always match with that segment. This means that you can define routes in your list such as: `/example/items/$` and if a url matches the first two segments and has one more segment of any value, it will match and select the route. In `%handle-http-request` you can check for the value of this segment and apply the relevant state updates before rendering the display and sending it with `plank`.

Another use case is that a custom 404 page can be supplied by adding a catch-all route with `$` to the end of your route list (in the absence of this `rig` will send a default 404 page).

#### Navigation

Using `rig` and `gust`, you can navigate to a different route by sending a minimal set of updates instead of a whole page. This is done simply whenever you use `rig` with a different url relative to whatever is current.

#### Dynamic event handlers

An interesting issue can arise when you want to specify events on dynamically generated elements, because the corresponding handler in the agent is itself statically defined. Here are some ways to make your event handlers work with dynamic event listeners:

- When handling event pokes from the client, if you switch over only select segments of the path, it is possible to have the other parts of the path be variable, which you can then use in your event handler to e.g. identify which element triggered the event when handling events for dynamically generated components.

- An alternative to this is to encode certain information about the element in one of the attributes, and then use the return attribute to send that information back to the handler in the agent.

---

### Known issues, bugs, and limitations ⛭

- Currently, Mast cannot be used to serve content to the clearweb.
- Events which fire at a high frequency will not work well, e.g. mousemove or scroll. This will be partially addressed with debounce and throttle options.
- There is a bug with table related semantic HTML elements where display updates for these elements won't work in certain cases. This can be avoided by just using divs and styling them in the manner of a table.
- If a key attribute begins or ends with double quotes (actual quote characters in the beginning or end of the attribute tape, not the double quote syntax which defines a tape) the key will not work.
- If an element has a child list that is over 1000, there will be problems.

If you find any other issues, let me know!