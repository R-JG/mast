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
      :: at the moment, mast involves a combination of direct http and the channel system.
      :: (the pokes from the client just have a json mark for now which can be parsed with the library; I will change this.)
      %handle-http-request
        (handle-http-request !<([@ta inbound-request:eyre] vase))
      %json
        (handle-json-request !<(json vase))
    ==
  [cards this]
  ::
  ++  handle-http-request
    |=  [eyre-id=@ta req=inbound-request:eyre]
    ^-  (quip card _state)
    :: handling authentication:
    ?.  authenticated.req
      [(make-auth-redirect:mast eyre-id) state]
    ?+  method.request.req  [(make-400:mast eyre-id) state]
      %'GET'
        :: css ought to be linked to from the head of the sail document, and can be handled like this:
        ?:  =('/example-app/css' url.request.req)
          [(make-css-response:mast eyre-id example-stylesheet) state]
        :: rig produces new display data which is used for plank, gust, and for updating your agent's display state.
        =/  rigged-sail  (rig:mast yards url.request.req app.state)
        :: plank is the endpoint that the client will hit first when loading the app via the url.
        :: it serves any of the pages in yards according to the request url (and otherwise a 404 page).
        :: plank inserts the library's script into your sail component to set up all of the client side functionality.
        :-  (plank:mast eyre-id our.bowl "example-agent" "/display-updates" rigged-sail)
        :: state is then set with the new display and current url:
        state(display rigged-sail, current-url url.request.req)
    ==
  ++  handle-json-request
    |=  json-request=json
    ^-  (quip card _state)
    :: a client poke from mast has the form [tags data].
    :: the tags are what one had defined in the data-event attribute in the sail node which triggered the event.
    :: these tags are then used to define the event handler in the agent for the particular event request.
    =/  client-poke  (parse:mast json-request)
    :: note: if you switch over only the first two sections of the event tags,
    :: it is possible to have a further part of the path be variable, 
    :: which is useful when handling events for dynamically generated components.
    ?~  tags.client-poke  !!
    ?~  t.tags.client-poke  !!
    ?+  [i.tags.client-poke i.t.tags.client-poke]  !!
      [%click %square-one]
        :: the data in a client poke consists in a map of the existent values specified in the data-return attribute in the sail node.
        :: you can return any property from: 
        :: 1) the event object
        :: 2) the element on which the event was triggered
        :: 3) any other element at all by id (this is how forms are implemented).
        ~&  data.client-poke
        =/  newcolor  ?:(=(color-one.app.state "blue") "green" "blue")
        =/  new-app-state  app.state(color-one newcolor)
        :: when rig is used with updated app state it will produce changes in the display according to the logic of your sail component.
        =/  rigged-sail  (rig:mast yards current-url.state new-app-state)
        :: gust then produces a response with html to sync the browser's display with your agent.
        :: the response contains a minimal amount of html to achive the new display state, rather than a whole new page.
        :-  (gust:mast /display-updates display.state rigged-sail)
        state(app new-app-state, display rigged-sail)
      [%click %square-two]
        ~&  data.client-poke
        =/  newcolor  ?:(=(color-two.app.state "red") "pink" "red")
        =/  new-app-state  app.state(color-two newcolor)
        =/  rigged-sail  (rig:mast yards current-url.state new-app-state)
        :-  (gust:mast /display-updates display.state rigged-sail)
        state(app new-app-state, display rigged-sail)
      [%click %navigate-to-index]
        :: with gust, you can navigate to a different route by sending a minimal set of updates instead of a whole page.
        :: this is done simply whenever the sail is rigged using a different url relative to whatever is current:
        =/  new-url  '/example-app'
        =/  rigged-sail  (rig:mast yards new-url app.state)
        :-  (gust:mast /display-updates display.state rigged-sail)
        state(display rigged-sail, current-url new-url)
      [%click %navigate-to-page-two]
        =/  new-url  '/example-app/page-two'
        =/  rigged-sail  (rig:mast yards new-url app.state)
        :-  (gust:mast /display-updates display.state rigged-sail)
        state(display rigged-sail, current-url new-url)
      [%click %test-form-submit]
        ~&  (~(get by data.client-poke) '/first-input/value')
        `state
      [%click %test-dynamic-handler]
        ?~  t.t.tags.client-poke  !!
        =/  dynamic-key  (crip "/test-{(trip i.t.t.tags.client-poke)}/id")
        ~&  (~(get by data.client-poke) dynamic-key)
        !!
    ==
  --
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    [%http-response *]
      %-  (slog leaf+"Eyre subscribed to {(spud path)}." ~)
      `this
    [%display-updates *]
      %-  (slog leaf+"Eyre subscribed to {(spud path)}." ~)
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