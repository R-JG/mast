/-  mast
=<
^-  kook:neo
|%
++  state  pro/%sig
++  poke   (sy %eyre-task %eyre-chan-task ~)
++  kids   ~
++  deps   ~
++  form
  ^-  form:neo
  |_  [=bowl:neo =aeon:neo =pail:neo]
  ::
  ++  init
    |=  pal=(unit pail:neo)
    ^-  (quip card:neo pail:neo)
    ?>  ?=(^ pal)
    =+  !<(init:mast q.u.pal)
    
    =/  =pith:neo  #/[p/our.bowl]/$/eyre
    =/  =binding:eyre  [~ [%mast-test ~]]
    =/  =req:eyre:neo  [%connect binding here.bowl]

    :_  sig/!>(~)
    :~  [pith %poke eyre-req/!>(req)]  :: bind the given url with eyre
    ==
  ::
  ++  poke
    |=  [sud=stud:neo vaz=vase]
    ^-  (quip card:neo pail:neo)
    ?+  sud  ~|(bad-stud/sud !!)
      ::
        %eyre-task
      =+  !<([rid=@ta req=inbound-request:eyre] vaz)
      :: ?.  authenticated.req
      
      ?+  method.request.req  
          %'GET'

      ==
      ::
        %eyre-chan-task
      =+  !<(jon=json vaz)

      ::
    ==
  ::
  --
--
::
|%
::

::
--
