# %mast, shrubbery edition:

### A framework for building reactive Web clients as shrubs, purely in hoon.

---

### Introduction

To understand the %mast front-end model, imagine the client as a shrub within your ship, instead of an application on the browser. A mast shrub is the source of truth for the state of your front-end, and it should contain all client-side logic to transition this state. Your mast shrub will act as an interface that renders the state of some other shrub.

Mast shrubs are spawned and managed by %mast (which is itself a shrub). %mast will handle everything related to connecting with and updating the browser. Your shrub needs to do only two things: have `manx` state, and take `ui-event` pokes. Your shrub will also have a `%src` dependency, which provides your back-end data.

Whenever you change the `manx` state of your shrub, %mast will automatically sync the browser with this state. All display updates happen like this; you never need to explicitly poke anything to %mast or interact with the browser.

%mast will poke your shrub with a `ui-event`, which represents an event that happens on the browser, such as a click or a form submit. A ui-event is of the type `[=path data=(map @t @t)]`. The path is an identifier for the event that you will have written in an attribute in your Sail. When handling a ui-event poke, you can switch over this path to implement your event handler logic. The data map contains any data that you might return from the browser with the event.

In addition to %mast attributes, there is also a %mast component element. This element lets you plug the interface of one shrub into the interface of another shrub.

---

### In your Sail

%mast uses three main attributes: `event`, `return`, and `key`, along with `debounce`, `throttle`, `js-on-event`, `js-on-add`, and `js-on-delete`.

#### The event attribute

The `event` attribute lets you add event listeners to elements. The value of the `event` attribute is a path where the first segment is the name of an event listener (minus the "on" prefix), followed by any number of segments. %mast will add the specified event listener to the element, and when the event is triggered your shrub will receive a `ui-event` poke.

An element with an event attribute looks like this:

```hoon
;div(event "/click/example-event");
```

- Note: you can add multiple event listeners on a single element by writing multiple paths separated by whitespace.

#### The return attribute

The `return` attribute lets you to specify data to return from the event. This data will be contained in the data map of the `ui-event` poke. Using this attribute requires some knowledge of the DOM API. If you only need form data instead of general purpose data on an event, you can use the form API instead (see the section on implementing forms below).

The value of the `return` attribute is also written as a path. A number of paths may be written, separated by whitespace. The first segment of the path refers to the object on the client to return data from. There are three options:

1) `"/target/..."` for the current target, i.e. the element on which the event was triggered,
2) `"/event/..."` for the event object,
3) `"/your-element-id/..."` for any other element by id.

The second segment of the path is the property to return from the object. For example: `"/target/value"` or `"/my-element/textContent"` or `"/event/clientX"`.

For instance, you can add a click event attribute to a div, and return the x coordinate of the mouse on click using using the return attribute like this:

```hoon
;div
  =event   "/click/get-x-coordinate"
  =return  "/event/clientX"
  ;
==
```

- Note: the property name is exactly the same as what you would access on the object in JavaScript, so you will need to use camel case in some situations.

#### Implementing forms

There are two ways to implement forms in %mast. You can either use a %mast `return` attribute to return the values of inputs on event, or you can use the typical `<form>` element API.

To make use of the form API, just add a "/submit/..." `event` attribute on your form element to add a submit event listener. If you do this, your shrub will receive a `ui-event` poke on form submit, and the value of each input in the form will be included in the data map of the event poke with each input's `name` attribute as its key.

For example, in your Sail you can implement a form like this:

```hoon
;form(event "/submit/my-form")
  ;input(name "my-input");
  ;button: Submit
==
```

#### The key attribute

The `key` attribute is not necessary to use, but it is best practice when you have a list of elements that will change.

A `key` is a globally unique value which identifies the element (two distinct elements in your Sail should never have the same key). %mast adds location based keys to your elements by default, but when you provide information about the identity of the element by specifying the `key`, it allows %mast to make more efficient display updates.

#### Other attributes

The attributes `debounce` and `throttle` let you add debouncing and throttling to events when placed on an element with an `event` attribute. These attributes take a number value for their duration in seconds.

For example, you can add debounce to an input that sends its value when the user types:

```hoon
;input
  =event     "/input/get-value"
  =return    "/target/value"
  =debounce  "0.7"
  ;
==
```

Using throttle, you can make use of rapid-fire events like mousemove:

```hoon
;div
  =event     "/mousemove/handle-move"
  =return    "/event/clientX /event/clientY"
  =throttle  "0.5"
  ;
==
```

The `js-on-event`, `js-on-add`, and `js-on-delete` events allow you to run arbitrary JavaScript when placed on an element that either has an `event` triggered on it, when the element is added to the DOM through a diff, or deleted through a diff.

For example, with js-on-event you can immediately add a class to an element on an event instead of waiting for an update from your ship:

```hoon
;div
  =id           "my-id"
  =event        "/click/js-example"
  =js-on-event  "document.getElementById('my-id').classList.add('clicked')"
  ;
==
```

---

### Shrub components

Any mast shrub that you write can also function as a component within some other mast shrub. This lets you split up your interface into composable and reusable building blocks for rendering your shrubs, which each serve as standalone UIs.

Whether your mast shrub exists on the client nested as a component, as a standalone UI, or both simultaneously, within your ship it exists as the same shrub and you do not need to treat it any differently in your code.

To add a shrub component in your Sail, write an element where the name is prefixed with `imp_` followed by the name of your shrub's /imp file. This element also needs to have a text node that encodes the `pith` of the %src dependency that your shrub renders. These component elements can be dynamically added or removed like any other element.

For example:

```hoon
;imp_my-mast-shrub: /pith/to/src
```

---

### Examples

The %mast related IO in your shrub would look essentially like this:

```hoon
++  poke
  |=  [=stud:neo =vase]
  ^-  (quip card:neo pail:neo)
  ?+  stud  !!
    ::
      %ui-event
    =/  event  !<(ui-event vase)
    ?+  path.event  !!
      ::
        [%click %my-button ~]
      :: handle the click event ...
      ::
        [%submit %my-form ~]
      :: get form data from the map:
      =/  data=@t  (~(got by data.event) 'my-input-name')
      :: handle the form ...
      ::
    ==
    ::
      %rely
    :: on a change in your dependency's state
    :: produce new manx, and update the shrub's manx state:
    `manx/!>((render-my-sail bowl))
    ::
  ==
```

And the corresponding Sail would look something like this:
 
```hoon
++  render-my-sail
  |=  =bowl:neo
  ^-  manx
  ;html
    ;head;
    ;body
      ;button(event "/click/my-button"): click me
      ;form(event "/submit/my-form")
        ;input(name "my-input-name");
      ==
    ==
  ==
```

Here is a simple front-end for the diary shrub:

```hoon
/@  ui-event
/@  txt
/@  diary-diff
^-  kook:neo
=<
|%
++  state  pro/%manx
++  poke   (sy %ui-event %rely ~)
++  kids   *kids:neo
++  deps
  ^-  deps:neo
  %-  my
  :~  :^  %src  &  [pro/%diary (sy %diary-diff ~)]
      :+  ~  %y  (my [[|/%da |] only/%txt ~] ~)
  ==
++  form
  ^-  form:neo
  |_  [=bowl:neo =aeon:neo =pail:neo]
  ::
  ++  init
    |=  pal=(unit pail:neo)
    ^-  (quip card:neo pail:neo)
    ::
    :: initialize the shrub's manx state.
    ::
    `manx/!>((render bowl))
  ::
  ++  poke
    |=  [sud=stud:neo vaz=vase]
    ^-  (quip card:neo pail:neo)
    ?+  sud  !!
      ::
        %ui-event
      =/  event  !<(ui-event vaz)
      ::
      :: for a ui-event poke, switch over its path,
      :: and implement your event handlers.
      ::
      ?+  path.event  !!
        ::
        :: handling a form submit event that adds a diary entry:
        :: get form data from the data.event map by input name,
        :: and produce a poke for the diary back-end.
        ::
          [%submit %diary-form ~]
        =/  data=@t          (~(got by data.event) 'diary-input')
        =/  diff=diary-diff  [%put-entry now.bowl data]
        =/  dest=pith:neo    p:(~(got by deps.bowl) %src)
        :_  pail
        :~  [dest %poke diary-diff/!>(diff)]
        ==
        ::
        :: handling a button click event that deletes a diary entry:
        :: the path contains the id of the entry to delete,
        :: which is used to produce a delete poke for the back-end.
        ::
          [%click %delete @ta ~]
        =/  id=@da           (slav %da i.t.t.path.event)
        =/  diff=diary-diff  [%del-entry id]
        =/  dest=pith:neo    p:(~(got by deps.bowl) %src)
        :_  pail
        :~  [dest %poke diary-diff/!>(diff)]
        ==
        ::
      ==
      ::
      :: this shrub rerenders any time its back-end data changes,
      :: e.g. when the above event handlers add or delete entries.
      :: simply update your shrub's manx state on %rely, 
      :: and %mast will take care of syncing the client.
      ::
        %rely
      `manx/!>((render bowl))
      ::
    ==
  --
--
::
|%
::
++  render
  |=  =bowl:neo
  =/  diary-data  (get-data bowl)
  ^-  manx
  ;html
    ;head;
    ;body
      ::
      :: this event attribute adds a submit event
      :: and it corresponds to the first ui-event handler.
      ::
      ;form(event "/submit/diary-form")
        ;textarea(name "diary-input");
        ;button: Enter
      ==
      ;div
        ;*  %+  turn  diary-data
            |=  [id=@da =txt]
            ^-  manx
            ;div(key <id>)
              ;span: {(trip txt)}
              ::
              :: this event attribute adds a click event
              :: and it corresponds to the second ui-event handler.
              ::
              ;button(event "/click/delete/{<id>}"):"x"
            ==
      ==
    ==
  ==
::
:: this helper function gets a list of diary entries
:: from the %src dependency back-end.
::
++  get-data
  |=  =bowl:neo
  ^-  (list [@da txt])
  =/  deps  (~(got by deps.bowl) %src)
  %+  turn  ~(tap by kid.q.deps)
  |=  (pair iota:neo (axal:neo idea:neo))
  :-  `@da`+.p
  !<  txt  q.pail:(need fil.q)
::
--
```
