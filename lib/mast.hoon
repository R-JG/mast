|%
+$  yard  [url=@t sail=gate]
+$  yards  (list yard)
+$  parsed-request  [tags=path data=(map @t @t)]
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
  %-  (ot ~[tags+pa data+(om so)]):dejs:format  j
::
++  rig
  |*  [=yards target-url=@t app-state=*]
  ?~  yards
    (add-keys (manx sail-404))
  ?:  =(target-url url.i.yards)
    =/  rigged-sail  (add-keys (manx (sail.i.yards app-state)))
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
  ;g
    =data-url  v.i.a.g.new-display-state
    ;*  %+  gust-algo
      c.i.t.c.current-display-state
    c.i.t.c.new-display-state
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
  |=  [old=marl new=marl]
  ^-  marl
  =/  i=@ud  0
  =/  acc=marl  ~
  |-
  ?~  new
    ?.  =(~ old)
      ?:  =(%skip -.-.-.old)
        $(old +.old)
      :_  acc
      :_  ~
      :-  %d
      =/  c=@ud  0
      |-  ^-  mart
      ?~  old
        ~
      :-  :-  (crip (weld "data-d" <c>)) 
        (getv a.g.i.old %data-key)
      $(old t.old, c +(c))
    acc
  ?:  &(?=(^ old) =(%skip -.-.-.old))
    $(old t.old)
  ?:  =(%m n.g.i.new)
    $(new t.new, i +(i), acc (snoc acc i.new))
  =/  j=@ud  0
  =/  jold=marl  old
  =/  nkey=tape  (getv a.g.i.new %data-key)
  |-
  ?~  new
    !!
  ?~  jold
    %=  ^$
      new  t.new
      i    +(i)
      acc  %+  snoc  acc
        ;n(id <i>)
          ;+  i.new
        ==
    ==
  ?~  old
    !!
  ?:  =(%skip n.g.i.jold)
    $(jold t.jold, j +(j))
  ?:  .=(nkey (getv a.g.i.jold %data-key))
    ?.  =(0 j)
      =/  n=@ud  0
      =/  nnew=marl  new
      =/  okey=tape  (getv a.g.i.old %data-key)
      |-
      ?~  nnew
        ^^$(old (snoc t.old i.old))
      ?:  =(%m n.g.i.nnew)
        $(nnew t.nnew, n +(n))
      =/  nney=tape  (getv a.g.i.nnew %data-key)
      ?.  .=(okey nney)
        $(nnew t.nnew, n +(n))
      ?:  (gte n j)
        ?:  =(g.i.old g.i.nnew)
          %=  ^^$
            old  c.i.old
            new  c.i.nnew
            i    0
            acc  
              %=  ^^$
                old  t.old
                new  (newm new n ;m(id <(add n i)>, data-key nney);)
              ==
          ==
        %=  ^^$
          old  t.old
          new  %^  newm  new  n
            ;m(id <(add n i)>)
              ;+  i.nnew
            ==
        ==
      ?:  =(g.i.jold g.i.new)
        %=  ^^$
          old  c.i.jold
          new  c.i.new
          i    0
          acc  
            %=  ^^$
              old  (newm old j ;skip;)
              new  t.new
              i    +(i)
              acc  %+  snoc  acc
                ;m(id <i>, data-key nkey);
            ==
        ==
      %=  ^^$
        old  (newm old j ;skip;)
        new  t.new
        i    +(i)
        acc  %+  snoc  acc
          ;m(id <i>)
            ;+  i.new
          ==
      ==
    ?:  =(g.i.old g.i.new)
      ?:  =("mast-text" (getv a.g.i.new %class))
        ?:  =(+.-.+.-.-.+.-.old +.-.+.-.-.+.-.new)
          ^$(old t.old, new t.new, i +(i))
        %=  ^$
          old  t.old
          new  t.new
          i    +(i)
          acc  [i.new acc]
        ==
      %=  ^$
        old  c.i.old
        new  c.i.new
        i    0
        acc  ^$(old t.old, new t.new, i +(i))
      ==
    %=  ^$
      old  t.old
      new  t.new
      i    +(i)
      acc  [i.new acc]
    ==
  $(jold t.jold, j +(j))
::
++  add-keys
  |=  root=manx
  |^  ^-  manx
  (tanx root "0" "~")
  ++  tanx
    |=  [m=manx key=tape pkey=tape]
    =/  fkey=tape  (getv a.g.m %data-key)
    =/  nkey=tape  ?~(fkey key fkey)
    ?:  =(%$ n.g.m)
      ;span.mast-text
        =data-key  nkey
        =data-parent  pkey
        ;+  m
      ==
    =:  a.g.m  %-  mart  
          ?~  fkey
            [[%data-key nkey] [[%data-parent pkey] a.g.m]]
          [[%data-parent pkey] a.g.m]
        c.m  (tarl c.m nkey)
    ==
    m
  ++  tarl
    |=  [m=marl key=tape]
    =/  i=@ud  0
    |-  ^-  marl
    ?~  m
      ~
    :-  %^  tanx  
          (manx i.m) 
        (weld (scow %ud i) (weld "-" key))
      key
    $(m t.m, i +(i))
  --
::
++  getv
  |=  [m=mart tag=@tas]
  ^-  tape
  ?~  m
    ~
  ?:  =(n.i.m tag)
    v.i.m
  $(m t.m)
++  newm
  |=  [ml=marl i=@ud mx=manx]
  =/  j=@ud  0
  |-  ^-  marl
  ?~  ml
    ~
  :-  ?:  =(i j)
      mx 
    i.ml 
  $(ml t.ml, j +(j))
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
  function setEventListeners(el) {
      const eventType = el.dataset.event.split('/', 2)[1];
      el.addEventListener(eventType, (e) => pokeShip(e, el.dataset.event, el.dataset.return));
  };
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
  function pokeShip(event, tagString, dataString) {
      try {
          let data = {};
          if (dataString) {
              const dataToReturn = dataString.split(/\s+/);
              dataToReturn.forEach(dataTag => {
                  let splitDataTag = dataTag.split('/');
                  if (splitDataTag[0] === '') splitDataTag.shift();
                  const kind = splitDataTag[0];
                  const key = splitDataTag.pop();
                  if (kind === 'event') {
                      if (!(key in event)) {
                          console.error(`Property: ${key} does not exist on the event object`);
                          return;
                      };
                      data[dataTag] = String(event[key]);
                  } else if (kind === 'target') {
                      if (!(key in event.currentTarget)) {
                          console.error(`Property: ${key} does not exist on the target object`);
                          return;
                      };
                      data[dataTag] = String(event.currentTarget[key]);
                  } else {
                      const elementId = splitDataTag.join('/');
                      const linkedEl = document.getElementById(elementId);
                      if (!linkedEl) {
                          console.error(`No element found for id: ${kind}`);
                          return;
                      };
                      if (!(key in linkedEl)) {
                          console.error(`Property: ${key} does not exist on the object with id: ${elementId}`);
                          return;
                      };
                      data[dataTag] = String(linkedEl[key]);
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
              if (outputChild.tagName === 'D') {
                  for (const dkey of Object.values(outputChild.dataset)) {
                      document.querySelector(`[data-key="${dkey}"]`).remove();
                  };
                  outputChild.remove();
              } else if (outputChild.tagName === 'N') {
                  const nodeKey = outputChild.firstElementChild.dataset.key;
                  const parentKey = outputChild.firstElementChild.dataset.parent;
                  const appendIndex = outputChild.id;
                  let domParent = document.querySelector(`[data-key="${parentKey}"]`);
                  domParent.insertBefore(outputChild.firstElementChild, domParent.children[appendIndex]);
                  let appendedChild = domParent.querySelector(`[data-key="${nodeKey}"]`);
                  if (appendedChild.dataset.event) {
                      setEventListeners(appendedChild);
                  };
                  if (appendedChild.childElementCount > 0) {
                      let needingListeners = appendedChild.querySelectorAll('[data-event]');
                      needingListeners.forEach(child => setEventListeners(child));
                  };
                  appendedChild = appendedChild.nextElementSibling;
                  outputChild.remove();
              } else if (outputChild.tagName === 'M') {
                  const needsUpdate = outputChild.hasChildNodes();
                  const nodeKey = needsUpdate 
                    ? outputChild.firstElementChild.dataset.key 
                    : outputChild.dataset.key;
                  const nodeIndex = outputChild.id;
                  let existentNode = document.querySelector(`[data-key="${nodeKey}"]`);
                  let parentNode = existentNode.parentElement;
                  let childAtIndex = parentNode.children[nodeIndex];
                  parentNode.insertBefore(existentNode, childAtIndex);
                  if (needsUpdate) {
                      let movedNode = parentNode.querySelector(`[data-key="${nodeKey}"]`);
                      movedNode.replaceWith(outputChild.firstElementChild);
                      let replacedNode = parentNode.querySelector(`[data-key="${nodeKey}"]`);
                      if (replacedNode.dataset.event) {
                          setEventListeners(replacedNode);
                      };
                      if (replacedNode.childElementCount > 0) {
                          let needingListeners = replacedNode.querySelectorAll('[data-event]');
                          needingListeners.forEach(child => setEventListeners(child));
                      };
                  };
                  outputChild.remove();
              } else {
                  const nodeKey = outputChild.dataset.key;
                  let existentNode = document.querySelector(`[data-key="${nodeKey}"]`);
                  existentNode.replaceWith(outputChild);
                  let replacedNode = document.querySelector(`[data-key="${nodeKey}"]`);
                  if (replacedNode.dataset.event) {
                      setEventListeners(replacedNode);
                  };
                  if (replacedNode.childElementCount > 0) {
                      let needingListeners = replacedNode.querySelectorAll('[data-event]');
                      needingListeners.forEach(child => setEventListeners(child));
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