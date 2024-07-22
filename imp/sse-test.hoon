/@  ui-event
^-  kook:neo
=<
|%
++  state  pro/%manx
++  poke   (sy %ui-event ~)
++  kids   ~
++  deps   ~
++  form
  ^-  form:neo
  |_  [=bowl:neo =aeon:neo =pail:neo]
  ++  init
    |=  pal=(unit pail:neo)
    ^-  (quip card:neo pail:neo)
    [~ manx/!>((render now.bowl))]
  ++  poke
    |=  [sud=stud:neo vaz=vase]
    ^-  (quip card:neo pail:neo)
    ?+  sud  ~|(bad-stud/sud !!)
      ::
        %ui-event
      =/  eve  !<(ui-event vaz)
      ?+  path.eve  ~|(missing-event-handler-for/path.eve !!)
        ::
          [%click %test ~]
        [~ manx/!>((render now.bowl))]
        ::
      ==
      ::
    ==
  --
--
::
|%
++  render
  |=  now=@da
  ^-  manx
  ;html
    ;head
      ;meta(charset "utf-8");
    ==
    ;body
      ;main
        ;h1: {<now>}
        ;button(event "/click/test"): now
      ==
    ==
  ==
--
