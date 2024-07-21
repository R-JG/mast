/-  mast
=<
^-  kook:neo
|%
++  state  [%pro %sig]
++  poke   (sy %eyre-task %eyre-chan-task %gift ~)
++  kids
  :+  ~  %y
  %-  my
  :~  [[|/%p |] [%pro %sail] (sy %sig ~)]
  ==
++  deps   *deps:neo
++  form
  ^-  form:neo
  |_  [=bowl:neo =aeon:neo =pail:neo]
  ::
  ++  init
    |=  pal=(unit pail:neo)
    ^-  (quip card:neo pail:neo)
    ?>  ?=(^ pal)
    =+  !<(prow:mast q.u.pal)
    =/  =pith:neo      #/[p/our.bowl]/$/eyre
    =/  =binding:eyre  [~ url]
    =/  =req:eyre:neo  [%connect binding here.bowl]
    =/  =rig:mast
      :*  urth
          made
          ~
      ==
    :_  sig/!>(rig)
    :~  [pith %poke eyre-req/!>(req)]
    ==
  ::
  ++  poke
    |=  [sud=stud:neo vaz=vase]
    ^-  (quip card:neo pail:neo)
    =+  !<(=rig:mast q.pail)
    ?+  sud  ~|(bad-stud/sud !!)
      ::
        %eyre-task
      =+  !<([rid=@ta req=inbound-request:eyre] vaz)
      ?.  authenticated.req
        :_  pail
        %-  make-auth-redirect  rid
      ?+  method.request.req  (make-400 rid)
        ::
          %'GET'
        ?.  |(urth:rig =(our.bowl ship.src.bowl))
          (make-403 rid)
        =/  jig=(unit idea:neo)
          (~(get of:neo kids.bowl) (snoc here.bowl ship.src.bowl))
        ?~  jig
          =.  open-http.rig
            (~(put by open-http.rig) ship.src.bowl rid)
          :_  sig/!>(rig)
          :~  [(snoc here.bowl ship.src.bowl) %make made.rig]
          ==
        
        :: else, send a plank response to the client

        ::
      ==
      ::
        %eyre-chan-task
      =+  !<(jon=json vaz)

      :: parse and relay the channel poke as an event poke to the ui shrub by the src included in the json

      ::
        %gift
      
      :: if there is an %add, it means a new session has been spawned;
      :: save the rid and don't close the direct http, 
      :: and then complete the http here (don't forget to delete from open-http)

      :: else for %diff send a gust update with the saved session manx, and then update the session manx

      ::
    ==
  ::
  --
--
::
|%
::
++  make-400
  |=  rid=@ta
  ^-  (list card:neo)
  %^    make-direct-http-cards
      rid
    [400 ~]
  ~
::
++  make-403
  |=  rid=@ta
  ^-  (list card:neo)
  %^    make-direct-http-cards
      rid
    [403 ~]
  ~
::
++  make-auth-redirect
  |=  rid=@ta
  ^-  (list card:neo)
  %^    make-direct-http-cards
      rid
    [307 ['Location' '/~/login?redirect='] ~]
  ~
::
++  make-direct-http-cards
  |=  [rid=@ta hed=response-header:http dat=(unit octs)]
  ^-  (list card:neo)
  =/  eyre=pith:neo  #/[p/orb]/$/eyre
  =/  head=sign:eyre:neo  [rid %head hed]
  =/  data=sign:eyre:neo  [rid %data dat]
  =/  done=sign:eyre:neo  [rid %done ~]
  :~  [eyre %poke eyre-sign/!>(head)]
      [eyre %poke eyre-sign/!>(data)]
      [eyre %poke eyre-sign/!>(done)]
  ==
::
++  gust
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
::
--
