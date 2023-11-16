:: this is a root-level sail component, meant to be collected into yards to be used with rig in the agent.
:: there are a few features necessary for a root-level sail component in order for it to work with mast:
:: 1) it needs to be a gate which produces manx.
:: 2) it must produce a complete document with html, head, and body tags.
:: 3) currently, all root-level sail components need to have the same sample.
:: the sample can be any noun representing the application state, used to dynamically generate content within the component.
:: in any other piece of sail included under a root-level one, there are no restrictions on how they need to be written.
/-  example-agent
|=  app-state=app.example-state.example-agent
^-  manx
;html
  ;head
    ;meta(charset "utf-8");
    :: it is strongly advised to link to any css instead of including it in a style tag.
    :: see the example agent for an example of how to serve the css for a link.
    ;link(href "/example-app/css", rel "stylesheet");
  ==
  ;body
    ;main
      ;p
        ;+  ?:  =(color-two.app-state "red")
          ;/  "Click The Squares"
        ;/  "conditionally rendered text!"
      ==
      ;div.container
        ;*  %+  turn  color-one.app-state
          |=  t=@t 
          ^-  manx
          ;div.smallcircle
            ;+  ;/  (trip t)
          ==
      ==
      ;div.container
        ;div
          =class  (weld "square " color-one.app-state)
          :: the event attribute is where event listeners are specified.
          :: the event attribute needs to be formatted as a path
          :: the first word must correspond to the name of the event listener, minus the "on" prefix.
          :: the listener essentially just sends a poke to your agent with some data.
          :: this tag is then used in your agent to identify the handler for the event poke.
          =event  "/click/square-one"
          :: the return attribute is for specifying what data to return from the event.
          :: a number of path tags may be specified, separated by whitespace.
          :: there are three options for the beginning of the path: 
          :: 1) "target", for the current target, i.e. the element on which the event was triggered.
          :: 2) "event", for the event object.
          :: 3) anything else corresponding to the id of any element.
          :: the last section in the tag is the property key for the value to return.
          =return  "/target/textContent"
          ;+  ;/  color-one.app-state
        ==
        ;div
          =class  (weld "square " color-two.app-state)
          =event  "/click/square-two"
          =return  "/target/textContent"
          ;+  ;/  color-two.app-state
        ==
      ==
      ;div.container
        ;+  ?:  =(color-one.app-state "blue") 
          ;div.circle; 
        ;div.circle
          ;div;
          ;div.smallcircle;
          ;div;
        ==
        ;+  ?:  =(color-two.app-state "red")
          ;div.circle;
        ;div;
      ==
      ;input#first-input;
      ;button(event "/click/test-form-submit", return "/first-input/value"): submit
      ;button(event "/click/navigate-to-page-two"): navigate
      ;div.container
        ;*  %+  turn  letters.app-state
          |=  [l=@t id=@ud]
          ^-  manx
          ;div
            =class  "smallcircle"
            =key  <id>
            ;+  ;/  (trip l)
          ==
      ==
      ;input#letters-input;
      ;button(event "/click/submit-letters", return "/letters-input/value"): Enter letters
      ;button(event "/click/switch-letters"): Switch letters
    ==
  ==
==