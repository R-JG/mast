|%
+$  yard  [url=@t sail=gate]
+$  yards  (list yard)
+$  parsed-request  [tags=@tas data=(list [@t @t])]
+$  gust-sample  $%([%manx manx] [%marl marl])
:: :: :: ::
::
::  Server 
::
:: :: :: ::
++  plank
  |=  [eyre-id=@ta ship=@p app-name=tape display-update-path=tape display-state=manx]
  ^-  (list card:agent:gall)
  ?~  c.display-state  !!
  =/  ship-name  (scow %p ship)
  %^  make-direct-http-cards  eyre-id
    [200 ['Content-Type' 'text/html'] ~]
  :-  ~
  ^-  octs
  %-  as-octt:mimes:html
  %-  en-xml:html
  ^-  manx
  %=  display-state
    a.g  %-  mart  :^  
      [%data-ship +.ship-name] 
      [%data-app app-name] 
      [%data-path display-update-path] 
      a.g.display-state
    c.i.c  (marl [script-node c.i.c.display-state])
  ==
::
++  parse
  |=  j=json
  ^-  parsed-request
  %-  (ot ~[tags+so data+(ar (at ~[so so]))]):dejs:format  j
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
  |=  [display-update-path=path current-display-state=manx new-display-state=manx]
  ^-  (list card:agent:gall)
  ?~  c.new-display-state  !!
  ?~  t.c.new-display-state  !!
  ?~  c.current-display-state  !!
  ?~  t.c.current-display-state  !!
  ?~  a.g.new-display-state  !!
  %+  make-channel-update-cards  display-update-path
  %-  en-xml:html
  ^-  manx
  ;output
    =data-url  v.i.a.g.new-display-state
    ;*  %+  gust-algo
      [%manx i.t.c.current-display-state]
    [%manx i.t.c.new-display-state]
  ==
::
++  make-direct-http-cards
  |=  [eyre-id=@ta reshead=response-header.simple-payload:http resdata=(unit octs)]
  ^-  (list card:agent:gall)
  =/  header-cage  [%http-response-header !>(reshead)]
  =/  data-cage  [%http-response-data !>(resdata)]
  :~  [%give %fact ~[/http-response/[eyre-id]] header-cage]
      [%give %fact ~[/http-response/[eyre-id]] data-cage]
      [%give %kick ~[/http-response/[eyre-id]] ~]
  ==
::
++  make-channel-update-cards
  |=  [sub-path=path html-data=tape]
  ^-  (list card:agent:gall)
  =/  data-cage  [%json !>((tape:enjs:format html-data))]
  [[%give %fact ~[sub-path] data-cage] ~]
::
++  make-css-response
  |=  [eyre-id=@ta css=@t]
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards  eyre-id 
    [200 ['Content-Type' 'text/css'] ~]
  [~ (as-octs:mimes:html css)]
::
++  make-auth-redirect
  |=  eyre-id=@ta
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards  eyre-id
    [307 ['Location' '/~/login?redirect='] ~]
  ~
::
++  make-400
  |=  eyre-id=@ta
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards  eyre-id 
    [400 ~]
  ~
::
++  make-404
  |=  [eyre-id=@ta resdata=(unit octs)]
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards  eyre-id
    [404 ~]
  resdata
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
  let ship;
  let app;
  let displayUpdatePath;
  let channelMessageId = 0;
  let eventSource;
  const channelId = `${Date.now()}${Math.floor(Math.random() * 100)}`
  const channelPath = `${window.location.origin}/~/channel/${channelId}`;
  addEventListener('DOMContentLoaded', async () => {
      ship = document.documentElement.dataset.ship;
      app = document.documentElement.dataset.app;
      displayUpdatePath = document.documentElement.dataset.path;
      await connectToShip();
      let eventElements = document.querySelectorAll('[data-event]');
      eventElements.forEach(el => setEventListeners(el));
  });
  async function connectToShip() {
      try {
          const body = JSON.stringify(makeSubscribeBody());
          await fetch(channelPath, { 
              method: 'PUT',
              body
          });
          eventSource = new EventSource(channelPath);
          eventSource.addEventListener('message', handleChannelStream);
      } catch (error) {
          console.error(error);
      };
  };
  function setEventListeners(el) {
      const eventType = el.dataset.event.split('-', 1)[0];
      el.addEventListener(eventType, (e) => pokeShip(e, el.dataset.event, el.dataset.return));
  };
  function pokeShip(event, tagString, dataString) {
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
          fetch(channelPath, {
              method: 'PUT',
              body: JSON.stringify(makePokeBody({
                  tags: tagString,
                  data
              }))
          });
      } catch (error) {
          console.error(error);
      };
  };
  function handleChannelStream(event) {
      try {
          const streamResponse = JSON.parse(event.data);
          if (streamResponse.response !== 'diff') return;
          fetch(channelPath, {
              method: 'PUT',
              body: JSON.stringify(makeAck(streamResponse.id))
          });
          const htmlData = streamResponse.json;
          if (!htmlData) return;
          let container = document.createElement('template');
          container.innerHTML = htmlData;
          if (container.content.firstElementChild.childNodes.length === 0) return;
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
  function makeSubscribeBody() {
      channelMessageId++;
      return [{
          id: channelMessageId,
          action: 'subscribe',
          ship: ship,
          app: app,
          path: displayUpdatePath
      }];
  };
  function makePokeBody(jsonData) {
      channelMessageId++;
      return [{
          id: channelMessageId,
          action: 'poke',
          ship: ship,
          app: app,
          mark: 'json',
          json: jsonData
      }];
  };
  function makeAck(eventId) {
      channelMessageId++;
      return [{
          id: channelMessageId,
          action: 'ack',
          "event-id": eventId
      }];
  };
  '''
--