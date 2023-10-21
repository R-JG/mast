/-  example-agent
/=  example-stylesheet  /app/sail/example-stylesheet
|=  app-state=app.example-state.example-agent
^-  manx
;html
  ;head
    ;meta(charset "utf-8");
    ;style
      ;+  ;/  example-stylesheet
    ==
  ==
  ;body
    ;main
      ;p: Second Page
      ;div.container
        ;*  %+  turn  color-two.app-state
          |=  t=@t 
          ^-  manx
          ;div.smallcircle
            ;+  ;/  (trip t)
          ==
      ==
      ;div.container
        ;div
          =class  (weld "square " color-two.app-state)
          =data-event  "click-square-two"
          ;+  ;/  color-two.app-state
        ==
        ;div
          =class  (weld "square " color-one.app-state)
          =data-event  "click-square-one"
          ;+  ;/  color-one.app-state
        ==
      ==
    ==
  ==
==