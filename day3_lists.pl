% =====================================================================
% Day 3 : Prolog - Lists : First Principles Recursion
% Artificial Intelligence Lab (CSE 3171)
% Contains: Common part + Group 1 + Group 2 + Group 3
% No built-in list predicates are used (no length/2, reverse/2,
% append/3, sum_list/2, flatten/2 ...).
% =====================================================================

% ---------------------------------------------------------------------
% COMMON (all groups) : my_append/3 - R is L1 followed by L2
% ---------------------------------------------------------------------
my_append([], L, L).
my_append([H|T], L, [H|R]) :- my_append(T, L, R).

% member written from first principles (used/allowed in several places)
my_member(X, [X|_]).
my_member(X, [_|T]) :- my_member(X, T).

/* ---------------- Common test cases ----------------
?- my_append([1,2], [3,4], R).      R = [1,2,3,4].
?- my_append(X, [3,4], [1,2,3,4]).  X = [1,2].
?- my_member(3, [1,2,3,4]).         true.
---------------------------------------------------- */


% =====================================================================
% GROUP 1 (CSE)
% =====================================================================

% (1) Length : count the number of elements of a list.
list_length([], 0).
list_length([_|T], N) :-
    list_length(T, N1),
    N is N1 + 1.

% (2) Reverse : reverse a list using recursion and my_append.
my_reverse([], []).
my_reverse([H|T], R) :-
    my_reverse(T, RT),
    my_append(RT, [H], R).

% (3) Count atomic elements in a possibly nested list.
count_atoms([], 0).
count_atoms([H|T], C) :-                 % H is an atom or a number
    atomic(H),
    count_atoms(T, C1),
    C is C1 + 1.
count_atoms([H|T], C) :-                 % H is itself a list -> go inside
    is_list(H),
    count_atoms(H, C1),
    count_atoms(T, C2),
    C is C1 + C2.

% (4) Count elements strictly greater than a threshold T.
count_greater([], _, 0).
count_greater([H|T], Th, C) :-
    H > Th,
    count_greater(T, Th, C1),
    C is C1 + 1.
count_greater([H|T], Th, C) :-
    H =< Th,
    count_greater(T, Th, C).

/* ---------------- Group 1 test cases ----------------
?- list_length([[1,2],3,4], X).            X = 3.
?- list_length([1,2,3,4], X).              X = 4.
?- my_reverse([1,2,3,4], R).               R = [4,3,2,1].
?- my_reverse([1,2,3,4], [4,3,2,1]).       true.
?- my_reverse([[1,2],3,4], [4,3,[1,2]]).   true.
% reverse of a reverse gives back the original:
?- my_reverse([1,2,3,4], R), my_reverse(R, O).   R = [4,3,2,1], O = [1,2,3,4].
?- count_atoms([a,[b,[c,d],e],f], X).      X = 6.
?- count_greater([4,8,2,10,6], 5, X).      X = 3.
----------------------------------------------------- */


% =====================================================================
% GROUP 2 (CSE)
% =====================================================================

% (1) Sum of the numbers in a list.
sum_list_r([], 0).
sum_list_r([H|T], S) :-
    sum_list_r(T, S1),
    S is S1 + H.

% (2) Deep reverse : reverse the outer list and every nested sublist.
deep_reverse([], []).
deep_reverse([H|T], R) :-
    is_list(H),
    deep_reverse(H, RH),
    deep_reverse(T, RT),
    my_append(RT, [RH], R).
deep_reverse([H|T], R) :-
    \+ is_list(H),
    deep_reverse(T, RT),
    my_append(RT, [H], R).

% (3) Deep member : does V occur anywhere in L, nested sublists included?
deep_member(V, [V|_]).
deep_member(V, [H|_]) :- is_list(H), deep_member(V, H).
deep_member(V, [_|T]) :- deep_member(V, T).

% (4) Flatten an arbitrarily nested list into one flat list.
my_flatten([], []).
my_flatten([H|T], F) :-
    is_list(H),
    my_flatten(H, FH),
    my_flatten(T, FT),
    my_append(FH, FT, F).
my_flatten([H|T], [H|FT]) :-
    \+ is_list(H),
    my_flatten(T, FT).

/* ---------------- Group 2 test cases ----------------
?- sum_list_r([1,2,3,4], X).               X = 10.
?- deep_reverse([[1,2],3,4], X).           X = [4,3,[2,1]].
?- deep_reverse([1,[2,[3,4]],5], X).       X = [5,[[4,3],2],1].
?- deep_member(c, [a,[b,[c,d],e],f]).      true.
?- deep_member(z, [a,[b,[c,d],e],f]).      false.
?- my_flatten([1,[2,[3,4]],5], X).         X = [1,2,3,4,5].
----------------------------------------------------- */


% =====================================================================
% GROUP 3 (CSE - Data Science)
% =====================================================================

% helper : max of two numbers (first principles)
max_of2(X, Y, X) :- X >= Y.
max_of2(X, Y, Y) :- X <  Y.

% (1) Largest value of a non-empty list, by recursion.
max_list_r([X], X).
max_list_r([H|T], M) :-
    T \= [],
    max_list_r(T, M1),
    max_of2(H, M1, M).

% (2) Remove duplicates, keeping the first occurrence, order preserved.
del_all(_, [], []).
del_all(X, [X|T], R)     :- del_all(X, T, R).
del_all(X, [H|T], [H|R]) :- X \= H, del_all(X, T, R).

remove_dups([], []).
remove_dups([H|T], [H|R]) :-
    del_all(H, T, T1),         % throw away later copies of H
    remove_dups(T1, R).

% (3) Count all occurrences of a value V in a list L.
count_occ(_, [], 0).
count_occ(V, [V|T], C) :-
    count_occ(V, T, C1),
    C is C1 + 1.
count_occ(V, [H|T], C) :-
    V \= H,
    count_occ(V, T, C).

% (4) Average (integer division) of a non-empty list.
list_average(L, A) :-
    sum_list_r(L, S),
    list_length(L, N),
    N > 0,
    A is S // N.

/* ---------------- Group 3 test cases ----------------
?- max_list_r([4,8,2,10,6], X).            X = 10.
?- remove_dups([1,2,2,3,1,4], X).          X = [1,2,3,4].
?- count_occ(2, [2,3,2,4,2], X).           X = 3.
?- list_average([4,8,2,10,6], X).          X = 6.    % 30 // 5
----------------------------------------------------- */
