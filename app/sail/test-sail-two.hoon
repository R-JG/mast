/-  test-agent-direct-http
/=  test-stylesheet  /app/sail/test-stylesheet
|=  app-state=app.teststate.test-agent-direct-http
^-  manx
;html
  ;head
    ;title: test
    ;meta(charset "utf-8");
    ;style
      ;+  ;/  test-stylesheet
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