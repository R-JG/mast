/-  neo
/+  *test
=<
|%
::
::   MAST TESTS
::
:: - the diff algorithm in ++luff works on a child-list by child-list basis, 
::   which accumulates accross the tree,
::   so tests for each diff operation only need to pertain to a single child list.
::
:: - adding an explicit key attribute causes a difference in the diff product insofar as
::   identity is able to track independently of location
::   (hoist adds implicit location based keys in the absence of explicit ones),
::   but from the perspective of the diff algorithm,
::   there isn't a distinction between an explicit key attribute or a locational one;
::   elements always have keys which constitute the identities of the elements. 
::   so testing this difference would be redundant.
::   all tests will involve explicit keys because this enables testing the full range of cases.
::
:: - the diff is represented in +$json as an array containing the various diff operations.
:: - top level:         []
:: - new/add:           { p: "n", q: "parent-key", r: index-num, s: "node-html" }
:: - delete:            { p: "d", q: ["node-key", "node-key", ....]}
:: - move:              { p: "m", q: "node-key", r: index-num }
:: - attribute change:  { p: "c", q: "node-key", r: [attr-name-to-remove, ...], s: [["new-attr-name", "new-attr-value"], ...] }
:: - text change:       { p: "t", q: "text-container-key", r: "text to replace in the text node within the container" }
:: - component swap:    { p: "k", q: "component-root-key", r: "node-html" }
::
:: - the component swap case is not a product of the diff algorithm,
::   however, ++luff produces a list of component data from any new component element found,
::   so this will be tested.
::
::
++  sail--base
  ^-  manx
  ;test(key "test")
    ;a(key "test-a", class "a"): test a
    ;b(key "test-b", class "b"): test b
    ;c(key "test-c", class "c"): test c
    ;d(key "test-d", class "d"): test d
  ==
::
++  sail--add
  ^-  manx
  =/  base  sail--base
  =/  new=manx  ;new-element(key "new-element");
  %_  base
    c  (into c.base 2 new)
  ==
::
++  test--diff--add
  %+  expect-eq
  ::
  !>
  ^-  diff
  :-  ~
  ^-  (list json)
  :_  ~
  :-  %o
  %-  my
  :~  ['p' [%s 'n']]
      ['q' [%s 'test']]
      ['r' [%n ~.2]]
      ['s' [%s (crip (en-xml:html `manx`;new-element(key "new-element");))]]
  ==
  ::
  !>  (luff (diff-sample sail--base sail--add))
::
++  sail--delete
  ^-  manx
  =/  base  sail--base
  %_  base
    c  (oust [2 1] c.base)
  ==
::
++  test--diff--delete
  %+  expect-eq
  ::
  !>
  ^-  diff
  :-  ~
  ^-  (list json)
  :_  ~
  :-  %o
  %-  my
  :~  ['p' [%s 'd']]
      ['q' [%a ~[[%s 'test-c']]]]
  ==
  ::
  !>  (luff (diff-sample sail--base sail--delete))
::
++  sail--move
  ^-  manx
  =/  base  sail--base
  =/  el=manx  (snag 2 c.base)
  =.  c.base   (oust [2 1] c.base)
  %_  base
    c  [el c.base]
  ==
::
++  test--diff--move
  %+  expect-eq
  ::
  !>
  ^-  diff
  :-  ~
  ^-  (list json)
  :_  ~
  :-  %o
  %-  my
  :~  ['p' [%s 'm']]
      ['q' [%s 'test-c']]
      ['r' [%n ~.0]]
  ==
  ::
  !>  (luff (diff-sample sail--base sail--move))
::
++  sail--attribute-add
  ^-  manx
  =/  base  sail--base
  =/  el=manx  (snag 2 c.base)
  =.  a.g.el   [[%new "attribute"] a.g.el]
  %_  base
    c  (snap c.base 2 el)
  ==
::
++  test--diff--attribute-add
  %+  expect-eq
  ::
  !>
  ^-  diff
  :-  ~
  ^-  (list json)
  :_  ~
  :-  %o
  %-  my
  :~  ['p' [%s 'c']]
      ['q' [%s 'test-c']]
      ['r' [%a ~]]
      ['s' [%a ~[[%a ~[[%s 'new'] [%s 'attribute']]]]]]
  ==
  ::
  !>  (luff (diff-sample sail--base sail--attribute-add))
::
++  sail--attribute-delete
  ^-  manx
  =/  base  sail--base
  =/  el=manx  (snag 2 c.base)
  =.  a.g.el   (snip a.g.el)
  %_  base
    c  (snap c.base 2 el)
  ==
::
++  test--diff--attribute-delete
  %+  expect-eq
  ::
  !>
  ^-  diff
  :-  ~
  ^-  (list json)
  :_  ~
  :-  %o
  %-  my
  :~  ['p' [%s 'c']]
      ['q' [%s 'test-c']]
      ['r' [%a ~[[%s 'class']]]]
      ['s' [%a ~]]
  ==
  ::
  !>  (luff (diff-sample sail--base sail--attribute-delete))
::
++  sail--text-change
  ^-  manx
  =/  base  sail--base
  =/  el=manx  (snag 2 c.base)
  ?>  &(?=(^ c.el) ?=(%$ n.g.i.c.el) ?=(^ a.g.i.c.el))
  =.  v.i.a.g.i.c.el  "new text"
  %_  base
    c  (snap c.base 2 `manx`el)
  ==
::
++  test--diff--text-change
  %+  expect-eq
  ::
  =/  new=manx  (apply-hoist sail--text-change)
  =/  el=manx   (snag 2 c.new)
  ?>  ?&  ?=(^ c.el)
          ?=(^ a.g.i.c.el)
          ?=(%key n.i.a.g.i.c.el)
      ==
  =/  key  (crip v.i.a.g.i.c.el)
  ::
  !>
  ^-  diff
  :-  ~
  ^-  (list json)
  :_  ~
  :-  %o
  %-  my
  :~  ['p' [%s 't']]
      ['q' [%s key]]
      ['r' [%s 'new text']]
  ==
  ::
  !>  (luff (diff-sample sail--base sail--text-change))
::
++  sail--component
  ^-  manx
  =/  base  sail--base
  =/  new=manx  ;imp_component: /test/pith
  %_  base
    c  (into c.base 2 new)
  ==
::
++  test--diff--component
  %+  expect-eq
  ::
  !>
  ^-  diff
  :-  ~[[%component `pith:neo`/test/pith]]
  ^-  (list json)
  :_  ~
  :-  %o
  %-  my
  :~  ['p' [%s 'n']]
      ['q' [%s 'test']]
      ['r' [%n ~.2]]
      ['s' [%s (crip (en-xml:html (apply-hoist ;imp_component:"/test/pith")))]]
  ==
  ::
  !>  (luff (diff-sample sail--base sail--component))
::
++  sail--assortment
  ^-  manx
  =/  base  sail--base
  :: delete ;a;
  =.  c.base  (oust [0 1] c.base)
  :: add ;e; to the end
  =.  c.base
    %+  snoc  c.base
    ^-  manx
    ;e(key "test-e", class "e"): test e
  :: move ;c; below ;e; and give it a new attribute
  =/  el-c=manx  (snag 1 c.base)
  =.  a.g.el-c   (snoc a.g.el-c [%new "attribute"])
  =.  c.base     (oust [1 1] c.base)
  =.  c.base     (snoc c.base el-c)
  :: change the text node in ;b;
  =/  el-b=manx  (snag 0 c.base)
  ?>  &(?=(^ c.el-b) ?=(%$ n.g.i.c.el-b) ?=(^ a.g.i.c.el-b))
  =.  v.i.a.g.i.c.el-b  "new text"
  =.  c.base     (snap c.base 0 `manx`el-b)
  :: add a component to the beginning
  =.  c.base     [`manx`;imp_component:"/test/pith" c.base]
  base
::
++  test--diff--assortment
  %+  expect-eq
  ::
  =/  new=manx   (apply-hoist sail--assortment)
  =/  el-b=manx  (snag 1 c.new)
  ?>  ?&  ?=(^ c.el-b)
          ?=(^ a.g.i.c.el-b)
          ?=(%key n.i.a.g.i.c.el-b)
      ==
  =/  key-b-txt  (crip v.i.a.g.i.c.el-b)
  =/  el-e=manx  (snag 3 c.new)
  ::
  !>
  ^-  diff
  :-  ~[[%component `pith:neo`/test/pith]]
  ^-  (list json)
  :~  :-  %o
      %-  my
      :~  ['p' [%s 't']]
          ['q' [%s key-b-txt]]
          ['r' [%s 'new text']]
      ==
      ::
      :-  %o
      %-  my
      :~  ['p' [%s 'd']]
          ['q' [%a ~[[%s 'test-a']]]]
      ==
      ::
      :-  %o
      %-  my
      :~  ['p' [%s 'c']]
          ['q' [%s 'test-c']]
          ['r' [%a ~]]
          ['s' [%a ~[[%a ~[[%s 'new'] [%s 'attribute']]]]]]
      ==
      ::
      :-  %o
      %-  my
      :~  ['p' [%s 'n']]
          ['q' [%s 'test']]
          ['r' [%n ~.0]]
          ['s' [%s (crip (en-xml:html (apply-hoist ;imp_component:"/test/pith")))]]
      ==
      ::
      :-  %o
      %-  my
      :~  ['p' [%s 'n']]
          ['q' [%s 'test']]
          ['r' [%n ~.3]]
          ['s' [%s (crip (en-xml:html el-e))]]
      ==
      ::
      :-  %o
      %-  my
      :~  ['p' [%s 'm']]
          ['q' [%s 'test-c']]
          ['r' [%n ~.04]]  :: 0 because printed with y-co:co ...
      ==
  ==
  ::
  !>  (luff (diff-sample sail--base sail--assortment))
::  ::  ::  ::  ::
++  apply-hoist
  |=  m=manx
  ^-  manx
  (~(anx hoist 0 0 *@p m) m ~ ~)
::
++  diff-sample
  |=  [old=manx new=manx]
  ^-  [manx manx]
  [(apply-hoist old) (apply-hoist new)]
::
--
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::
  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::
::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::  ::
|%
::
+$  view  @tas                     :: view imp
+$  bind  [=view src=pith:neo]     :: view to src binding
+$  rope  @                        :: view+src bind id (mug bind)
+$  buoy  @                        :: channel subscription id (mug [rope boat])
+$  boat  @p                       :: src ship session id
+$  sail  manx
+$  diff  (pair (list bind) (list json))
::
++  hoist                          :: process sail
  |_  [=buoy =rope =boat =sail]
  ++  $
    ^-  manx
    =/  root-key=tape  (y-co:co buoy)
    ?.  =(%html n.g.sail)
      %+  anx
        sail(a.g (prepare-root-mart rope a.g.sail))
      [root-key ~]
    =/  i=@       (get-el-index %body c.sail)
    =/  bod=manx  (snag i c.sail)
    %_    sail
        c
      %^    snap
          c.sail
        i
      %+  anx
        bod(a.g (prepare-root-mart rope a.g.bod))
      [root-key ~]
    ==
  ++  anx
    |=  [m=manx key=(pair tape (list @))]
    ^-  manx
    =/  fkey=@t  (getv %key a.g.m)
    =/  nkey=(pair tape (list @))  ?~(fkey key [((w-co:co 1) `@uw`(mug fkey)) ~])
    =/  ntap=tape
      ?~  q.nkey  p.nkey
      (weld p.nkey ((w-co:co 1) `@uw`(jam q.nkey)))
    ?:  ?&  ?=([%imp @] n.g.m)
            ?=(^ c.m)  ?=(^ a.g.i.c.m)
        ==
      =/  =view         +.n.g.m
      =/  src=pith:neo  (pave:neo (stab (crip v.i.a.g.i.c.m)))
      =/  imp-rope      (mug view src)
      =/  imp-buoy      (mug [imp-rope boat])
      %_    m
          a.g
        :~  [%key (y-co:co imp-buoy)]
            [%rope (y-co:co imp-rope)]
        ==
      ==
    ?:  =(%$ n.g.m)
      ;t-
        =key  ntap
        ;+  m
      ==
    %_    m
        a.g
      ^-  mart  
      ?~  fkey
        [[%key ntap] a.g.m]
      a.g.m
        c
      ?:  ?|  =(%input n.g.m)  =(%textarea n.g.m)
              =(%script n.g.m)  =(%img n.g.m)
              =(%link n.g.m)  =(%hr n.g.m)
              =(%meta n.g.m)  =(%base n.g.m)
          ==
        c.m
      (arl c.m nkey)
    ==
  ++  arl
    |=  [m=marl key=(pair tape (list @))]
    =|  i=@
    |-  ^-  marl
    ?~  m  ~
    :-  %+  anx
          i.m
        key(q [i q.key])
    $(m t.m, i +(i))
  --
::
++  luff                           :: produce a sail diff
  |=  [oldx=manx newx=manx]
  =/  [old=marl new=marl]
    :-  ?.  =(%html n.g.oldx)
          [oldx ~]
        [(snag (get-el-index %body c.oldx) c.oldx) ~]
    ?.  =(%html n.g.newx)
      [newx ~]
    [(snag (get-el-index %body c.newx) c.newx) ~]
  =|  i=@ud
  =|  pkey=@t
  =|  acc=diff
  |-  ^-  diff
  ?~  new
    ?~  old
      acc
    ?:  =(%skip- n.g.i.old)
      %=  $
        old  t.old
      ==
    %_    acc
        q
      :_  q.acc
      ^-  json
      :-  %o
      %-  my
      :~  ['p' [%s 'd']]
          ['q' [%a (turn old |=(m=manx [%s (getv %key a.g.m)]))]]
      ==
    ==
  ?:  =(%$ n.g.i.new)
    acc
  ?:  &(?=(^ old) =(%skip- n.g.i.old))
    %=  $
      old  t.old
    ==
  ?:  =(%move- n.g.i.new)
    %=  $
      new  t.new
      i    +(i)
      q.acc
        %+  snoc  q.acc
        ^-  json
        :-  %o
        %-  my
        :~  ['p' [%s 'm']]
            ['q' [%s (getv %key a.g.i.new)]]
            ['r' [%n (getv %i a.g.i.new)]]
        ==
    ==
  =|  j=@ud
  =/  jold=marl  old
  =/  nkey=[n=mane k=@t]  [n.g.i.new (getv %key a.g.i.new)]
  |-  ^-  diff
  ?~  new
    !!
  ?~  jold
    %=  ^$
      new  t.new
      i    +(i)
      p.acc
        ?.  |(?=([%imp @] n.g.i.new) ?=(^ c.i.new))
          p.acc
        (weld p.acc (find-imp-els i.new))
      q.acc
        %+  snoc  q.acc
        ^-  json
        :-  %o
        %-  my
        :~  ['p' [%s 'n']]
            ['q' [%s pkey]]
            ['r' [%n (scot %ud i)]]
            ['s' [%s (crip (en-xml:html i.new))]]
        ==
    ==
  ?~  old
    !!
  ?:  =(%skip- n.g.i.jold)
    %=  $
      jold  t.jold
      j     +(j)
    ==
  ?:  =(nkey [n.g.i.jold (getv %key a.g.i.jold)])
    ?.  =(0 j)
      =|  n=@ud
      =/  nnew=marl  new
      =/  okey=[n=mane k=@t]  [n.g.i.old (getv %key a.g.i.old)]
      |-  ^-  diff
      ?~  nnew
        %=  ^^$
          old  (snoc t.old i.old)
        ==
      ?:  =(%move- n.g.i.nnew)
        %=  $
          nnew  t.nnew
          n     +(n)
        ==
      =/  nnky=[n=mane k=@t]  [n.g.i.nnew (getv %key a.g.i.nnew)]
      ?.  =(okey nnky)
        %=  $
          nnew  t.nnew
          n     +(n)
        ==
      ?:  (gte n j)
        =/  aupd  (upda a.g.i.old a.g.i.nnew)
        %=  ^^$
          old   c.i.old
          new   c.i.nnew
          pkey  k.nnky
          i     0
          acc
            %=  ^^$
              old  t.old
              new
                %^  newm  new  n
                ;move-(i (y-co:co (add n i)), key (trip k.nnky));
              q.acc
                ?:  &(?=(~ del.aupd) ?=(~ new.aupd))
                  q.acc
                :_  q.acc
                ^-  json
                :-  %o
                %-  my
                :~  ['p' [%s 'c']]
                    ['q' [%s k.nnky]]
                    ['r' [%a del.aupd]]
                    ['s' [%a new.aupd]]
                ==
            ==
        ==
      =/  aupd  (upda a.g.i.jold a.g.i.new)
      %=  ^^$
        old   c.i.jold
        new   c.i.new
        pkey  k.nkey
        i     0
        acc
          %=  ^^$
            old  (newm old j ;skip-;)
            new  t.new
            i    +(i)
            q.acc
              =.  q.acc
                %+  snoc  q.acc
                ^-  json
                :-  %o
                %-  my
                :~  ['p' [%s 'm']]
                    ['q' [%s k.nkey]]
                    ['r' [%n (scot %ud i)]]
                ==
              ?:  &(?=(~ del.aupd) ?=(~ new.aupd))
                q.acc
              :_  q.acc
              ^-  json
              :-  %o
              %-  my
              :~  ['p' [%s 'c']]
                  ['q' [%s k.nkey]]
                  ['r' [%a del.aupd]]
                  ['s' [%a new.aupd]]
              ==
          ==
      ==
    ?:  =(%t- n.g.i.new)
      ?:  ?&  ?=(^ c.i.old)  ?=(^ c.i.new)
              ?=(^ a.g.i.c.i.old)  ?=(^ a.g.i.c.i.new)
              =(v.i.a.g.i.c.i.old v.i.a.g.i.c.i.new)
          ==
        %=  ^$
          old  t.old
          new  t.new
          i    +(i)
        ==
      =/  txt=@t
        ?.  &(?=(^ c.i.new) ?=(^ a.g.i.c.i.new))
          ''
        (crip v.i.a.g.i.c.i.new)
      %=  ^$
        old  t.old
        new  t.new
        i    +(i)
        q.acc
          :_  q.acc
          ^-  json
          :-  %o
          %-  my
          :~  ['p' [%s 't']]
              ['q' [%s (getv %key a.g.i.new)]]
              ['r' [%s txt]]
          ==
      ==
    =/  aupd  (upda a.g.i.old a.g.i.new)
    %=  ^$
      old   c.i.old
      new   c.i.new
      pkey  k.nkey
      i     0
      acc
        %=  ^$
          old  t.old
          new  t.new
          i    +(i)
          q.acc
            ?:  &(?=(~ del.aupd) ?=(~ new.aupd))
              q.acc
            :_  q.acc
            ^-  json
            :-  %o
            %-  my
            :~  ['p' [%s 'c']]
                ['q' [%s k.nkey]]
                ['r' [%a del.aupd]]
                ['s' [%a new.aupd]]
            ==
        ==
    ==
  %=  $
    jold  t.jold
    j     +(j)
  ==
::
++  getv
  |=  [t=@tas m=mart]
  ^-  @t
  ?~  m  ''
  ?:  =(n.i.m t)
    (crip v.i.m)
  $(m t.m)
::
++  upda                           :: produce an attribute list diff
  |=  [om=mart nm=mart]
  =|  acc=[del=(list json) new=(list json)]
  |-  ^+  acc
  ?~  nm
    ?~  om
      acc
    %_    acc
        del
      %+  turn  om
      |=  [n=mane *]
      [%s `@t`?>(?=(@ n) n)]
    ==
  =|  i=@ud
  =/  com=mart  om
  |-  ^+  acc
  ?~  nm
    !!
  ?~  com
    %=  ^$
      nm  t.nm
      new.acc
        :_  new.acc
        :-  %a
        :~  [%s `@t`?>(?=(@ n.i.nm) n.i.nm)]
            [%s (crip v.i.nm)]
        ==
    ==
  ?~  om
    !!
  ?:  =(n.i.com n.i.nm)
    ?:  =(v.i.com v.i.nm)
      %=  ^$
        om  (oust [i 1] (mart om))
        nm  t.nm
      ==
    %=  ^$
      om   (oust [i 1] (mart om))
      nm   t.nm
      new.acc
        :_  new.acc
        :-  %a
        :~  [%s `@t`?>(?=(@ n.i.nm) n.i.nm)]
            [%s (crip v.i.nm)]
        ==
    ==
  %=  $
    com  t.com
    i    +(i)
  ==
::
++  newm
  |=  [ml=marl i=@ud mx=manx]
  =|  j=@ud
  |-  ^-  marl
  ?~  ml
    ~
  :-  ?:  =(i j)
        mx
      i.ml
  $(ml t.ml, j +(j))
::
++  get-el-index
  |=  [n=@tas m=marl]
  =|  i=@
  |-  ^-  @
  ?~  m  ~|(missing-element/n !!)
  ?:  =(n n.g.i.m)  i
  $(m t.m, i +(i))
::
++  find-imp-els
  |=  m=manx
  =|  acc=(list bind)
  |-  ^-  (list bind)
  ?:  ?&  ?=([%imp @] n.g.m)
          ?=(^ c.m)  ?=(^ a.g.i.c.m)
      ==
    :_  acc
    :-  +.n.g.m
    (pave:neo (stab (crip v.i.a.g.i.c.m)))
  |-  ^-  (list bind)
  ?~  c.m  acc
  $(c.m t.c.m, acc ^$(m i.c.m))
::
++  prepare-root-mart
  |=  [=rope m=mart]
  ^-  mart
  :-  [%rope (y-co:co rope)]
  |-  ^-  mart
  ?~  m  ~
  ?:  |(=(%key n.i.m) =(%rope n.i.m))
    $(m t.m)
  [i.m $(m t.m)]
::
--
