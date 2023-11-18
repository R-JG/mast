|%
+$  view  manx
+$  yard  [url=path sail=gate]
+$  yards  (list yard)
+$  parsed-req  [tags=path data=(map @t @t)]
:: :: :: ::
::
::  Server 
::
:: :: :: ::
++  rig
  |*  [=yards url=path app-state=*]
  ?~  yards
    (adky (manx sail-404))
  ?:  =(url url.i.yards)
    =/  rigd  (adky (manx (sail.i.yards app-state)))
    rigd(a.g (mart [[%url (path <url>)] a.g.rigd]))
  $(yards t.yards)
::
++  plank
  |=  [app=tape sub=path ship=@p rid=@ta new=view]
  ^-  (list card:agent:gall)
  ?~  c.new  !!
  %^  make-direct-http-cards  rid
    [200 ['Content-Type' 'text/html'] ~]
  :-  ~
  ^-  octs
  %-  as-octt:mimes:html
  %-  en-xml:html
  ^-  manx
  %=  new
    a.g  %-  mart  :^  
      [%app app] 
      [%path <(path sub)>]
      [%ship +:(scow %p ship)]
      a.g.new
    c.i.c  (marl [script-node c.i.c.new])
  ==
::
++  gust
  |=  [sub=path old=view new=view]
  ^-  card:agent:gall
  ?~  c.new  !!
  ?~  t.c.new  !!
  ?~  c.old  !!
  ?~  t.c.old  !!
  ?~  a.g.new  !!
  :^  %give  %fact  ~[sub]
  :-  %json
  !>  %-  tape:enjs:format
  %-  en-xml:html
  ^-  manx
  ;g
    =url  v.i.a.g.new
    ;*  %+  algo
      c.i.t.c.old
    c.i.t.c.new
  ==
::
++  parse-json
  |=  j=json
  ^-  parsed-req
  %-  (ot ~[tags+pa data+(om so)]):dejs:format  j
::
++  make-css-response
  |=  [rid=@ta css=@t]
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards  rid 
    [200 ['Content-Type' 'text/css'] ~]
  [~ (as-octs:mimes:html css)]
::
++  make-auth-redirect
  |=  rid=@ta
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards  rid
  [307 ['Location' '/~/login?redirect='] ~]  ~
::
++  make-400
  |=  rid=@ta
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards
  rid  [400 ~]  ~
::
++  make-404
  |=  [rid=@ta data=(unit octs)]
  ^-  (list card:agent:gall)
  %^  make-direct-http-cards
  rid  [404 ~]  data
::
++  make-direct-http-cards
  |=  [rid=@ta head=response-header.simple-payload:http data=(unit octs)]
  ^-  (list card:agent:gall)
  :~  [%give %fact ~[/http-response/[rid]] [%http-response-header !>(head)]]
      [%give %fact ~[/http-response/[rid]] [%http-response-data !>(data)]]
      [%give %kick ~[/http-response/[rid]] ~]
  ==
:: :: :: ::
::
:: Algorithms
::
:: :: :: ::
++  algo
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
      :-  :-  (crip (weld "d" <c>)) 
        (getv a.g.i.old %key)
      $(old t.old, c +(c))
    acc
  ?:  &(?=(^ old) =(%skip -.-.-.old))
    $(old t.old)
  ?:  =(%m n.g.i.new)
    $(new t.new, i +(i), acc (snoc acc i.new))
  =/  j=@ud  0
  =/  jold=marl  old
  =/  nkey=[n=mane k=tape]  [n.g.i.new (getv a.g.i.new %key)]
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
  ?:  .=(nkey [n.g.i.jold (getv a.g.i.jold %key)])
    ?.  =(0 j)
      =/  n=@ud  0
      =/  nnew=marl  new
      =/  okey=[n=mane k=tape]  [n.g.i.old (getv a.g.i.old %key)]
      |-
      ?~  nnew
        ^^$(old (snoc t.old i.old))
      ?:  =(%m n.g.i.nnew)
        $(nnew t.nnew, n +(n))
      =/  nnky=[n=mane k=tape]  [n.g.i.nnew (getv a.g.i.nnew %key)]
      ?.  .=(okey nnky)
        $(nnew t.nnew, n +(n))
      ?:  (gte n j)
        =/  aupd=mart  (upda a.g.i.old a.g.i.nnew)
        ?~  aupd
          %=  ^^$
            old  c.i.old
            new  c.i.nnew
            i    0
            acc
              %=  ^^$
                old  t.old
                new  %^  newm  new  n
                  ;m(id <(add n i)>, key k.nnky);
              ==
          ==
        %=  ^^$
          old  c.i.old
          new  c.i.nnew
          i    0
          acc
            %=  ^^$
              old  t.old
              new  %^  newm  new  n
                ;m(id <(add n i)>, key k.nnky);
              acc  :_  acc
                [[%c [[%key k.nnky] aupd]] ~]
            ==
        ==
      =/  aupd=mart  (upda a.g.i.jold a.g.i.new)
      ?~  aupd
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
                ;m(id <i>, key k.nkey);
            ==
        ==
      %=  ^^$
        old  c.i.jold
        new  c.i.new
        i    0
        acc
          %=  ^^$
            old  (newm old j ;skip;)
            new  t.new
            i    +(i)
            acc  :-  [[%c [[%key k.nkey] aupd]] ~]
              %+  snoc
                acc
              ;m(id <i>, key k.nkey);
          ==
      ==
    ?:  =("text" (getv a.g.i.new %mast))
      ?:  =(+.-.+.-.-.+.-.old +.-.+.-.-.+.-.new)
        ^$(old t.old, new t.new, i +(i))
      %=  ^$
        old  t.old
        new  t.new
        i    +(i)
        acc  [i.new acc]
      ==
    =/  aupd=mart  (upda a.g.i.old a.g.i.new)
    ?~  aupd
      %=  ^$
        old  c.i.old
        new  c.i.new
        i    0
        acc  ^$(old t.old, new t.new, i +(i))
      ==
    %=  ^$
      old  c.i.old
      new  c.i.new
      i    0
      acc
        %=  ^$
          old  t.old
          new  t.new
          i    +(i)
          acc  :_  acc
            [[%c [[%key k.nkey] aupd]] ~]
        ==
    ==
  $(jold t.jold, j +(j))
::
++  adky
  |=  root=manx
  |^  ^-  manx
  (tanx root "0" "~")
  ++  tanx
    |=  [m=manx key=tape pkey=tape]
    =/  fkey=tape  (getv a.g.m %key)
    =/  nkey=tape  ?~(fkey key fkey)
    ?:  =(%$ n.g.m)
      ;span
        =mast  "text"
        =key    nkey
        =pkey   pkey
        ;+  m
      ==
    =:  a.g.m  %-  mart  
          ?~  fkey
            [[%key nkey] [[%pkey pkey] a.g.m]]
          [[%pkey pkey] a.g.m]
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
::
++  upda
  |=  [om=mart nm=mart]
  =/  acc=mart  ~
  |-  ^-  mart
  ?~  nm
    ?~  om
      acc
    :_  acc
    :-  %rem
    =/  omom=mart  om
    |-
    ?~  omom
      ~
    =/  nom=tape  +:<n.i.omom>
    |-
    ?~  nom
      [' ' ^$(omom t.omom)]
    [i.nom $(nom t.nom)]
  =/  i=@ud  0
  =/  com=mart  om
  |-
  ?~  nm
    !!
  ?~  com
    ^$(nm t.nm, acc [i.nm acc])
  ?~  om
    !!
  ?:  =(n.i.com n.i.nm)
    ?:  =(v.i.com v.i.nm)
      ^$(om (oust [i 1] (mart om)), nm t.nm)
    %=  ^$
      om  (oust [i 1] (mart om))
      nm  t.nm
      acc  [i.nm acc]
    ==
  $(com t.com, i +(i))
::
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
  const channelId = `${Date.now()}${Math.floor(Math.random() * 100)}`;
  const channelPath = `${window.location.origin}/~/channel/${channelId}`;
  addEventListener('DOMContentLoaded', async () => {
      ship = document.documentElement.getAttribute('ship');
      app = document.documentElement.getAttribute('app');
      displayUpdatePath = document.documentElement.getAttribute('path');
      await connectToShip();
      let eventElements = document.querySelectorAll('[event]');
      eventElements.forEach(el => setEventListeners(el));
  });
  function setEventListeners(el) {
      const eventTags = el.getAttribute('event');
      const returnTags = el.getAttribute('return');
      const eventType = eventTags.split('/', 2)[1];
      el[`on${eventType}`] = (e) => pokeShip(e, eventTags, returnTags);
  };
  async function connectToShip() {
      try {
          const storageKey = `${ship}${app}${displayUpdatePath}`;
          let storedId = localStorage.getItem(storageKey);
          localStorage.setItem(storageKey, channelId);
          if (storedId) {
              const delPath = `${window.location.origin}/~/channel/${storedId}`;
              await fetch(delPath, {
                  method: 'PUT',
                  body: JSON.stringify([{
                      id: channelMessageId,
                      action: 'delete'
                  }])
              });
          };
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
          const navUrl = container.content.firstElementChild.getAttribute('url');
          if (navUrl && (navUrl !== window.location.pathname)) {
              history.pushState({}, '', navUrl);
          };
          while (container.content.firstElementChild.children.length > 0) {
              let gustChild = container.content.firstElementChild.firstElementChild;
              if (gustChild.tagName === 'D') {
                  for (const att of gustChild.attributes) {
                      const dkey = att.value;
                      document.querySelector(`[key="${dkey}"]`).remove();
                  };
                  gustChild.remove();
              } else if (gustChild.tagName === 'N') {
                  const nodeKey = gustChild.firstElementChild.getAttribute('key');
                  const parentKey = gustChild.firstElementChild.getAttribute('pkey');
                  const appendIndex = gustChild.id;
                  let domParent = document.querySelector(`[key="${parentKey}"]`);
                  domParent.insertBefore(gustChild.firstElementChild, domParent.children[appendIndex]);
                  let appendedChild = domParent.querySelector(`[key="${nodeKey}"]`);
                  if (appendedChild.getAttribute('event')) {
                      setEventListeners(appendedChild);
                  };
                  if (appendedChild.childElementCount > 0) {
                      let needingListeners = appendedChild.querySelectorAll('[event]');
                      needingListeners.forEach(child => setEventListeners(child));
                  };
                  appendedChild = appendedChild.nextElementSibling;
                  gustChild.remove();
              } else if (gustChild.tagName === 'M') {
                  const nodeKey = gustChild.getAttribute('key');
                  const nodeIndex = gustChild.id;
                  let existentNode = document.querySelector(`[key="${nodeKey}"]`);
                  let childAtIndex = existentNode.parentElement.children[nodeIndex];
                  existentNode.parentElement.insertBefore(existentNode, childAtIndex);
                  gustChild.remove();
              } else if (gustChild.tagName === 'C') {
                  const nodeKey = gustChild.getAttribute('key');
                  const attToRem = gustChild.getAttribute('rem')?.slice(0, -1).split(' ') ?? [];
                  let existentNode = document.querySelector(`[key="${nodeKey}"]`);
                  attToRem.forEach(att => {
                      if (att === 'event') {
                          const eventType = existentNode.getAttribute('event').split('/', 2)[1];
                          existentNode[`on${eventType}`] = null;
                      };
                      existentNode.removeAttribute(att);
                  });
                  gustChild.removeAttribute('key');
                  gustChild.removeAttribute('rem');
                  for (const att of gustChild.attributes) {
                      existentNode.setAttribute(att.name, att.value);
                      if (att.name === 'event') {
                          const eventType = existentNode.getAttribute('event').split('/', 2)[1];
                          existentNode[`on${eventType}`] = null;
                          setEventListeners(existentNode);
                      };
                  };
                  gustChild.remove();
              } else {
                  const nodeKey = gustChild.getAttribute('key');
                  let existentNode = document.querySelector(`[key="${nodeKey}"]`);
                  existentNode.replaceWith(gustChild);
                  let replacedNode = document.querySelector(`[key="${nodeKey}"]`);
                  if (replacedNode.getAttribute('event')) {
                      setEventListeners(replacedNode);
                  };
                  if (replacedNode.childElementCount > 0) {
                      let needingListeners = replacedNode.querySelectorAll('[event]');
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