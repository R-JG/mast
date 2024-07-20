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
    :: a list of cells of url paths to gates (your sail components), are required for rig:mast.
    :: see the example sail component for more information.
    :: these define all of the different pages for your app.
    routes  %-  limo  :~  
        :-  /example-agent  example-sail
        :-  /example-agent/page-two  example-sail-two
      ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-init
  ^-  (quip card _this)
  :_  this
  :: binding the base url:
  [(~(arvo pass:io /bind) %e %connect `/'example-agent' %example-agent) ~]
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
      :: mast uses a combination of direct http and the channel system.
      :: pokes will be received under these two marks:
      :: %handle-http-request is for when the app is accessed via the url,
      :: %json is for the client event pokes that the mast script will send.
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
        :: the request url from eyre can be parsed into a path either with stab,
        :: or with parse-url:mast which handles trailing slashes and allows for all characters in @t.
        =/  url=path  (parse-url:mast url.request.req)
        :: css ought to be linked to from the head of the sail document, and can be handled like this:
        ?:  =(/example-agent/css url)
          [(make-css-response:mast eyre-id example-stylesheet) state]
        ::
        :: --- rig ---
        :: rig produces new display data which is used for plank, gust, and for updating your agent's display state.
        :: note: in the rig sample, "app" here just represents whatever your root-level sail components take as their sample (see example-sail for more information).
        =/  new-display  (rig:mast routes url app)
        ::
        :: --- plank ---
        :: plank is the endpoint that the client will hit first when loading the app via the url.
        :: it serves any of the pages in your routes list according to the request url (and otherwise a default 404 page).
        :: plank inserts the library's script into your sail component to set up all of the client side functionality.
        :-  (plank:mast "example-agent" /display-updates our.bowl eyre-id new-display)
        ::
        :: state is then set with the new display and url:
        state(display new-display, current-url url)
    ==
  ++  handle-json-request
    |=  json-request=json
    ^-  (quip card _state)
    :: a client poke from mast has the form [tags data].
    :: the tags are what one had defined in the event attribute in the sail element which triggered the event.
    :: these tags are then used to define your event handlers in the agent.
    =/  client-poke  (parse-json:mast json-request)
    ?+  tags.client-poke  !!
      [%click %square-one ~]
        :: 
        =/  newcolor  ?:(=(color-one.app "blue") "green" "blue")
        =/  new-app-state  app(color-one newcolor)
        ::
        :: --- rig ---
        :: when rig is used with updated app state it will produce a new version 
        :: of the display with differences according to the logic of your sail component.
        =/  new-display  (rig:mast routes current-url new-app-state)
        ::
        :: --- gust ---
        :: gust then produces a response with html to sync the browser's display with your agent.
        :: the response contains a minimal amount of html to achive the new display state, rather than a whole new page.
        :-  [(gust:mast /display-updates display new-display) ~]
        state(app new-app-state, display new-display)
      [%click %square-two ~]
        =/  newcolor  ?:(=(color-two.app "red") "pink" "red")
        =/  new-app-state  app(color-two newcolor)
        =/  new-display  (rig:mast routes current-url new-app-state)
        :-  [(gust:mast /display-updates display new-display) ~]
        state(app new-app-state, display new-display)
      [%click %navigate-to-index ~]
        :: with gust, you can navigate to a different route by sending a minimal set of updates instead of a whole page.
        :: this is done simply whenever the sail is rigged using a different url relative to whatever is current:
        =/  new-url=path  /example-agent
        =/  new-display  (rig:mast routes new-url app)
        :-  [(gust:mast /display-updates display new-display) ~]
        state(display new-display, current-url new-url)
      [%click %navigate-to-page-two ~]
        =/  new-url=path  /example-agent/page-two
        =/  new-display  (rig:mast routes new-url app)
        :-  [(gust:mast /display-updates display new-display) ~]
        state(display new-display, current-url new-url)
      [%click %test-form-submit ~]
        :: the data in a client poke consists in a (map @t @t) containing what was 
        :: specified in the return attribute of the sail element.
        :: the keys are the return attribute paths, and the values are the property values returned.
        ~&  (~(got by data.client-poke) '/first-input/value')
        `state
      [%click %submit-letters ~]
        =/  input  (~(got by data.client-poke) '/letters-input/value')
        =/  rng  ~(. og eny.bowl)
        =.  letters.app   [[input -:(rads:rng 100)] letters.app]
        =/  new-display  (rig:mast routes current-url app)
        :-  [(gust:mast /display-updates display new-display) ~]
        state(display new-display)
      [%click %switch-letters ~]
        =/  last  (rear letters.app)
        =.  letters.app  [last (snip letters.app)]
        =/  new-display  (rig:mast routes current-url app)
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