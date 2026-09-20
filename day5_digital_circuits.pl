% =====================================================================
% Day 5 : Prolog - Digital Circuits in Prolog
% Artificial Intelligence Lab (CSE 3171)
% Contains: Common primitives + Group 1 + Group 2 + Group 3
%
% A gate is a fact table (input combination -> output).
% A composed circuit is a rule chaining gates through intermediate
% variables.  No built-in predicates are used.
% =====================================================================

% ---------------------------------------------------------------------
% COMMON : primitive gates (given in the prelude)
% ---------------------------------------------------------------------
and_g(1,1,1).  and_g(1,0,0).  and_g(0,1,0).  and_g(0,0,0).
or_g(1,1,1).   or_g(1,0,1).   or_g(0,1,1).   or_g(0,0,0).
not_g(0,1).    not_g(1,0).


% =====================================================================
% GROUP 1 (CSE)
% =====================================================================

% (1) XOR and XNOR built from AND / OR / NOT.
%     XOR = (NOT A AND B) OR (A AND NOT B)
xor_g(A, B, Out) :-
    not_g(A, NA),
    not_g(B, NB),
    and_g(NA, B, T1),
    and_g(A, NB, T2),
    or_g(T1, T2, Out).

xnor_g(A, B, Out) :-
    xor_g(A, B, X),
    not_g(X, Out).

% (2) NAND and NOR built from AND / OR / NOT.
nand_g(A, B, Out) :-
    and_g(A, B, X),
    not_g(X, Out).

nor_g(A, B, Out) :-
    or_g(A, B, X),
    not_g(X, Out).

% (3) 2-to-1 multiplexer : Out = A if S = 0, Out = B if S = 1.
%     Out = (NOT S AND A) OR (S AND B)
mux2(S, A, B, Out) :-
    not_g(S, NS),
    and_g(NS, A, T1),
    and_g(S,  B, T2),
    or_g(T1, T2, Out).

% (4) 1-bit comparator : Eq / Gt / Lt.
%     Eq = NOT(A XOR B),  Gt = A AND NOT B,  Lt = NOT A AND B
comparator(A, B, Eq, Gt, Lt) :-
    xor_g(A, B, X),
    not_g(X, Eq),
    not_g(B, NB),
    and_g(A, NB, Gt),
    not_g(A, NA),
    and_g(NA, B, Lt).

/* ---------------- Group 1 test cases ----------------
?- xor_g(0,0,X).            X = 0.
?- xor_g(0,1,X).            X = 1.
?- xor_g(1,0,X).            X = 1.
?- xor_g(1,1,X).            X = 0.
?- xnor_g(0,1,X).           X = 0.
?- xnor_g(1,1,X).           X = 1.
?- nand_g(1,1,X).           X = 0.
?- nor_g(1,1,X).            X = 0.
?- nor_g(0,0,X).            X = 1.
?- mux2(1,0,1,Out).         Out = 1.
?- mux2(0,0,1,Out).         Out = 0.
?- comparator(1,0,Eq,Gt,Lt).   Eq = 0, Gt = 1, Lt = 0.
?- comparator(1,1,Eq,Gt,Lt).   Eq = 1, Gt = 0, Lt = 0.
----------------------------------------------------- */


% =====================================================================
% GROUP 2 (CSE)
% =====================================================================
% (1) NAND from primitives : nand_g/3 is already defined above.

% (2) Universal NAND : rebuild NOT, AND, OR, XOR, XNOR using ONLY NAND.
not_n(A, Out) :-
    nand_g(A, A, Out).                         % NOT A = A NAND A

and_n(A, B, Out) :-
    nand_g(A, B, X),
    not_n(X, Out).                             % A AND B = NOT(A NAND B)

or_n(A, B, Out) :-
    not_n(A, NA),
    not_n(B, NB),
    nand_g(NA, NB, Out).                       % A OR B = (NOT A) NAND (NOT B)

xor_n(A, B, Out) :-
    nand_g(A, B, X),
    nand_g(A, X, T1),
    nand_g(B, X, T2),
    nand_g(T1, T2, Out).                       % classic 4-NAND XOR

xnor_n(A, B, Out) :-
    xor_n(A, B, X),
    not_n(X, Out).

% alias used in the question paper's sample answers
xor_g2(A, B, Out) :- xor_n(A, B, Out).

% (3) Half adder and full adder.
half_adder(A, B, Sum, Carry) :-
    xor_g(A, B, Sum),
    and_g(A, B, Carry).

full_adder(A, B, Cin, S, Cout) :-
    half_adder(A, B, S1, C1),
    half_adder(S1, Cin, S, C2),
    or_g(C1, C2, Cout).

% (4) 4-to-1 multiplexer by cascading three 2-to-1 multiplexers.
%     Selection index = 2*S0 + S1 (as used in the sample answer).
%
%     Data-selecting 2-to-1 mux : works for ANY data values, not just
%     0/1, because a mux only routes a value, it does not compute on it.
mux2s(0, A, _, A).
mux2s(1, _, B, B).

mux4(S0, S1, A, B, C, D, Out) :-
    mux2s(S1, A, B, T1),        % first  2-1 mux : chooses between A and B
    mux2s(S1, C, D, T2),        % second 2-1 mux : chooses between C and D
    mux2s(S0, T1, T2, Out).     % third  2-1 mux : chooses between them

% Pure gate-level version, valid when the data lines are binary (0/1).
mux4_g(S0, S1, A, B, C, D, Out) :-
    mux2(S1, A, B, T1),
    mux2(S1, C, D, T2),
    mux2(S0, T1, T2, Out).

/* ---------------- Group 2 test cases ----------------
?- nand_g(1,1,X).                   X = 0.
?- nand_g(0,1,X).                   X = 1.
?- not_n(0,X).                      X = 1.
?- and_n(1,1,X).                    X = 1.
?- or_n(0,1,X).                     X = 1.
?- xor_g2(1,0,X).                   X = 1.
?- xnor_n(1,1,X).                   X = 1.
?- half_adder(1,1,S,C).             S = 0, C = 1.
?- full_adder(1,1,1,S,Cout).        S = 1, Cout = 1.
?- full_adder(1,0,1,S,Cout).        S = 0, Cout = 1.
?- mux4(1,0,1,2,3,4,Out).           Out = 3.
?- mux4(0,1,1,2,3,4,Out).           Out = 2.
?- mux4_g(0,0,1,0,1,0,Out).         Out = 1.
----------------------------------------------------- */


% =====================================================================
% GROUP 3 (CSE - Data Science)
% =====================================================================

% (1) NAND from primitives (nand_g/3 above), then XOR and XNOR purely
%     from that NAND : xor_n/3 and xnor_n/3 above are exactly that.
%     Given separate names here so the Group-3 answer stands alone:
xor_from_nand(A, B, Out)  :- xor_n(A, B, Out).
xnor_from_nand(A, B, Out) :- xnor_n(A, B, Out).

% (2) NOR from primitives (nor_g/3 above), then rebuild everything
%     using ONLY that NOR gate.
not_r(A, Out) :-
    nor_g(A, A, Out).                          % NOT A = A NOR A

or_r(A, B, Out) :-
    nor_g(A, B, X),
    not_r(X, Out).                             % A OR B = NOT(A NOR B)

and_r(A, B, Out) :-
    not_r(A, NA),
    not_r(B, NB),
    nor_g(NA, NB, Out).                        % A AND B = (NOT A) NOR (NOT B)

xnor_r(A, B, Out) :-
    nor_g(A, B, T1),                           % 1 when both are 0
    and_r(A, B, T2),                           % 1 when both are 1
    or_r(T1, T2, Out).                         % XNOR = same inputs

xor_r(A, B, Out) :-
    xnor_r(A, B, X),
    not_r(X, Out).

% 3-input AND / OR helpers (used by the majority gate)
and_g3(A, B, C, Out) :- and_g(A, B, T), and_g(T, C, Out).
or_g3(A, B, C, Out)  :- or_g(A, B, T),  or_g(T, C, Out).

% (3) Half subtractor : Diff = A XOR B, Borrow = (NOT A) AND B.
half_subtractor(A, B, Diff, Borrow) :-
    xor_g(A, B, Diff),
    not_g(A, NA),
    and_g(NA, B, Borrow).

% alias for the (mis-typed) name used in the question paper
hald_subtractor(A, B, Diff, Borrow) :- half_subtractor(A, B, Diff, Borrow).

% (4) 3-input majority gate : output 1 when at least 2 of 3 inputs are 1.
%     M = (A AND B) OR (B AND C) OR (A AND C)
majority3(A, B, C, M) :-
    and_g(A, B, X1),
    and_g(B, C, X2),
    and_g(A, C, X3),
    or_g3(X1, X2, X3, M).

/* ---------------- Group 3 test cases ----------------
?- xor_from_nand(1,0,X).                    X = 1.
?- xor_from_nand(1,1,X).                    X = 0.
?- xnor_from_nand(0,0,X).                   X = 1.
?- not_r(1,X).                              X = 0.
?- and_r(1,1,X).                            X = 1.
?- or_r(0,0,X).                             X = 0.
?- xor_r(1,0,X).                            X = 1.
?- xnor_r(1,1,X).                           X = 1.
?- and_g3(1,1,1,X).                         X = 1.
?- half_subtractor(0,1,Diff,Borrow).        Diff = 1, Borrow = 1.
?- half_subtractor(1,1,Diff,Borrow).        Diff = 0, Borrow = 0.
?- majority3(1,1,0,M).                      M = 1.
?- majority3(1,0,0,M).                      M = 0.
----------------------------------------------------- */
