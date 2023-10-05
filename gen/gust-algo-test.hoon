:-  %say
|=  *
:-  %noun
=<
(algo doc1 doc2)
|%
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  doc1
  ;div#test(style "color:red")
    ;div#childone;
  ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  doc2
  ;div#test(style "color:red")
    ;div#new;
    ;button;
  ==
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
++  algo
  |=  [old=manx new=manx]
  :: are the current node values as such both null?
  ?:  ?&(=(old ~) =(new ~))
    %both-nodes-null
  :: are the current node tags equal?
  ?.  =(g.old g.new)
  :: if not, then return the new node for the product.
    new
  :: are both node child lists null?
  ?:  ?&(=(c.old ~) =(c.new ~))
    %both-children-null
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
    %both-nodes-null-from-child-list-recursion
  :: is the next node in the old node's child list null while the new node's child list isn't?
  ?~  +3.c.old
    +3.c.new
  :: is the next node in the new node's child list null while the old node's child list isn't?
  ?~  +3.c.new
    [%old-child-nodes-to-delete +3.c.old]
  :: recurse through the child list
  $(c.old +3.c.old, c.new +3.c.new)
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
--