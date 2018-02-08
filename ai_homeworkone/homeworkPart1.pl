%arcing function to find all children and cost of the nodes so far
arc([CurrentNode,CurrentNodeValue],[NextNode,NextNodeValue],Seed) :- NextNode is CurrentNode*Seed, NextNodeValue is CurrentNodeValue+1.
arc([CurrentNode,CurrentNodeValue],[NextNode,NextNodeValue],Seed) :- NextNode is CurrentNode*Seed + 1, NextNodeValue is CurrentNodeValue+2.
%as difinded in the exercise
goal([Node,_],Target) :- 0 is Node mod Target.
%stops any backtracking once it reaches it's goal node(the one we look for), otherwise we return the heuristic value of 1/nodevalue
heuresticFunction(Node,NodeKey,Hvalue,Target) :- goal(Node,Target), !, Hvalue is 0 
												 ;
												 Hvalue is 1/NodeKey. 
%compares two nodes to determine where they fit in the heuristic list
lessthan([Node1,Cost1],[Node2,Cost2],Target) :- heuresticFunction([Node1,Cost1],Node1,Hvalue1,Target), heuresticFunction([Node2,Cost2],Node2,Hvalue2,Target),
												F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
												F1 =< F2.
%Creates a new list of nodes Given there h value in increasing order
insert([],Nodes,_,Nodes).
insert([H|[]],[],_,[H]).
insert([H|T],[],Target,FNew):-insert([H],T,Target,FNew).
insert([NewNode|TailNew],[HFRest|TailHFrest],Target,Fnew)  :-  lessthan(NewNode,HFRest,Target),!,insert(TailNew,[HFRest|TailHFrest],Target,TempList),append([NewNode],TempList,Fnew)
															   ;
															   insert([NewNode|TailNew],TailHFrest,Target,TempList),append([HFRest],TempList,Fnew).
%this function will add the node to the frontier list
%heuristic function needs to be added in here
add2frontier(FNode,FRest,Target,Fnew) :- insert(FNode,FRest,Target,Fnew).
%figuring out the frontier search
%checks if the currentnode is the target.
%if it is, return the node
frontierSearch([Node|_],_,Target,Node) :- goal(Node,Target).
%otherwise get all the possible paths 
%this is done by finding the set of arcs from that node
%then we compare the nodes given their heurestic values
%and return a list of the astar shortest path where the list is in increasing order
frontierSearch([Node|OldNodes],Seed,Target,Found) :- setof(NewNode,arc(Node,NewNode,Seed),ChildrenNodes),
											  		 add2frontier(ChildrenNodes,OldNodes,Target,NewChildren),
											  		 frontierSearch(NewChildren,Seed,Target,Found).
astar(Start,Seed,Target,Found) :- frontierSearch([[Start,0]],Seed,Target,Found).