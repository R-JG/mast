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
        [/example-app example-sail]
        [/example-app/page-two example-sail-two]
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
        =/  url=path  (parse-url:mast url.request.req)
        :: css ought to be linked to from the head of the sail document, and can be handled like this:
        ?:  =(/example-app/css url)
          [(make-css-response:mast eyre-id example-stylesheet) state]
        :: rig produces new display data which is used for plank, gust, and for updating your agent's display state.
        =/  new-display  (rig:mast yards url app.state)
        :: plank is the endpoint that the client will hit first when loading the app via the url.
        :: it serves any of the pages in yards according to the request url (and otherwise a 404 page).
        :: plank inserts the library's script into your sail component to set up all of the client side functionality.
        :-  (plank:mast "example-agent" /display-updates our.bowl eyre-id new-display)
        :: state is then set with the new display and current url:
        state(display new-display, current-url url)
    ==
  ++  handle-json-request
    |=  json-request=json
    ^-  (quip card _state)
    :: a client poke from mast has the form [tags data].
    :: the tags are what one had defined in the event attribute in the sail node which triggered the event.
    :: these tags are then used to define the event handler in the agent for the particular event request.
    =/  client-poke  (parse-json:mast json-request)
    :: note: if you switch over only the first two sections of the event tags,
    :: it is possible to have a further part of the path be variable, 
    :: which is useful when handling events for dynamically generated components.
    ?~  tags.client-poke  !!
    ?~  t.tags.client-poke  !!
    ?+  [i.tags.client-poke i.t.tags.client-poke]  !!
      [%click %square-one]
        :: the data in a client poke consists in a map of the existent values specified in the return attribute in the sail node.
        :: you can return any property from: 
        :: 1) the event object
        :: 2) the element on which the event was triggered
        :: 3) any other element at all by id (this is how forms are implemented).
        =/  newcolor  ?:(=(color-one.app.state "blue") "green" "blue")
        =/  new-app-state  app.state(color-one newcolor)
        :: when rig is used with updated app state it will produce changes in the display according to the logic of your sail component.
        =/  new-display  (rig:mast yards current-url.state new-app-state)
        :: gust then produces a response with html to sync the browser's display with your agent.
        :: the response contains a minimal amount of html to achive the new display state, rather than a whole new page.
        :-  [(gust:mast /display-updates display.state new-display) ~]
        state(app new-app-state, display new-display)
      [%click %square-two]
        =/  newcolor  ?:(=(color-two.app.state "red") "pink" "red")
        =/  new-app-state  app.state(color-two newcolor)
        =/  new-display  (rig:mast yards current-url.state new-app-state)
        :-  [(gust:mast /display-updates display.state new-display) ~]
        state(app new-app-state, display new-display)
      [%click %navigate-to-index]
        :: with gust, you can navigate to a different route by sending a minimal set of updates instead of a whole page.
        :: this is done simply whenever the sail is rigged using a different url relative to whatever is current:
        =/  new-url=path  /example-app
        =/  new-display  (rig:mast yards new-url app.state)
        :-  [(gust:mast /display-updates display.state new-display) ~]
        state(display new-display, current-url new-url)
      [%click %navigate-to-page-two]
        =/  new-url=path  /example-app/page-two
        =/  new-display  (rig:mast yards new-url app.state)
        :-  [(gust:mast /display-updates display.state new-display) ~]
        state(display new-display, current-url new-url)
      [%click %test-form-submit]
        ~&  (~(get by data.client-poke) '/first-input/value')
        `state
      [%click %test-dynamic-handler]
        ?~  t.t.tags.client-poke  !!
        =/  dynamic-key  (crip "/test-{(trip i.t.t.tags.client-poke)}/id")
        ~&  (~(get by data.client-poke) dynamic-key)
        !!
      [%click %submit-letters]
        =/  input  (~(got by data.client-poke) '/letters-input/value')
        =/  rng  ~(. og eny.bowl)
        =.  letters.app   [[input -:(rads:rng 100)] letters.app]
        =/  new-display  (rig:mast yards current-url app)
        :-  [(gust:mast /display-updates display new-display) ~]
        state(display new-display)
      [%click %switch-letters]
        =/  last  (rear letters.app)
        =.  letters.app  [last (snip letters.app)]
        =/  new-display  (rig:mast yards current-url app)
        :-  [(gust:mast /display-updates display new-display) ~]
        state(display new-display)
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