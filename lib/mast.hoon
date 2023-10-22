/+  server
|%
+$  yard  [url=@t sail=gate]
+$  yards  (list yard)
+$  parsed-request  [tags=@tas data=(list [@t @t])]
+$  gust-action  ?(%page %update)
+$  gust-sample  $%([%manx manx] [%marl marl])
+$  card  card:agent:gall
:: :: :: ::
::
::  Server 
::
:: :: :: ::
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
  |*  [=yards target-url=@t app-state=*]
  ?~  yards
    (set-ids (manx sail-404))
  ?:  =(target-url url.i.yards)
    =/  rigged-sail  (set-ids (manx (sail.i.yards app-state)))
    rigged-sail(a.g (mart [[%data-url (trip target-url)] a.g.rigged-sail]))
  $(yards t.yards)
::
++  gust
  |=  [=gust-action eyreid=@ta current-display-state=manx new-display-state=manx]
  ^-  (list card)
  ?~  c.new-display-state  !!
  ?~  t.c.new-display-state  !!
  ?~  c.current-display-state  !!
  ?~  t.c.current-display-state  !!
  ?~  a.g.new-display-state  !!
  %+  make-html-200  eyreid 
  :-  ~
  %-  manx-to-octs:server
  ^-  manx
  ?-  gust-action
    %page
      %=  new-display-state
        c.i.c  (marl [script-node c.i.c.new-display-state])
      ==
    %update
      ;output
        =data-url  v.i.a.g.new-display-state
        ;*  %+  gust-algo
          [%manx i.t.c.current-display-state]
        [%manx i.t.c.new-display-state]
      ==
  ==
::
++  make-html-200
  |=  [eyreid=@ta resdata=(unit octs)]
  ^-  (list card)
  =/  reshead  [200 ['Content-Type' 'text/html'] ~]
  %+  give-simple-payload:app:server 
    eyreid 
  ^-(simple-payload:http [reshead resdata])
::
++  make-css-response
  |=  [eyreid=@ta css=@t]
  ^-  (list card)
  =/  reshead  [200 ['Content-Type' 'text/css'] ~]
  %+  give-simple-payload:app:server 
    eyreid 
  ^-(simple-payload:http [reshead [~ (as-octs:mimes:html css)]])
::
++  make-auth-redirect
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
:: :: :: ::
::
::  Sail 
::
:: :: :: ::
++  script-node
  ^-  manx
  ;script
    ;+  ;/  script
  ==
++  sail-404
  ^-  manx
  ;html
    ;head
      ;meta(charset "utf-8");
    ==
    ;body
      ;span: 404
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
      const eventType = el.dataset.event.split('-', 1)[0];
      el.addEventListener(eventType, (e) => urbitEvent(e, el.dataset.event, el.dataset.return));
  };
  async function urbitEvent(event, tagString, dataString) {
      try {
          let data = [];
          if (dataString) {
              const dataToReturn = dataString.split(/\s+/);
              dataToReturn.forEach(dataTag => {
                  const [kind, key] = dataTag.split(/-(.*)/, 2);
                  if (kind === 'event') {
                      if (!(key in event)) {
                          console.error(`Property: ${key} does not exist on the event object`);
                          return;
                      };
                      data.push([dataTag, String(event[key])]);
                  } else if (kind === 'target') {
                      if (!(key in event.currentTarget)) {
                          console.error(`Property: ${key} does not exist on the target object`);
                          return;
                      };
                      data.push([dataTag, String(event.currentTarget[key])]);
                  } else if (kind.startsWith('#')) {
                      const splitTag = dataTag.slice(1).split('-');
                      const keyWithDashCheck = splitTag.pop();
                      const elementId = splitTag.join('-');
                      const linkedEl = document.getElementById(elementId);
                      if (!linkedEl) {
                          console.error(`No element found for id: ${kind}`);
                          return;
                      };
                      if (!(keyWithDashCheck in linkedEl)) {
                          console.error(`Property: ${keyWithDashCheck} does not exist on the object with id: ${kind}`);
                          return;
                      };
                      data.push([dataTag, String(linkedEl[keyWithDashCheck])]);
                  } else {
                      console.error(`Invalid return data tag: ${dataTag}`);
                  };
              });
          };
          const response = await fetch(window.location.href, {
              method: 'POST',
              body: JSON.stringify({
                  tags: tagString,
                  data
              })
          });
          const htmlData = await response.text();
          if (!htmlData) return;
          let container = document.createElement('template');
          container.innerHTML = htmlData;
          const navUrl = container.content.firstElementChild.dataset.url;
          if (navUrl && (navUrl !== window.location.pathname)) {
              history.pushState({}, '', navUrl);
          };
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