/-
  =====================================================================
  Day 9 : Lean 4 - Functional Recursion & Lists
  Artificial Intelligence Lab (CSE 3171)
  Contains: Common part + Group 1 + Group 2 + Group 3

  Run it: paste into live.lean-lang.org, or open the .lean file in VS Code
  with the "Lean 4" extension.  #eval prints the value; a red squiggle
  means a type or syntax error at that spot.

  Idea used throughout: pattern-match on the list, exactly like Prolog's
  [] / [H|T] or Lisp's null / car / cdr.
      | []        => ...      -- base case: empty list
      | (x :: xs) => ...      -- recursive case: head x, tail xs
  =====================================================================
-/

/- ---------------------------------------------------------------------
   COMMON (all groups) : factorial, exactly as in the tutorial
   --------------------------------------------------------------------- -/
def myFactorial : Nat -> Nat
| 0 => 1
| (n+1) => (n+1) * myFactorial n

#eval myFactorial 5      -- 120
#eval myFactorial 0      -- 1

/- The data list and the length function from the tutorial. -/
def nums : List Nat := [3, 7, 2, 9, 4, 6, 1, 8]

def myLength : List Nat -> Nat
| [] => 0
| (_ :: xs) => 1 + myLength xs

#eval myLength nums      -- 8


/- ---------------------------------------------------------------------
   Shared recursive helpers.  Each takes a yes/no test `p` and walks the
   list by recursion; every group task below is one call of one helper.
   --------------------------------------------------------------------- -/

-- how many elements satisfy p
def countIf (p : Nat -> Bool) : List Nat -> Nat
| [] => 0
| (x :: xs) => if p x then 1 + countIf p xs else countIf p xs

-- sum of the elements that satisfy p
def sumIf (p : Nat -> Bool) : List Nat -> Nat
| [] => 0
| (x :: xs) => if p x then x + sumIf p xs else sumIf p xs

-- the elements that satisfy p, original order kept
def keepIf (p : Nat -> Bool) : List Nat -> List Nat
| [] => []
| (x :: xs) => if p x then x :: keepIf p xs else keepIf p xs

-- sum of all elements
def mySum : List Nat -> Nat
| [] => 0
| (x :: xs) => x + mySum xs

-- average, using Nat (integer) division: (3+7+2+9+4+6+1+8) / 8 = 40 / 8 = 5
def myAverage (l : List Nat) : Nat := mySum l / myLength l

#eval mySum nums         -- 40
#eval myAverage nums     -- 5


/- =====================================================================
   GROUP 1 (CSE) : countMatching
   ===================================================================== -/

-- 1. how many elements are even
def countMatching1 (l : List Nat) : Nat :=
  countIf (fun x => x % 2 == 0) l

-- 2. how many elements are greater than the average of the list
def countMatching2 (l : List Nat) : Nat :=
  countIf (fun x => x > myAverage l) l

-- 3. how many elements are divisible by 3
def countMatching3 (l : List Nat) : Nat :=
  countIf (fun x => x % 3 == 0) l

-- 4. how many elements are at most 3
def countMatching4 (l : List Nat) : Nat :=
  countIf (fun x => x <= 3) l

#eval countMatching1 nums   -- 4   (2, 4, 6, 8)
#eval countMatching2 nums   -- 4   (7, 9, 6, 8 are greater than 5)
#eval countMatching3 nums   -- 3   (3, 9, 6)
#eval countMatching4 nums   -- 3   (3, 2, 1)


/- =====================================================================
   GROUP 2 (CSE) : sumMatching
   ===================================================================== -/

-- 1. sum of the odd elements
def sumMatching1 (l : List Nat) : Nat :=
  sumIf (fun x => x % 2 == 1) l

-- 2. sum of the elements less than the average of the list
def sumMatching2 (l : List Nat) : Nat :=
  sumIf (fun x => x < myAverage l) l

-- 3. sum of the elements NOT divisible by 3
def sumMatching3 (l : List Nat) : Nat :=
  sumIf (fun x => x % 3 != 0) l

-- 4. sum of the elements that are at least 3
def sumMatching4 (l : List Nat) : Nat :=
  sumIf (fun x => x >= 3) l

#eval sumMatching1 nums     -- 20  (3 + 7 + 9 + 1)
#eval sumMatching2 nums     -- 10  (3 + 2 + 4 + 1)
#eval sumMatching3 nums     -- 22  (7 + 2 + 4 + 1 + 8)
#eval sumMatching4 nums     -- 37  (3 + 7 + 9 + 4 + 6 + 8)


/- =====================================================================
   GROUP 3 (CSE - Data Science) : listMatching
   ===================================================================== -/

-- 1. the even elements, in original order
def listMatching1 (l : List Nat) : List Nat :=
  keepIf (fun x => x % 2 == 0) l

-- 2. the elements greater than the average, in original order
def listMatching2 (l : List Nat) : List Nat :=
  keepIf (fun x => x > myAverage l) l

-- 3. the elements divisible by 3, in original order
def listMatching3 (l : List Nat) : List Nat :=
  keepIf (fun x => x % 3 == 0) l

-- 4. the elements that are at most 3, in original order
def listMatching4 (l : List Nat) : List Nat :=
  keepIf (fun x => x <= 3) l

#eval listMatching1 nums    -- [2, 4, 6, 8]
#eval listMatching2 nums    -- [7, 9, 6, 8]
#eval listMatching3 nums    -- [3, 9, 6]
#eval listMatching4 nums    -- [3, 2, 1]
