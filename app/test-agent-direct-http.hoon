/-  test-agent-direct-http
/+  default-agent, dbug, agentio, server, mast
/=  test-sail  /app/sail/test-sail
/=  test-sail-two  /app/sail/test-sail-two
|%
+$  state-0  [%0 teststate:test-agent-direct-http]
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
    yards  %-  limo  
      :~  
        ['/mastdirecthttp' test-sail]
        ['/mastdirecthttp/two' test-sail-two]
      ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-init
  ^-  (quip card _this)
  :_  this
    [(~(arvo pass:io /bind) %e %connect `/'mastdirecthttp' %test-agent-direct-http) ~]
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
  :: :: :: ::
  ::
  ::  Server 
  ::
  :: :: :: ::
  ++  handle-http-request
    |=  [eyreid=@ta req=inbound-request:eyre]
    ^-  (quip card _state)
    ?.  authenticated.req
      [(make-307:mast eyreid) state]
    ?+  method.request.req  [(make-400:mast eyreid) state]
      %'GET'
        =/  rigged-sail  (rig:mast url.request.req yards app.state)
        :-  (gust:mast %route eyreid display.state rigged-sail)
        state(display rigged-sail)
      ::
      %'POST'
        :: parsing the request
        =/  parsedjson  (parse:mast req)
        ?~  parsedjson  !!
        :: handling the events
        ?+  tags.parsedjson  [(make-400:mast eyreid) state]
          %click-square-one
            =/  newcolor  ?:(=(color-one.app.state "blue") "green" "blue")
            =/  new-app-state  app.state(color-one newcolor)
            :: implementing rig and gust:
            =/  rigged-sail  (rig:mast url.request.req yards new-app-state)
            :-  (gust:mast %event eyreid display.state rigged-sail)
            state(app new-app-state, display rigged-sail)
          ::
          %click-square-two
            =/  newcolor  ?:(=(color-two.app.state "red") "pink" "red")
            =/  new-app-state  app.state(color-two newcolor)
            :: implementing rig and gust:
            =/  rigged-sail  (rig:mast url.request.req yards new-app-state)
            :-  (gust:mast %event eyreid display.state rigged-sail)
            state(app new-app-state, display rigged-sail)
        ==
    ==
  :: :: :: ::
  ::
  ::  Sail
  ::
  :: :: :: ::
  ++  sail-component
    ^-  manx
    ;main
      ;p
        ;+  ?:  =(color-two.app.state "red")
          ;/  "Click The Squares"
        ;/  "conditionally rendered text!"
      ==
      ;div.container
        ;*  %+  turn  color-one.app.state
          |=  t=@t 
          ^-  manx
          ;div.smallcircle
            ;+  ;/  (trip t)
          ==
      ==
      ;div.container
        ;div
          =class  (weld "square " color-one.app.state)
          =data-event  "click-square-one"
          ;+  ;/  color-one.app.state
        ==
        ;div
          =class  (weld "square " color-two.app.state)
          =data-event  "click-square-two"
          ;+  ;/  color-two.app.state
        ==
      ==
      ;div.container
        ;+  ?:  =(color-one.app.state "blue") 
          ;div.circle; 
        ;div.circle
          ;div;
          ;div.smallcircle;
          ;div;
        ==
        ;+  ?:  =(color-two.app.state "red")
          ;div.circle;
        ;div;
      ==
    ==
  ::
  ++  style
    ^~
    %-  trip
    '''
    body {
      width: 100vw;
      height: 100vh;
      margin: 0;
    }
    main {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }
    .container {
      display: flex;
      flex-direction: row;
    }
    .square {
      height: 10rem;
      width: 10rem;
      margin: 3rem;
      border-radius: 0.5rem;
      color: white;
      background-color: black;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }
    .circle {
      height: 5rem;
      width: 5rem;
      margin: 2rem;
      border-radius: 5rem;
      background-color: black;
    }
    .smallcircle {
      height: 1rem;
      width: 1rem;
      margin: 1rem;
      border-radius: 1rem;
      background-color: orange;
    }
    .red {
      background-color: red;
    }
    .blue {
      background-color: blue;
    }
    .pink {
      background-color: pink;
    }
    .green {
      background-color: green;
    }
    '''
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