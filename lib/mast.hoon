/+  server
|%
+$  yard  [url=@t sail=gate]
+$  yards  (list yard)
+$  parsed-request  [tags=@tas data=(list [@t @t])]
+$  gust-action  ?(%route %event)
+$  gust-sample  $%([%manx manx] [%marl marl])
+$  card  card:agent:gall
:: :: :: ::
::
::  Server 
::
:: :: :: ::

:: ++  auth
:: add a separate authentication helper arm:
:: ?.  authenticated.req
::   [(make-307 eyreid) current-display-state]

::
++  parse
  |=  req=inbound-request:eyre
  ^-  ?(~ parsed-request)
  =/  jsonunit  (de:json:html +.+.body.request.req)
  ?~  jsonunit
    ~
  %-  (ot ~[tags+so data+(ar (at ~[so so]))]):dejs:format
  u.jsonunit
::
++  rig
  |*  [target-url=@t =yards app-state=*]
  ?~  yards
    :: find a better solution for 404s, i.e. when a yard is not found.
    (set-ids (manx [[%div ~] [[%$ [%$ "404"] ~] ~] ~]))
  ?:  =(target-url url.i.yards)
    (set-ids (manx (sail.i.yards app-state)))
  $(yards t.yards)
::
++  gust
  |=  [=gust-action eyreid=@ta current-display-state=manx new-display-state=manx]
  ^-  (list card)
  %+  make-html-200  eyreid 
  :-  ~
  %-  manx-to-octs:server
  ^-  manx
  ?-  gust-action
    %route
      (sail-document new-display-state)
    %event
      ;output
        ;*  %+  gust-algo
          [%manx current-display-state]
        [%manx new-display-state]
      ==
  ==
::
++  make-html-200
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
++  make-404
  |=  [eyreid=@ta resdata=(unit octs)]
  ^-  (list card)
  %+  give-simple-payload:app:server
    eyreid 
  ^-(simple-payload:http [[404 ~] resdata])
:: :: :: ::
::
:: Algorithms
::
:: :: :: ::
++  gust-algo
  |=  [old=gust-sample new=gust-sample]
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
++  set-ids
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
++  find-yard
  |*  [=yards target-url=@t]
  =/  i=@ud  0
  |-  ^-  (unit @ud)
  ?~  yards
    ~
  ?:  =(target-url url.i.yards)
    `i
  $(yards t.yards, i +(i))
:: :: :: ::
::
::  Sail
::
:: :: :: ::
++  sail-document
  |=  root-component=manx
  ^-  manx
  ;html
    ;head
      ;meta(charset "utf-8");
      ;script
        ;+  ;/  script
      ==
    ==
    ;body
      ;+  root-component
    ==
  ==
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
                      const firstChildId = outputChild.firstElementChild.dataset.mastid;
                      const parentid = firstChildId.split(/-(.*)/, 2)[1];
                      let domParent = document.querySelector(`[data-mastid="${parentid}"]`);
                      domParent.append(...outputChild.children);
                      let appendedChild = domParent.querySelector(`[data-mastid="${firstChildId}"]`);
                      while (appendedChild) {
                          if (appendedChild.dataset.event) {
                              setEventListeners(appendedChild);
                          };
                          if (appendedChild.childElementCount > 0) {
                              let childrenNeedingEvents = appendedChild.querySelectorAll('[data-event]');
                              childrenNeedingEvents.forEach(child => setEventListeners(child));
                          };
                          appendedChild = appendedChild.nextElementSibling;
                      };
                      outputChild.remove();
                  };
              } else {
                  const mastid = outputChild.dataset.mastid;
                  let existentNode = document.querySelector(`[data-mastid="${mastid}"]`);
                  existentNode.replaceWith(outputChild);
                  let replacedNode = document.querySelector(`[data-mastid="${mastid}"]`);
                  if (replacedNode.dataset.event) {
                      setEventListeners(replacedNode);
                  };
                  if (replacedNode.childElementCount > 0) {
                      let childrenNeedingEvents = replacedNode.querySelectorAll('[data-event]');
                      childrenNeedingEvents.forEach(child => setEventListeners(child));
                  };
              };
          };
      } catch (error) {
          console.error(error);
      };
  };
  '''
--