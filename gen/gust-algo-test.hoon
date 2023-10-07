:-  %say
|=  *
:-  %noun
=<
(algo2 [%manx doc1] [%manx doc2])
|%
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  doc1
  ;body
    ;h1: Welcome!
    ;p
      ; Hello, world!
      ; Welcome to my page.
      ;div(style "color:red")
        ; Red div!
        ;div(style "color:green")
          ; Green div!
          ;div(style "color:blue")
            ; Blue div!
          ==
        ==
      ==
      ; Here is an image:
      ;br;
      ;img@"/foopa.png";
    ==
    ;h2: Chungus!
    ;div: beebooba
    ;div(data "test");
  ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  doc2
  ;body
    ;h1: Welcome!
    ;p
      ; Hello, world!
      ; Welcome to my page.
      ;div(style "color:red")
        ; Red div!
        ;div(style "color:green")
          ; Green div!
          ;div(style "color:blue")
            ; Blue div!
            ; Nested Change!
          ==
        ==
      ==
      ; Here is an image:
      ;br;
      ;img@"/foo.png";
    ==
    ;div.newdiv;
  ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:: ++  package
::   |=  base=*
::   =/  accumulator=?(^ ~)  ~
::   |-  
::   ?@  base
::     :-  base  accumulator
::   ?:  ?=(@tas -.-.base)
::     :-  base  accumulator
::   $(base -.base, accumulator $(base +.base))

  :: essential form of binary tree sweep to list:
  :: |=  a=*
  :: =/  lis=(list @)  ~
  :: |-  ^-  (list @)
  :: ?@  a
  ::   [i=a t=lis]
  :: $(lis $(a +.a), a -.a)

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
  ?:  ?&(=(~ +.old) =(~ +.new))
    accumulator
  ?>  =(-.old -.new)
  ?:  =(-.new %marl)
    ?:  ?&(=(~ +.old) .?(+.new))
      :_  accumulator  
        ;div
          new
        ==

  :: this is for handling the child list by recursing through it instead of adding it under a manx placeholder:
  ::  ?:  ?&(=(~ old) .?(new))
  ::    :: note: this is a complicated section, meant for handling a recursive path where old is null and new is either manx or marl.
  ::    :: if marl cannot be a type in the accumulator list, then the product could be a placeholder manx serving as a tag to hold the childlist with all of the new nodes to add:
  ::    :: :_  accumulator  
  ::    ::   ;div
  ::    ::     new (this doesn't directly work, but something similar should)
  ::    ::   ==
  ::    :: otherwise, the pattern here will be to recurse through the rest of the list without changing the old child list, keeping it at null. This has the effect of collecting all of the new manx as manx in the accumulator.
  ::    :: note: this adds the case where old is null and new is manx, so it must be handled.
  ::    ?:  ?=(@tas -.-.new)
  ::      :: if old is null and new is cell, then if new is manx, add new to the accumulator.
  ::      [new accumulator]
  ::    :: else, old is null and new is a list, so recurse into i with new, and without changing old
  ::    $(new i.new, accumulator $(new t.new))
  
    ?:  ?&(.?(+.old) =(~ +.new))
      :: note: the delete tag is formatted as manx to fit into the marl accumulator. 
      :: also, I need to add the locaction data to the delete tag.
      [;/("delete") accumulator]
  
  :: on marl, where neither old nor new are null:
  :: recurse into the child node, and nest recursion the other direction continuing through the list:
  $(old [%manx (manx +2.+.old)], new [%manx (manx +2.+.new)], accumulator $(old [%marl +3.+.old], new [%marl +3.+.new]))


  :: at this point it should be determined that both old and new are manx.  
  :: on manx, determine whether to recurse into the child list:
  ?.  =(+2.+.old +2.+.new)
    [(manx +.new) accumulator]
  :: OLD - recurse into the head of the child list, and nest recursion the other direction into the tail:
  :: $(old i.c.old, new i.c.new, accumulator $(old t.c.old, new t.c.new))

  :: recurse into the child list
  $(old [%marl +3.+.old], new [%marl +3.+.new])
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
--