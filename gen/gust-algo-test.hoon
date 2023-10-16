:-  %say
|=  *
:-  %noun
=<
%-  crip
%-  en-xml:html
^-  manx
  ;output
    ;*  (algo2 [%manx (add-mastids-to-manx doc1)] [%manx (add-mastids-to-manx doc2)])
  ==
|%
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  doc1
  ;body
    ;a;
    ;div;
    ;p;
  ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  doc2
  ;body#testid.testclass
    ;a
      ;h1: Hello World
    ==
    ;div;
  ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  algo
  |=  [old=manx new=manx]
  :: are the current node values as such both null?
  ?:  ?&(=(old ~) =(new ~))
    ~
  :: are the current node tags equal?
  ?.  =(g.old g.new)
  :: if not, then return the new node for the product.
    new
  :: are both node child lists null?
  ?:  ?&(=(c.old ~) =(c.new ~))
    ~
  :: is the old node's child list null while the new one's isn't, or vice versa?
  ?:  ?|(=(c.old ~) =(c.new ~))
  :: then return the new node for the product.
    new
  :: begin a sub core to examine the child nodes:
  |-
  :: recurse to the main function going in to the first child node, since we have determined it not empty
  :-  ^$(old +2.c.old, new +2.c.new)
  :: now build the tail of the cell:
  :: these sig checks are base cases for the trap sub-loop
  :: have we reached the end of both old and new node's child lists?
  ?:  ?&(=(+3.c.old ~) =(+3.c.new ~))
    ~
  :: is the next node in the old node's child list null while the new node's child list isn't?
  ?~  +3.c.old
    t.+3.c.new
  :: is the next node in the new node's child list null while the old node's child list isn't?
  ?~  +3.c.new
    ::[%delete +3.c.old]
    ~
  :: recurse through the child list
  $(c.old +3.c.old, c.new +3.c.new)
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
+$  algo-sample
  $%([%manx manx] [%marl marl])

++  algo2
  |=  [old=algo-sample new=algo-sample]
  =/  accumulator=marl  ~
  |-  ^-  marl
  ?>  =(-.old -.new)
  ?:  =(-.new %manx)
    :: both old and new are manx:
    ?.  =(+2.+.old +2.+.new)
      :: if the tags are not equal, add new to the accumulator:
      [(manx +.new) accumulator]
    :: else recurse into the child list
    %=  $
      old  [%marl +3.+.old]
      new  [%marl +3.+.new]
    ==
  :: both old and new are marl:
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
    :: a switch is necessary here to resolve type union issues
    :: produce an output container node with metadata consisting in the ids of the first and last to delete. 
    ?+  -.old  !!
      %marl
        =/  last-child  (get-last-manx +.old)
        =/  id-range 
          %+  weld  
            (get-mastid-from-mart +.-.-.+.old)
          %+  weld  " "  (get-mastid-from-mart +.-.last-child)
        %-  manx  
        ;output#del(data-deleterange id-range);
    ==
  :: both old and new are marl, and neither old nor new are null:
  :: recurse into the child node, and nest recursively in the other direction continuing through the list:
  %=  $ 
    old  [%manx (manx +2.+.old)]
    new  [%manx (manx +2.+.new)]
    accumulator  $(old [%marl +3.+.old], new [%marl +3.+.new])
  ==
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
++  get-mastid-from-mart
  |=  attributes=mart
  ^-  tape
  |-
  ?~  attributes
    attributes
  ?:  =(-.-.attributes %data-mastid)
    +.-.attributes
  $(attributes +.attributes)
  ::
++  add-mastids-to-manx
  |=  main-node=manx
  =/  initial-mastid=tape  "0"
  |^  ^-  manx
  (traverse-node main-node initial-mastid)
  ++  traverse-node
    |=  [node=manx mastid=tape]
    :: if this is a text node, just return the node:
    :: (text nodes cannot contain the mastid attribute)
    ?:  =(%$ -.-.node)
      node
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
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
--