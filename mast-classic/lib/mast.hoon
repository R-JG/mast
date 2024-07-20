:: :: :: ::
::
::  Mast  -  a Sail framework
::
::  [v.1.0.1]
::
::  
::  This library contains a system for building fully dynamic Sail front-ends
::  where all front-end app state and the current state of the display itself
::  live on your ship.
::
::  A small script that is generic to any application is inserted into your Sail
::  and used to establish an Eyre channel, receive display updates from your ship, 
::  and to sync the browser with them.
::  
::  Events on the browser are handled completely within your ship, 
::  without the need to write a single line of JavaScript.
::  You may describe event listeners in your Sail components with attributes like this:
::    =event  "/click/..."
::  The first segment of the path is the event listener name, 
::  with further segments defining an arbitrary endpoint for an event handler on your agent.
::  Events are sent as pokes under a json mark, which can be parsed with the library.
::  You may also return data from the event like this:
::    =return  "/target/value"
::  The first segment is the object to return data from, and the second is the property to return.
::  Data can be returned from the target element, event object, or any other element associated by id.
::  
::  When the display state changes as a result of events initiated on the browser,
::  or from any other kind of event in the agent, updates to the browser containing 
::  only the necessary amount of html to achieve this state are sent and swapped in.
::  
::  
::  The server section contains all of the arms for usage in your app.
::  Rig, plank, and gust are the main arms. See the description of these arms below.
::
::  For more details visit: https://github.com/R-JG/mast
::
:: :: :: ::
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
::
::  - the rig arm is used to produce a new instance of the display state.
::  - "yards" is the list of your app's routes, each corresponding to a root level Sail component
::    (i.e. a complete document with html, head, and body tags).
::  - "url" is either the request url from Eyre in the context of a direct http request,
::    or the current url (this should be saved in state).
::  - "sail-sample" represents the total sample for each of your root level Sail components 
::    (currently, root level Sail components in yards each need to take the same sample).
::  - rig uses the url to select the matching yard and renders its Sail component.
::  - the newly produced display state should then be used with either plank or gust,
::    and saved as the current display state in the agent.
::
++  rig
  |*  [=yards url=path sail-sample=*]
  ^-  view
  ?~  yards
    (adky (manx sail-404))
  =/  yurl=path  url.i.yards
  ?:  |-
      ?~  url
        %.n
      ?~  yurl
        %.n
      ?.  |(=(i.url i.yurl) =(%$ i.yurl))
        %.n
      ?:  &(=(~ t.url) =(~ t.yurl))
        %.y
      $(url t.url, yurl t.yurl)
    =/  rigd  (adky (manx (sail.i.yards sail-sample)))
    rigd(a.g (mart [[%url (path <url>)] a.g.rigd]))
  $(yards t.yards)
::
::  - the plank arm is used for serving whole pages in response to %handle-http-request pokes,
::    acting as the first point of contact for the app.
::  - plank needs to take some basic information about the page that you are serving:
::  - "app" is the name of the app,
::  - "sub" is the subscription path that the client will subscribe to for receiving display updates,
::  - "ship" is your patp,
::  - "rid" is the Eyre id from the %handle-http-request poke,
::  - "new" is the newly rendered display state produced with rig.
::  - plank produces a list of cards serving the http response.
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
::  - the gust arm is used for producing a set of display updates for the browser,
::    used typically after making changes to your app's state, and rendering new display data with rig. 
::  - "sub" is the subscription path that was sent initially in plank, where gust will send the updates.
::  - "old" is the display state that is currently saved in your agent's state, 
::    produced some time previously by rig.
::  - "new" is the new display data to be produced with rig just before gust gets used.
::  - gust can be used anywhere you'd make a subscription update (in contrast to plank).
::  - gust produces a single card.
::  
++  gust
  |=  [sub=path old=view new=view]
  ^-  card:agent:gall
  ?~  c.old  !!
  ?~  c.new  !!
  ?~  t.c.old  !!
  ?~  t.c.new  !!
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
++  parse-url
  |=  url=@t
  ^-  path
  %-  paru  (trip url)
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
::
++  paru
  |=  turl=tape
  ^-  path
  =/  tacc=tape  ~
  =/  pacc=path  ~
  |-
  ?~  turl
    ?~  tacc
      pacc
    (snoc pacc (crip tacc))
  ?:  =('/' i.turl)
    ?~  tacc
      $(turl t.turl)
    %=  $
      turl  t.turl
      tacc  ~
      pacc  (snoc pacc (crip tacc))
    ==
  $(turl t.turl, tacc (snoc tacc i.turl))
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
      eventTags.split(/\s+/).forEach(eventStr => {
          const eventType = eventStr.split('/', 2)[1];
          el[`on${eventType}`] = (e) => pokeShip(e, eventStr, returnTags);
      });
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
                  if (existentNode.nextElementSibling 
                  && (existentNode.nextElementSibling.getAttribute('key') 
                  === childAtIndex.getAttribute('key'))) {
                      existentNode.parentElement.insertBefore(existentNode, childAtIndex.nextElementSibling);
                  } else {
                      existentNode.parentElement.insertBefore(existentNode, childAtIndex);
                  };
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