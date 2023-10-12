/-  mast
/+  default-agent, dbug, agentio, server
|%
+$  app  [color-one=tape color-two=tape]
+$  display  manx
+$  state-0  [%0 [=app =display]]
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
      [(make-307 eyreid) state]
    ?+  method.request.req  [(make-405 eyreid) state]
      %'GET'
        :-  (make-200 eyreid [~ (manx-to-octs:server sail-index)]) 
          state(display sail-component)
      %'POST'
        :: parsing the request
        =/  jsonunit  (de:json:html +.+.body.request.req)
        =/  parsedjson  ^-  [tags=@tas data=(list [@t @t])]  
          %-  (ot ~[tags+so data+(ar (at ~[so so]))]):dejs:format
        +.jsonunit
        :: handling the events
        ?+  tags.parsedjson  [(make-400 eyreid) state]
          %click-square-one
            =/  newstate  state(color-one.app "blue")
            =^  package  newstate
              (gust newstate)
            [(make-200 eyreid [~ package]) newstate]
          %click-square-two
            =/  newstate  state(color-two.app "red")
            =^  package  newstate
              (gust newstate)
            [(make-200 eyreid [~ package]) newstate]
        ==
    ==
  ::
  ++  make-200
    |=  [eyreid=@ta resdata=(unit octs)]
    ^-  (list card)
    =/  reshead  
      :-  200
      :~  ['Content-Type' 'text/html']
          :: ['Content-Length' (crip ((d-co:co 1) ?~(resdata ~ p.resdata)))]
      ==
    %+  give-simple-payload:app:server 
      eyreid 
    ^-(simple-payload:http [reshead resdata])
  ::
  ++  make-307
    |=  eyreid=@ta
    ^-  (list card)
    =/  reshead  [307 ['Location' '/~/login?redirect='] ~]
    %+  give-simple-payload:app:server 
      eyreid 
    ^-(simple-payload:http [reshead ~])
  ::
  ++  make-400
    |=  eyreid=@ta
    ^-  (list card)
    %+  give-simple-payload:app:server
      eyreid 
    ^-(simple-payload:http [[400 ~] ~])
  ::
  ++  make-405
    |=  eyreid=@ta
    ^-  (list card)
    =/  reshead
      :-  405
      :~  ['Content-Type' 'text/html']
          ['Content-Length' '31']
          ['Allow' 'GET, POST']
      ==
    =/  resdata  (some (as-octs:mimes:html '<h1>405 Method Not Allowed</h1>'))
    %+  give-simple-payload:app:server
      eyreid 
    ^-(simple-payload:http [reshead resdata])
  :: :: :: ::
  ::
  ::  Sail
  ::
  :: :: :: ::
  ++  sail-index
    :: ^-  octs
    :: %-  as-octs:mimes:html
    :: %-  crip
    :: %-  en-xml:html
    ^-  manx
    ;html
      ;head
        ;title: mast
        ;meta(charset "utf-8");
        ;style
          ;+  ;/  style
        ==
        ;script
          ;+  ;/  script
        ==
      ==
      ;body
        ;+  sail-component
      ==
    ==
  ::
  ++  sail-component
    ^-  manx
    ;main
      Click The Squares
      ;div.square-container
        ;div.square
          =data-event  "click-square-one"
          =class  color-one.app.state
          ;div;
        ==
        ;div.square
          =data-event  "click-square-two"
          =class  color-two.app.state
          ;div;
        ==
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
    .square-container {
      display: flex;
      flex-direction: row;
    }
    .square {
      height: 10rem;
      width: 10rem;
      margin: 3rem;
      border-radius: 0.5rem;
      background-color: black;
    }
    .red {
      background-color: red;
    }
    .blue {
      background-color: blue;
    }
    '''
  ::
  ++  script
    ^~
    %-  trip
    '''
    addEventListener('DOMContentLoaded', () => {
        let eventElements = document.querySelectorAll('[data-event]');
        eventElements.forEach(el => {
            if (el.dataset.event.startsWith('click')) {
                el.addEventListener('click',() => urbitClick(el.dataset.event));
            };
        });
    });

    async function urbitClick(tagString) {
        try {
            const response = await fetch(window.location.href, {
                method: 'POST',
                body: JSON.stringify({
                    tags: tagString,
                    data: []
                })
            });
            const htmlData = await response.text();
            console.log(htmlData);
        } catch (error) {
            console.error(error);
        };
    };
    '''
  :: :: :: ::
  ::
  :: Algorithm 
  ::
  :: :: :: ::
  ++  gust-algo
    |=  [old=$%([%manx manx] [%marl marl]) new=$%([%manx manx] [%marl marl])]
    =/  accumulator=marl  ~
    |-  ^-  marl
    ?>  =(-.old -.new)
    ?:  =(-.new %manx)
      ?.  =(+2.+.old +2.+.new)
        [(manx +.new) accumulator]
      %=  $
        old  [%marl +3.+.old]
        new  [%marl +3.+.new]
      ==
    ?:  ?&(=(~ +.old) =(~ +.new))
      accumulator
    ?:  ?&(=(~ +.old) .?(+.new))
      :_  accumulator  
        %-  manx  
        ;output#new-node-group
          ;*  +.new
        ==
    ?:  ?&(.?(+.old) =(~ +.new))
      :_  accumulator
        %-  manx  
        ;output#nodes-to-delete;
    %=  $ 
      old  [%manx (manx +2.+.old)]
      new  [%manx (manx +2.+.new)]
      accumulator  $(old [%marl +3.+.old], new [%marl +3.+.new])
    ==
  ::
  ++  gust
    |=  newstate=versioned-state
    =/  newdisplay  sail-component(state newstate)
    :_  newstate(display newdisplay)
    %-  manx-to-octs:server
    ^-  manx
    ;output
      ;*  %+  gust-algo 
        [%manx display.state] 
      [%manx newdisplay]
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