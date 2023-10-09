/-  mast
/+  default-agent, dbug, agentio
|%
+$  click-one  [%event %click %red]
+$  click-two  [%event %click %blue]
+$  fe-event
  $%  click-one
      click-two
  ==
+$  app-state  [color-one=@t color-two=@t]
+$  display-state  manx
+$  state-0  [%0 [=app-state =display-state]]
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
  `this
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
  ?+  mark  (on-poke:def mark vase)
    %mast-request
      =/  =request:mast  !<(request:mast vase)
      ?+  -.-.request  (on-poke:def mark vase)
        %event
          =^  cards  state
            (handle-event-poke request)
          [cards this]
      ==
  ==
  ++  handle-event-poke
    |=  event-request=request:mast
    ^-  (quip card _state)
    `state
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--