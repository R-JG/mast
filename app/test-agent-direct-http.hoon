/-  test-agent-direct-http
/+  default-agent, dbug, agentio, server, mast
/=  test-sail-component  /app/sail/test-sail-component
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
    :: set up mast with the base url and a list of cells of routes to gates which produce manx:
    mast-init  
      %-  mast  
        'mastdirecthttp'
      %-  limo  :~  
        ['/' test-sail-component]
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
            =/  newcolor  ?:(=(color-one.app.state "blue") "green" "blue")
            :: implementing gust:
            =/  newstate  state(color-one.app newcolor)
            =^  output  newstate
              (gust newstate)
            [(make-200 eyreid [~ output]) newstate]
          %click-square-two
            =/  newcolor  ?:(=(color-two.app.state "red") "pink" "red")
            :: implementing gust:
            =/  newstate  state(color-two.app newcolor)
            =^  output  newstate
              (gust newstate)
            [(make-200 eyreid [~ output]) newstate]
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
    :: temporary location for add-mastids-to-manx
    %-  add-mastids-to-manx
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
  :: :: :: ::
  ::
  :: Algorithms
  ::
  :: :: :: ::
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
  ++  gust-algo
    |=  [old=$%([%manx manx] [%marl marl]) new=$%([%manx manx] [%marl marl])]
    =/  accumulator=marl  ~
    |-  ^-  marl
    ?>  =(-.old -.new)
    ?:  =(-.new %manx)
      ?.  =(-.+.old -.+.new)
        [(manx +.new) accumulator]
      ?:  =("masttext" (get-value-from-mart (mart +.-.+.new) %class))
        ?.  =(+.-.+.-.-.+.+.old +.-.+.-.-.+.+.new)
          [(manx +.new) accumulator]
        accumulator
      %=  $
        old  [%marl +.+.old]
        new  [%marl +.+.new]
      ==
    ?:  ?&(=(~ +.old) =(~ +.new))
      accumulator
    ?:  ?&(=(~ +.old) .?(+.new))
      :_  accumulator  
        %-  manx  
        ;output#new
          ;*  +.new
        ==
    ?:  ?&(.?(+.old) =(~ +.new))
      :_  accumulator
      ?+  -.old  !!
        %marl
          =/  last-child  (get-last-manx +.old)
          =/  id-range 
            %+  weld  
              (get-value-from-mart +.-.-.+.old %data-mastid)
            %+  weld  " "  (get-value-from-mart +.-.last-child %data-mastid)
          %-  manx  
          ;output#del(data-deleterange id-range);
      ==
    %=  $ 
      old  [%manx (manx +2.+.old)]
      new  [%manx (manx +2.+.new)]
      accumulator  $(old [%marl +3.+.old], new [%marl +3.+.new])
    ==
  ::
  ++  get-last-manx
    |=  m=marl
    ^-  manx
    ?~  m
      !!
    ?~  t.+.m
      -.m
    $(m +.m)
  ::
  ++  get-value-from-mart
    |=  [attributes=mart tag=@tas]
    ^-  tape
    |-
    ?~  attributes
      attributes
    ?:  =(-.-.attributes tag)
      +.-.attributes
    $(attributes +.attributes)
  ::
  ++  add-mastids-to-manx
    |=  main-node=manx
    =/  initial-mastid=tape  "0"
    |^  ^-  manx
    (traverse-node main-node initial-mastid)
    ++  traverse-node
      |=  [node=manx mastid=tape]
      ?:  =(%$ -.-.node)
        ;span.masttext(data-mastid mastid)
          ;+  node
        ==
      =:  +.-.node  (mart [[%data-mastid mastid] +.-.node])
          +.node  (traverse-child-list +.node mastid)
      ==
      node
    ++  traverse-child-list
      |=  [child-list=marl mastid=tape]
      =/  i=@ud  0
      |-  ^-  marl
      ?~  child-list
        child-list
      :-  %+  traverse-node  (manx -.child-list) 
        (weld (scow %ud i) (weld "-" mastid))
      $(child-list +.child-list, i +(i))
    --
  :: :: :: ::
  ::
  ::  Script 
  ::
  :: :: :: ::
  ++  script
    ^~
    %-  trip
    '''
    addEventListener('DOMContentLoaded', () => {
        let eventElements = document.querySelectorAll('[data-event]');
        eventElements.forEach(el => setEventListeners(el));
    });
    function setEventListeners(el) {
        if (el.dataset.event.startsWith('click')) {
            el.addEventListener('click',() => urbitClick(el.dataset.event));
        };
    };
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
            let container = document.createElement('template');
            container.innerHTML = htmlData;
            while (container.content.firstElementChild.children.length > 0) {
                let outputChild = container.content.firstElementChild.firstElementChild;
                if (outputChild.tagName === 'OUTPUT') {
                    if (outputChild.id === 'del') {
                        const idRange = outputChild.dataset.deleterange.split(' ');
                        let nodeToDelete = document.querySelector(`[data-mastid="${idRange[0]}"]`);
                        while (nodeToDelete) {
                            let next = nodeToDelete.nextElementSibling;
                            nodeToDelete.remove();
                            if (nodeToDelete.dataset.mastid === idRange[1]) break;
                            nodeToDelete = next;
                        };
                        outputChild.remove();
                    } else if (outputChild.id === 'new') {
                        const parentid = outputChild.firstElementChild.dataset.mastid.split(/-(.*)/, 2)[1];
                        let domParent = document.querySelector(`[data-mastid="${parentid}"]`);
                        domParent.append(...outputChild.children);
                        outputChild.remove();
                    };
                } else {
                    const mastid = outputChild.dataset.mastid;
                    let existentNode = document.querySelector(`[data-mastid="${mastid}"]`);
                    existentNode.replaceWith(outputChild);
                    if (outputChild.dataset.event) {
                        let replacedNode = document.querySelector(`[data-mastid="${mastid}"]`);
                        setEventListeners(replacedNode);
                    };
                };
            };
        } catch (error) {
            console.error(error);
        };
    };
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