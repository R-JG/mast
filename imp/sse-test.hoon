/@  sse-test
/-  mast-test
^-  kook:neo
=<
|%
++  state  pro/%sse-test
++  poke   (sy %eyre-task %eyre-chan-task ~)
++  kids   ~
++  deps   ~
++  form
  ^-  form:neo
  |_  [=bowl:neo =aeon:neo =pail:neo]
  +*  mast  ~(. mast-test our.bowl)
      routes
        %-  limo
        :~  :-  /mast-test  render
        ==
  ++  init
    |=  pal=(unit pail:neo)
    ^-  (quip card:neo pail:neo)
    =/  =pith:neo  #/[p/our.bowl]/$/eyre
    =/  =binding:eyre  [~ [%mast-test ~]]
    =/  =req:eyre:neo  [%connect binding here.bowl]
    :_  sse-test/!>(`sse-test`[0 (render *sse-test)])
    :~  [pith %poke eyre-req/!>(req)]
    ==
  ++  poke
    |=  [sud=stud:neo vaz=vase]
    ^-  (quip card:neo pail:neo)
    =/  state  !<(sse-test q.pail)
    ?+  sud  ~|(bad-stud/sud !!)
      ::
        %eyre-task
      ~&  >>  sud
      =+  !<([eyre-id=@ta req=inbound-request:eyre] vaz)
      ?.  authenticated.req
        [(make-auth-redirect:mast eyre-id) pail]
      ?+  method.request.req  [(make-400:mast eyre-id) pail]
          %'GET'
        =/  url=path  (parse-url:mast url.request.req)
        =/  new-display  (rig:mast routes url state)
        :_  pail
        (plank:mast /display-updates our.bowl eyre-id new-display)
      ==
      ::
        %eyre-chan-task
      ~&  >  sud
      =/  json-request  !<(json vaz)
      ~&  >  json-request
      =/  client-poke  (parse-json:mast json-request)
      ~&  >  client-poke
      ?+  tags.client-poke  !!
          [%click %test ~]
        ~&  >>>  %click
        =.  num.state  +(num.state)
        =/  new-display  (rig:mast routes ^-(path /mast-test) state)
        :_  sse-test/!>(state(manx new-display))
        :~  (gust:mast /display-updates manx.state new-display)
        ==
      ==
      ::
    ==
  --
--
::
|%
++  render
  |=  =sse-test
  ^-  manx
  ;html
    ;head
      ;meta(charset "utf-8");
    ==
    ;body
      ;main
        ;h1: My Web Site
        ;p: make number go up
        ;button(event "/click/test"): Click
        ;h2: {(scow %ud num.sse-test)}
      ==
    ==
  ==
--
