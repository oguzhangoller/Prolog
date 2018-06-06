/*
This function first extracts all teams from team knowledge base and using permutation function,
it creates all it's possible permutation, where length function returns length of list to N
*/
allTeams(L, N) :- findall(X, team(X,Y), K)
				 ,permutation(K,L)
				 ,length(K,N).

/*
These three functions(wins,losses and draws) are structured in the same way :
They first find all matches played by given team, compare the scored and conceded goals to determine
whether given team won, lost or made a draw. It also compares that given week W is greater than the week
match played in. The second findall function is used to get all matches that given team won as away team.
After the function gets these lists, it appends them to a new list and we return it's size by length function.
*/

wins(X,W,L,N) :- findall(D,(match(A,X,C,D,E),W>=A,C>E),K)
				,findall(D,(match(A,D,C,X,E),W>=A,E>C),M)
				,append(K,M,L)
				,length(L,N).

losses(X,W,L,N) :- findall(D,(match(A,X,C,D,E),W>=A,C<E),K)
				,findall(D,(match(A,D,C,X,E),W>=A,E<C),M)
				,append(K,M,L)
				,length(L,N).

draws(X,W,L,N) :- findall(D,(match(A,X,C,D,E),W>=A,C==E),K)
				,findall(D,(match(A,D,C,X,E),W>=A,E==C),M)
				,append(K,M,L)
				,length(L,N).

/*
Scored and conceded functions also work the same way as explained above. They find home and away matches 
played by given team T up to Week W, result a list of numbers scored by given team. The only difference is that
after we append the lists together; we sum the content of list to gather all goals scored of conceded.
*/

scored(T,W,S) :- findall(C,(match(A,T,C,D,E),W>=A),K)
				,findall(E,(match(A,B,C,T,E),W>=A),M)
				,append(K,M,L)
				,sum_list(L,S).

conceded(T,W,S) :- findall(E,(match(A,T,C,D,E),W>=A),K)
				  ,findall(C,(match(A,B,C,T,E),W>=A),M)
				  ,append(K,M,L)
				  ,sum_list(L,S).

/*
This function runs on the same method as above. 4 different findall functions run to gather all goals conceded and scored both
home and away. After that sum list sums the contents of the lists. Then scored goals are subtracted from conceded goals to find the answer.
*/

average(T,W,S) :- findall(C,(match(A,T,C,D,E),W>=A),SC1)
				 ,findall(E,(match(A,T,C,D,E),W>=A),CON1)
				 ,findall(E,(match(A,B,C,T,E),W>=A),SC2)
				 ,findall(C,(match(A,B,C,T,E),W>=A),CON2)
				 ,sum_list(SC1,X)
				 ,sum_list(SC2,Y)
				 ,sum_list(CON1,P)
				 ,sum_list(CON2,R)
				 ,S is X+Y-P-R.
/*
This function is implemented using bubblesort logic. The list of teams are iterated recursively, for each team;
whole list is iterated and averages acquired by average function are used to do comparisons. At the end, we have a list 
of teams ordered by average.
*/

average_sort(List,Sorted,W):-sort1(List,[],Sorted,W).
	sort1([],Re,Re,W).
	sort1([H|T],Re,Sorted,W):-sort2(H,T,TA2,Max,W),sort1(TA2,[Max|Re],Sorted,W).

	sort2(X,[],[],X,W).
	sort2(X,[Y|TA1],[Y|TA2],Max,W):-average(X,W,S1),  average(Y,W,S2),(S1<S2),sort2(X,TA1,TA2,Max,W).
	sort2(X,[Y|TA1],[X|TA2],Max,W):-average(X,W,S1),  average(Y,W,S2),(S1 >= S2),sort2(Y,TA1,TA2,Max,W).

/*
This function first extracts all teams and sorts them according to sort function above.
*/

order(L,W):-
		findall(X,team(X, N),K),
		average_sort(K,L,W).



