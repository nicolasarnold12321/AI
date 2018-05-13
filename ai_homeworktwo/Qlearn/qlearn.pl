
qlearn(N,Start,G,Mat,Result):-qn(Start,0,G,N,X),  %% the exercise matrix
							  qn(Start,1,G,N,Y),  %% the relax matrix
							  (X>=Y,mat(0,Mat),Result is X ; mat(1,Mat),Result is Y). %% is exercise is greater than relax return exercise and it's val

qstart(S,A,R):- p(S, A, 0, X), r(S,A,0,Y), p(S, A, 1,Z), r(S, A , 1,T),Rleft is X*Y,RRight is Z*T, R is Rleft+RRight.  %% Q0 

v(S,N,G,R):-qn(S,0,G,N,X),qn(S,1,G,N,Y),(X>=Y, R is X;R is Y).   %% maxfunction

qn(S,A,_,1,R):-qstart(S,A,R).  %% iteration function
qn(S,A,G,N,R):-
				NewN is N-1,   %% change N
				qstart(S,A,X), %% calculate the first part
				p(S,A,0,Fit),  %% get rewards and probs
				p(S,A,1,Unfit),
				v(0,NewN,G,Maxfit),v(1,NewN,G,MaxUnfit), %% get the maxvalues
				Left is Fit*Maxfit,                      %% algebra
				Right is Unfit*MaxUnfit, 
				Middle is G*(Left+Right), 
				R is X+Middle.


%% these are the matrices
%% A exercise = 0 relax=1
%% Next fit =0 unfit=1
%% S fit=0 unfit=1
%% p(S,A,Next,Ans)
%% r(S,A,Next,Ans)


%% exercise 
p(0, 0, 0, 0.99).
p(0, 0, 1, 0.01).
p(1, 0, 0, 0.2).
p(1, 0, 1, 0.8).

%% relax
p(0, 1, 0, 0.7).
p(0, 1, 1, 0.3).
p(1, 1, 0, 0).
p(1, 1, 1, 1).

%% exercise
r(0, 0, 0, 8).
r(0, 0, 1, 8).
r(1, 0, 0, 0).
r(1, 0, 1, 0).


%% relax
r(0, 1, 0, 10).
r(0, 1, 1, 10).
r(1, 1, 0, 5).
r(1, 1, 1, 5).

%% the return types
mat(0,exercise).
mat(1,relax).