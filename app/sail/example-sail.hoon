:: this is a root-level sail component, meant to be collected into yards to be used with rig in the agent.
:: there are a few features necessary for a root-level sail component in order for it to work with mast:
:: 1) they need to be gates which produce manx.
:: 2) they must be a complete document with html, head, and body tags.
:: 3) all root-level sail components ought to have the same sample.
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
          =data-event  "click-square-one"
          ;+  ;/  color-one.app-state
        ==
        ;div
          =class  (weld "square " color-two.app-state)
          =data-event  "click-square-two"
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
      ;input#second-input;
      ;button
        =data-event  "click-test-form"
        =data-return  "#first-input-value #second-input-value"
        Submit
      ==
    ==
  ==
==