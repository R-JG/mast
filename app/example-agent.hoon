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
    :: yards, i.e. a list of cells of routes to sail components, are required for rig:mast.
    :: see the example sail component for more information.
    :: these define all of the different pages for your app.
    yards  %-  limo  :~  
        ['/example-app' example-sail]
        ['/example-app/page-two' example-sail-two]
      ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-init
  ^-  (quip card _this)
  :_  this
  :: binding the base url:
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
        :: css ought to be linked to from the head of the sail document, and can be handled like this:
        ?:  =('/example-app/css' url.request.req)
          [(make-css-response:mast eyreid example-stylesheet) state]
        :: gust %page will serve all routes included in yards, and a 404 if the route isn't found.
        :: you could also handle any particular route before this and use gust as a catch-all.
        :: rig produces new display data which is used for gust and for updating your agent's display state.
        =/  rigged-sail  (rig:mast yards url.request.req app.state)
        :-  (gust:mast %page eyreid display.state rigged-sail)
        state(display rigged-sail)
      ::
      %'POST'
        :: parsing the request:
        =/  parsedjson  (parse:mast req)
        ?~  parsedjson  !!
        :: the body of a post request from mast has the form [tags data].
        :: the tags are what one had defined in the data-event attribute in the sail node which triggered the event.
        :: these tags are then used to define the event handler in the agent for the particular event request.
        :: handling the client-sent events:
        ?+  tags.parsedjson  [(make-400:mast eyreid) state]
          %click-square-one
            :: updating app state:
            =/  newcolor  ?:(=(color-one.app.state "blue") "green" "blue")
            =/  new-app-state  app.state(color-one newcolor)
            :: rig is then used with the updated app state relevant to your sail components.
            :: gust %update produces a response which syncs the browser's display with your agent.
            :: it produces a minimal amount of html, rather than a whole new page.
            :: implementing rig and gust:
            =/  rigged-sail  (rig:mast yards url.request.req new-app-state)
            :-  (gust:mast %update eyreid display.state rigged-sail)
            state(app new-app-state, display rigged-sail)
          ::
          %click-square-two
            =/  newcolor  ?:(=(color-two.app.state "red") "pink" "red")
            =/  new-app-state  app.state(color-two newcolor)
            =/  rigged-sail  (rig:mast yards url.request.req new-app-state)
            :-  (gust:mast %update eyreid display.state rigged-sail)
            state(app new-app-state, display rigged-sail)
          ::
          %click-navigate-to-index
          :: with gust %update, you can navigate to a different route by sending updates instead of a whole page.
          :: this is done simply whenever the sail is rigged using a different url than whatever is current:
            =/  rigged-sail  (rig:mast yards '/example-app' app.state)
            :-  (gust:mast %update eyreid display.state rigged-sail)
            state(display rigged-sail)
          ::
          %click-test-form
            ~&  'data'
            ~&  data.parsedjson
            :-  (make-html-200:mast eyreid ~)
            state
        ==
    ==
  --
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    [%http-response *]
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