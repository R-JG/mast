:-  %say
|=  *
:-  %noun
=<
(algo2 doc1 doc2)
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
    ;div(data "delete this mf div");
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
            ; Sike!
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
++  algo2
  |=  [old=?(manx marl) new=?(manx marl)]
  :: note: the type is changed from a type union of manx marl and tas, to just marl, in order to resolve recursive type issues:
  =/  accumulator=marl  ~
  ^-  marl
  |-  
  :: check whether on marl, and whether the current values are null.
  ?:  ?&(=(~ old) =(~ new))
    accumulator
  ?:  ?&(=(~ old) .?(new))
    :: note: this is a complicated section, meant for handling a recursive path where old is null and new is either manx or marl.
    :: if marl cannot be a type in the accumulator list, then the product could be a placeholder manx serving as a tag to hold the childlist with all of the new nodes to add:
    :: :_  accumulator  
    ::   ;div
    ::     new
    ::   ==
    :: otherwise, the pattern here will be to recurse through the rest of the list without changing the old child list, keeping it at null. This has the effect of collecting all of the new manx as manx in the accumulator.
    :: note: this adds the case where old is null and new is manx, so it must be handled.
    ?:  ?=(@tas -.-.new)
      :: if old is null and new is cell, then if new is manx, add new to the accumulator.
      [new accumulator]
    :: else, old is null and new is a list, so recurse into i with new, and without changing old
    $(new i.new, accumulator $(new t.new))
    ::
  ?:  ?&(.?(old) =(~ new))
    :: note: the delete tag is formatted as manx to fit into the marl accumulator. 
    :: also, I need to add the locaction data to the delete tag.
    [;/("delete") accumulator]
  
  :: if neither old nor new are null, ensure that they are both only either manx or marl; this should never happen in the algorithm.
  ?.  ?|(?&(?=(@tas -.-.old) ?!(?=(@tas -.-.new))) ?&(?=(@tas -.-.new) ?!(?=(@tas -.-.old))))
    accumulator
  ?:  ?|(?=(@tas -.-.old) ?=(@tas -.-.new))
    :: on marl, where neither old nor new are null:
    $(old i.old, new i.new, accumulator $(old t.old, new t.new))
  :: on manx, determine whether to recurse into the child list:
  ?.  =(g.old g.new)
    [g.new accumulator]
  :: I think these null checks are now redundant after adding the necessary current value null checks...
  :: ?:  ?&(=(~ c.old) =(~ c.new))
  ::   accumulator
  :: ?:  ?&(=(~ c.old) .?(c.new))
  ::   [c.new accumulator]
  :: ?:  ?&(.?(c.old) =(~ c.new))
  ::   [%delete accumulator]
  :: recurse into the head of the child list, and nest recursion the other direction into the tail:
  $(old i.c.old, new i.c.new, accumulator $(old t.c.old, new t.c.new))
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
--