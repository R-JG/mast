|%  ::  keel  deck  hull  spar  yard  
::
+$  prow                ::  ::  ::  mast init data
  $:  urth=?            ::  > are you serving to earth?
      url=path          ::  > the base url that mast will bind with eyre
      =made:neo         ::  > the +$made mast uses to spawn your ui shrubs
  ==
::
+$  rig
  $:  urth=?
      =made:neo
      open-http=(map @p @ta)  :: eyre ids of http requests pending session creation
      sessions=(map @p manx)  :: does saga make this redundant?
  ==
::
--
