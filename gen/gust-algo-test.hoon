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
  ?>  =(-.old -.new)
  ?:  =(-.new %marl)
    ?:  ?&(=(~ +.old) =(~ +.new))
      accumulator
    ?:  ?&(=(~ +.old) .?(+.new))
      :_  accumulator  
        %-  manx  
        ;div#new-child-node-collection
          ;*  +.new
        ==
    ?:  ?&(.?(+.old) =(~ +.new))
      [;/("delete") accumulator]
    :: both old and new are marl, and neither old nor new are null:
    :: recurse into the child node, and nest recursion the other direction continuing through the list:
    %=  $ 
      old  [%manx (manx +2.+.old)]
      new  [%manx (manx +2.+.new)]
      accumulator  $(old [%marl +3.+.old], new [%marl +3.+.new])
    ==
  :: both old and new are manx:
  ?.  =(+2.+.old +2.+.new)
    :: if the tags are not equal, add new to the accumulator:
    [(manx +.new) accumulator]
  :: else recurse into the child list
  %=  $
    old  [%marl +3.+.old]
    new  [%marl +3.+.new]
  ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
--