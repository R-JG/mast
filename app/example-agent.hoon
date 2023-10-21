/-  example-agent
/+  default-agent, dbug, agentio, mast
/=  example-sail  /app/sail/example-sail
/=  example-sail-two  /app/sail/example-sail-two
/=  example-stylesheet  /app/sail/example-stylesheet
|%
+$  state-0  [%0 example-state:example-agent]
+$  versioned-state  $%(state-0)
+$  card  card:agent:gall
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    io    ~(. agentio bowl)
    :: a list of cells of routes to gates which produce manx are required for rig:mast
    yards  %-  limo  :~  
        ['/example-app' example-sail]
        ['/example-app/page-two' example-sail-two]
      ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-init
  ^-  (quip card _this)
  :_  this
  :: binding the base url
  [(~(arvo pass:io /bind) %e %connect `/'example-app' %example-agent) ~]
++  on-save
  ^-  vase
  !>  state
++  on-load
  |=  saved-state=vase
  ^-  (quip card _this)
  `this(state !<(versioned-state saved-state))
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)
  ?>  =(our.bowl src.bowl)
  =^  cards  state
    ?+  mark  (on-poke:def mark vase)
      %handle-http-request
        (handle-http-request !<([@ta inbound-request:eyre] vase))
    ==
  [cards this]
  ::
  ++  handle-http-request
    |=  [eyreid=@ta req=inbound-request:eyre]
    ^-  (quip card _state)
    :: handling authentication:
    ?.  authenticated.req
      [(make-auth-redirect:mast eyreid) state]
    ?+  method.request.req  [(make-400:mast eyreid) state]
      %'GET'
        :: the css ought to be linked to from the head, and can be handled like this:
        ?:  =('/example-app/css' url.request.req)
          [(make-css-response:mast eyreid example-stylesheet) state]
        :: gust %page will serve all routes included in yards, and a 404 if the route isn't found.
        :: you can also handle any particular route before this and just use it as a catch-all.
        =/  rigged-sail  (rig:mast url.request.req yards app.state)
        :-  (gust:mast %page eyreid display.state rigged-sail)
        state(display rigged-sail)
      ::
      %'POST'
        :: parsing the request:
        =/  parsedjson  (parse:mast req)
        ?~  parsedjson  !!
        :: handling the client-side events:
        ?+  tags.parsedjson  [(make-400:mast eyreid) state]
          %click-square-one
            =/  newcolor  ?:(=(color-one.app.state "blue") "green" "blue")
            =/  new-app-state  app.state(color-one newcolor)
            :: implementing rig and gust:
            =/  rigged-sail  (rig:mast url.request.req yards new-app-state)
            :-  (gust:mast %update eyreid display.state rigged-sail)
            state(app new-app-state, display rigged-sail)
          ::
          %click-square-two
            =/  newcolor  ?:(=(color-two.app.state "red") "pink" "red")
            =/  new-app-state  app.state(color-two newcolor)
            :: implementing rig and gust:
            =/  rigged-sail  (rig:mast url.request.req yards new-app-state)
            :-  (gust:mast %update eyreid display.state rigged-sail)
            state(app new-app-state, display rigged-sail)
        ==
    ==
  --
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    [%http-response *]
      :: %-  (slog leaf+"Eyre subscribed to {(spud path)}." ~)
      `this
  ==
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?.  ?=([%bind ~] wire)
    (on-arvo:def [wire sign-arvo])
  ?.  ?=([%eyre %bound *] sign-arvo)
    (on-arvo:def [wire sign-arvo])
  ~?  !accepted.sign-arvo
    %eyre-rejected-squad-binding
  `this
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-fail   on-fail:def
--