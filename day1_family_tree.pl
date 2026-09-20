% =====================================================================
% Day 1 : Prolog - Family Tree : Facts & Rules
% Artificial Intelligence Lab (CSE 3171)
% Contains: Common part + Group 1 + Group 2 + Group 3
% Load with:  ?- ['day1_family_tree.pl'].
% =====================================================================

% ---------------------------------------------------------------------
% COMMON (all groups) : the family
% Rahul (M) married Sita (F)  -> children Arjun (M), Neha (F)
% Arjun (M) married Geeta (F) -> children Vivek (M), Meena (F)
% Neha  (F) married Amit  (M) -> child    Rani  (F)
% ---------------------------------------------------------------------

% ---- male/1 ----
male(rahul).
male(arjun).
male(vivek).
male(amit).

% ---- female/1 ----
female(sita).
female(neha).
female(geeta).
female(meena).
female(rani).

% ---- married/2 ----
married(rahul, sita).
married(arjun, geeta).
married(amit,  neha).

% ---- father/2 ----
father(rahul, arjun).
father(rahul, neha).
father(arjun, vivek).
father(arjun, meena).
father(amit,  rani).

% ---- mother/2 ----
mother(sita,  arjun).
mother(sita,  neha).
mother(geeta, vivek).
mother(geeta, meena).
mother(neha,  rani).

% ---- parent/2 : X is a parent of Y if X is the father or the mother of Y
parent(X, Y) :- father(X, Y).
parent(X, Y) :- mother(X, Y).

% ---- sibling/2 : share a parent, and are not the same person
% NOTE: full siblings share BOTH parents, so this gives the same answer
%       twice (once via the father, once via the mother). That is normal.
%       Press ; to see it. For unique answers use:
%       ?- setof(Y, sibling(arjun,Y), L).
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% ---- spouse/2 : marriage is symmetric, married/2 is stored one way only
spouse(X, Y) :- married(X, Y).
spouse(X, Y) :- married(Y, X).

/* ---------------- Common test cases ----------------
?- sibling(arjun, neha).
true.
?- sibling(vivek, meena).
true.
?- parent(X, rani).
X = amit ;
X = neha.
?- spouse(geeta, X).
X = arjun.
---------------------------------------------------- */


% =====================================================================
% GROUP 1 (CSE)
% =====================================================================

% (1) Grandparent : a parent of one of a person's parents.
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% (2) Ancestor : a parent, or a parent of an ancestor (recursive).
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% (3) Cousin-brother : a MAN whose parent is a sibling of another
%     person's parent, and who is not that same person.
cousin_brother(X, Y) :-
    male(X),
    parent(P, X),
    parent(Q, Y),
    sibling(P, Q),
    X \= Y.

% (4) Brother-in-law : a man who is
%     (a) a sibling of the person's spouse, or
%     (b) married to the person's sibling, or
%     (c) married to a sibling of the person's spouse
%         (needed for "Amit is a brother-in-law of Geeta").
brother_in_law(X, Y) :-
    male(X), sibling(X, S), spouse(S, Y), X \= Y.
brother_in_law(X, Y) :-
    male(X), spouse(X, S), sibling(S, Y), X \= Y.
brother_in_law(X, Y) :-
    male(X), spouse(X, S), sibling(S, T), spouse(T, Y), X \= Y.

/* ---------------- Group 1 test cases ----------------
?- grandparent(rahul, vivek).
true.
?- grandparent(rahul, X).
X = vivek ; X = meena ; X = rani ; ...
?- ancestor(rahul, rani).
true.
?- cousin_brother(vivek, rani).
true.
?- brother_in_law(arjun, amit).
true.
?- brother_in_law(amit, geeta).
true.
----------------------------------------------------- */


% =====================================================================
% GROUP 2 (CSE)
% =====================================================================

% (1) Grandchild : the reverse of grandparent.
grandchild(X, Y) :- grandparent(Y, X).

% (2) Descendant : a child, or a child of a descendant (recursive).
descendant(X, Y) :- parent(Y, X).
descendant(X, Y) :- parent(Y, Z), descendant(X, Z).

% (3) Aunt : a woman who is a sibling of a person's parent (blood aunt),
%     or a woman married to a sibling of a person's parent (aunt by
%     marriage - this is the one that makes Geeta an aunt of Rani).
aunt(X, Y) :- female(X), parent(P, Y), sibling(X, P).
aunt(X, Y) :- female(X), spouse(X, S), parent(P, Y), sibling(S, P).

% (4) Mother-in-law : a woman who is the parent of a person's spouse.
mother_in_law(X, Y) :- female(X), spouse(Y, S), parent(X, S).

/* ---------------- Group 2 test cases ----------------
?- grandchild(vivek, rahul).
true.
?- descendant(rani, sita).
true.
?- aunt(geeta, rani).
true.
?- mother_in_law(sita, geeta).
true.
?- mother_in_law(sita, amit).
true.
----------------------------------------------------- */


% =====================================================================
% GROUP 3 (CSE - Data Science)
% =====================================================================

% (1) Uncle : a man who is a sibling of a person's parent,
%     or a man married to a sibling of a person's parent.
uncle(X, Y) :- male(X), parent(P, Y), sibling(X, P).
uncle(X, Y) :- male(X), spouse(X, S), parent(P, Y), sibling(S, P).

% (2) Niece : a woman whose parent is a sibling of the person,
%     or whose parent is a sibling of the person's spouse.
niece(X, Y) :- female(X), parent(P, X), sibling(P, Y).
niece(X, Y) :- female(X), parent(P, X), sibling(P, S), spouse(S, Y).

% (3) Father-in-law : a man who is the parent of a person's spouse.
father_in_law(X, Y) :- male(X), spouse(Y, S), parent(X, S).

% (4) Cousin-sister : a WOMAN whose parent is a sibling of another
%     person's parent, not the same person.
cousin_sister(X, Y) :-
    female(X),
    parent(P, X),
    parent(Q, Y),
    sibling(P, Q),
    X \= Y.

/* ---------------- Group 3 test cases ----------------
?- uncle(arjun, rani).
true.
?- niece(rani, arjun).
true.
?- father_in_law(rahul, geeta).
true.
?- father_in_law(rahul, amit).
true.
?- cousin_sister(meena, rani).
true.
----------------------------------------------------- */

% ---------------------------------------------------------------------
% Debugging:  ?- trace.   ... run a query ...   ?- notrace.
% Quit     :  ?- halt.
% ---------------------------------------------------------------------
