% =====================================================================
% Day 2 : Prolog - Recursion : Numerical Problems
% Artificial Intelligence Lab (CSE 3171)
% Contains: Common part + Group 1 + Group 2 + Group 3
% Everything is written from first principles: only recursion,
% comparisons and is/2.  No library predicates that solve the problem.
% =====================================================================

% ---------------------------------------------------------------------
% COMMON (all groups)
% ---------------------------------------------------------------------

% ---- Factorial (from the prelude) ----
factorial(0, 1).                       % base case
factorial(N, Result) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, SubResult),
    Result is N * SubResult.

% ---- Fibonacci ----
fib(0, 0).
fib(1, 1).
fib(N, X) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fib(N1, X1),
    fib(N2, X2),
    X is X1 + X2.

/* ---------------- Common test cases ----------------
?- factorial(5, X).     X = 120.
?- factorial(0, X).     X = 1.
?- fib(7, X).           X = 13.
?- fib(10, X).          X = 55.
---------------------------------------------------- */


% =====================================================================
% GROUP 1 (CSE)
% =====================================================================

% (1) Maximum of 3 numbers, via a 2-number max helper used twice.
max2(X, Y, X) :- X >= Y.
max2(X, Y, Y) :- X <  Y.

max3(A, B, C, M) :-
    max2(A, B, M1),
    max2(M1, C, M).

% (2) Sum of the first N natural numbers, by recursion (not the formula).
sum_nat(0, 0).
sum_nat(N, S) :-
    N > 0,
    N1 is N - 1,
    sum_nat(N1, S1),
    S is S1 + N.

% (3) GCD of 3 numbers : Euclid's algorithm on 2 numbers, applied twice.
gcd2(X, 0, X) :- X > 0.
gcd2(X, Y, G) :-
    Y > 0,
    R is X mod Y,
    gcd2(Y, R, G).

gcd3(A, B, C, G) :-
    gcd2(A, B, G1),
    gcd2(G1, C, G).

% (4) Digit count of a positive integer (repeatedly divide by 10).
digit_count(N, 1) :- N >= 0, N < 10.
digit_count(N, C) :-
    N >= 10,
    N1 is N // 10,
    digit_count(N1, C1),
    C is C1 + 1.

/* ---------------- Group 1 test cases ----------------
?- max3(4, 8, 10, M).          M = 10.
?- max3(9, 2, 5, M).           M = 9.
?- sum_nat(10, S).             S = 55.
?- gcd3(12, 18, 24, G).        G = 6.
?- digit_count(4938, C).       C = 4.
?- digit_count(7, C).          C = 1.
----------------------------------------------------- */


% =====================================================================
% GROUP 2 (CSE)
% =====================================================================

% (1) Minimum of 3 numbers, via a 2-number min helper used twice.
min2(X, Y, X) :- X =< Y.
min2(X, Y, Y) :- X >  Y.

min3(A, B, C, M) :-
    min2(A, B, M1),
    min2(M1, C, M).

% (2) Sum of N terms of an AP, given first term A, common difference D
%     and number of terms N, by recursion (not the formula).
ap_sum(_, _, 0, 0).
ap_sum(A, D, N, S) :-
    N > 0,
    N1 is N - 1,
    A1 is A + D,                 % next term becomes the new first term
    ap_sum(A1, D, N1, S1),
    S is A + S1.

% (3) LCM of 3 numbers, using LCM(a,b) = a*b/GCD(a,b) twice.
lcm2(A, B, L) :-
    gcd2(A, B, G),
    L is A * B // G.

lcm3(A, B, C, L) :-
    lcm2(A, B, L1),
    lcm2(L1, C, L).

% (4) Reverse the digits of a positive integer (peel with mod / div).
rev_digits(N, R) :- rev_acc(N, 0, R).

rev_acc(0, A, A).
rev_acc(N, A, R) :-
    N > 0,
    D  is N mod 10,
    N1 is N // 10,
    A1 is A * 10 + D,
    rev_acc(N1, A1, R).

/* ---------------- Group 2 test cases ----------------
?- min3(4, 8, 10, M).          M = 4.
?- ap_sum(1, 2, 5, S).         S = 25.      % 1+3+5+7+9
?- ap_sum(3, 4, 4, S).         S = 36.      % 3+7+11+15
?- lcm3(4, 6, 8, L).           L = 24.
?- rev_digits(3502, R).        R = 2053.
?- rev_digits(4938, R).        R = 8394.
----------------------------------------------------- */


% =====================================================================
% GROUP 3 (CSE - Data Science)
% =====================================================================

% (1) B raised to a non-negative power E, by recursive multiplication.
power(_, 0, 1).
power(B, E, R) :-
    E > 0,
    E1 is E - 1,
    power(B, E1, R1),
    R is B * R1.

% (2) Sum of the first N even numbers, by recursion.
%     The Nth even number is 2*N.
sum_even(0, 0).
sum_even(N, S) :-
    N > 0,
    N1 is N - 1,
    sum_even(N1, S1),
    S is S1 + 2 * N.

% (3) Digit sum of a positive integer.
digit_sum(N, N) :- N >= 0, N < 10.
digit_sum(N, S) :-
    N >= 10,
    D  is N mod 10,
    N1 is N // 10,
    digit_sum(N1, S1),
    S is S1 + D.

% (4) Sum of the first N odd numbers, by recursion.
%     The Nth odd number is 2*N - 1.
sum_odd(0, 0).
sum_odd(N, S) :-
    N > 0,
    N1 is N - 1,
    sum_odd(N1, S1),
    S is S1 + (2 * N - 1).

/* ---------------- Group 3 test cases ----------------
?- power(2, 5, R).             R = 32.
?- power(3, 0, R).             R = 1.
?- sum_even(5, S).             S = 30.      % 2+4+6+8+10
?- digit_sum(4938, S).         S = 24.
?- sum_odd(5, S).              S = 25.      % 1+3+5+7+9
----------------------------------------------------- */
