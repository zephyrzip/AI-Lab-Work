% =====================================================================
% Day 4 : Prolog - Cuts : Green and Red cuts to control backtracking
% Artificial Intelligence Lab (CSE 3171)
% Contains: Common part + Group 1 + Group 2 + Group 3
%
% GREEN cut : only efficiency, same answers with or without it.
% RED   cut : part of the logic, removing it changes the answers.
% =====================================================================

% ---------------------------------------------------------------------
% COMMON (all groups) : the two worked examples
% ---------------------------------------------------------------------

% Example 1 - GREEN cut : membership, stop at the first match.
my_member(X, [X|_]) :- !.              % GREEN: logic unchanged, just faster
my_member(X, [_|T]) :- my_member(X, T).

% Example 2 - RED cut : insert X into an ascending sorted list.
insert_sorted(X, [], [X]).
insert_sorted(X, [H|T], [X,H|T]) :- X =< H, !.   % RED: exactly one clause fires
insert_sorted(X, [H|T], [H|R])   :- insert_sorted(X, T, R).

/* ---------------- Common test cases ----------------
?- my_member(3, [1,2,3,4]).                true.
?- insert_sorted(3, [1,2,4], R).           R = [1,2,3,4].
---------------------------------------------------- */


% =====================================================================
% GROUP 1 (CSE)
% =====================================================================

% (1) Last element of a non-empty list - GREEN cut on the base case.
last_elem([X], X) :- !.                % GREEN: the 2nd clause would fail anyway
last_elem([_|T], X) :- last_elem(T, X).

% (2) Season of a month - RED cuts (first matching clause decides).
season(dec, winter) :- !.
season(jan, winter) :- !.
season(feb, winter) :- !.
season(mar, spring) :- !.
season(apr, spring) :- !.
season(may, spring) :- !.
season(jun, summer) :- !.
season(jul, summer) :- !.
season(aug, summer) :- !.
season(sep, autumn) :- !.
season(oct, autumn) :- !.
season(nov, autumn) :- !.
season(_,   unknown).                  % RED: reached only if nothing above matched

% (3) Insert into a DESCENDING-sorted list at the right place - RED cut.
insert_sorted_desc(X, [], [X]).
insert_sorted_desc(X, [H|T], [X,H|T]) :- X >= H, !.       % RED cut
insert_sorted_desc(X, [H|T], [H|R])   :- insert_sorted_desc(X, T, R).

% (4) First negative number of a list, left to right - GREEN cut once found.
first_negative([H|_], H) :- H < 0, !.  % GREEN: stop searching after the hit
first_negative([_|T], X) :- first_negative(T, X).

/* ---------------- Group 1 test cases ----------------
?- last_elem([3,7,9], X).                  X = 9.
?- season(jul, S).                         S = summer.
?- season(jan, S).                         S = winter.
?- insert_sorted_desc(5, [9,6,2], R).      R = [9,6,5,2].
?- first_negative([3,7,-2,9,-5], X).       X = -2.
?- first_negative([3,7,9], X).             false.
----------------------------------------------------- */


% =====================================================================
% GROUP 2 (CSE)
% =====================================================================

% (1) Minimum of a list - GREEN cut once the smaller value is confirmed.
min_of2(X, Y, X) :- X =< Y, !.         % GREEN: guard on 2nd clause keeps it correct
min_of2(X, Y, Y) :- X >  Y.

min_list_cut([X], X) :- !.             % GREEN cut on the base case
min_list_cut([H|T], M) :-
    min_list_cut(T, M1),
    min_of2(H, M1, M).

% (2) Day type - RED cuts, weekend days listed explicitly.
day_type(saturday, weekend) :- !.
day_type(sunday,   weekend) :- !.
day_type(_,        weekday).           % RED: catch-all for everything else

% (3) Insertion sort, built on insert_sorted/3 (which uses the RED cut).
insertion_sort([], []).
insertion_sort([H|T], S) :-
    insertion_sort(T, ST),
    insert_sorted(H, ST, S).

% (4) Triangle classification by its 3 sides - RED cuts.
triangle_type(A, B, C, equilateral) :-
    A =:= B, B =:= C, !.                              % RED cut
triangle_type(A, B, C, isosceles) :-
    ( A =:= B ; B =:= C ; A =:= C ), !.               % RED cut
triangle_type(_, _, _, scalene).

/* ---------------- Group 2 test cases ----------------
?- min_list_cut([5,1,4], M).               M = 1.
?- day_type(sunday, T).                    T = weekend.
?- day_type(monday, T).                    T = weekday.
?- insertion_sort([3,1,2], S).             S = [1,2,3].
?- insertion_sort([5,2,9,1], S).           S = [1,2,5,9].
?- triangle_type(5,5,8,T).                 T = isosceles.
?- triangle_type(6,6,6,T).                 T = equilateral.
?- triangle_type(3,4,5,T).                 T = scalene.
----------------------------------------------------- */


% =====================================================================
% GROUP 3 (CSE - Data Science)
% =====================================================================

% (1) 1-indexed position of the first occurrence of X in L - GREEN cut.
position(X, [X|_], 1) :- !.            % GREEN: first match only
position(X, [_|T], P) :-
    position(X, T, P1),
    P is P1 + 1.

% (2) Is the list ascending? GREEN cut on the first violation.
is_sorted_asc([]).
is_sorted_asc([_]) :- !.
is_sorted_asc([A,B|T]) :-
    A =< B, !,                          % GREEN: once A =< B holds, commit
    is_sorted_asc([B|T]).

% (3) Grade a mark - RED cuts (order of the clauses carries the meaning).
grade(M, fail)        :- M <  40, !.   % RED cut
grade(M, pass)        :- M <  80, !.   % RED cut (40..79 reaches here)
grade(M, excellent)   :- M <  90, !.   % RED cut (80..89 reaches here)
grade(_, outstanding).                 % >= 90

% (4) Is every element even? GREEN cut as soon as an element is checked.
all_even([]).
all_even([H|T]) :-
    0 is H mod 2, !,                    % GREEN: commit on an even element;
    all_even(T).                        % an odd element simply fails

/* ---------------- Group 3 test cases ----------------
?- position(b, [a,b,c], P).                P = 2.
?- position(c, [a,b,c], P).                P = 3.
?- is_sorted_asc([1,2,3]).                 true.
?- is_sorted_asc([1,3,2]).                 false.
?- grade(85, X).                           X = excellent.
?- grade(35, X).                           X = fail.
?- grade(60, X).                           X = pass.
?- grade(95, X).                           X = outstanding.
?- all_even([2,4,6,8]).                    true.
?- all_even([2,3,6]).                      false.
----------------------------------------------------- */
