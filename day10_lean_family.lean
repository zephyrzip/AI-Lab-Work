/-
  =====================================================================
  Day 10 : Lean 4 - Family Relations
           Sibling, Grandchild, Aunt/Uncle & Cousin checks
  Artificial Intelligence Lab (CSE 3171)
  Contains: Common part + Group 1 + Group 2 + Group 3

  Day 1's Prolog family tree, now as a List (String x String) of
  (Parent, Child) pairs, searched with our own functions instead of
  Prolog's built-in search.

  Building blocks used (all allowed by the lab sheet):
    pr.1 / pr.2      first / second component of a pair
    l.any  (fun x => p x)    true if p holds for at least one element
    l.filter (fun x => p x)  keep the elements for which p is true
    l.map  (fun x => f x)    apply f to every element
    l.length, l1 ++ l2, l.eraseDups, ==, !=, &&, ||, >=
  =====================================================================
-/

/- ---------------------------------------------------------------------
   COMMON (all groups) : the family, exactly as given
   --------------------------------------------------------------------- -/
def parents : List (String × String) :=
  [ ("rahul","arjun"), ("rahul","neha"),
    ("sita","arjun"),  ("sita","neha"),
    ("arjun","vivek"), ("arjun","meena"),
    ("geeta","vivek"), ("geeta","meena"),
    ("amit","rani"),   ("neha","rani") ]

def isParent (p c : String) : Bool :=
  parents.any (fun pr => pr.1 == p && pr.2 == c)

#eval isParent "rahul" "arjun"    -- true
#eval isParent "arjun" "rahul"    -- false

/- Every person that appears in the family, each listed once.
   (We need this list so that "there exists a person z such that ..."
   can be written with `any`, the way Prolog searches for a variable.) -/
def allPeople : List String :=
  (parents.map (fun pr => pr.1) ++ parents.map (fun pr => pr.2)).eraseDups

#eval allPeople
-- ["rahul", "sita", "arjun", "geeta", "amit", "neha", "vivek", "meena", "rani"]


/- ---------------------------------------------------------------------
   The four relations as Bool checks (Group 1 asks for these directly;
   Groups 2 and 3 count them / test a threshold on them).
   Prolog reading is given beside each one.
   --------------------------------------------------------------------- -/

-- sibling(X,Y) :- parent(Z,X), parent(Z,Y), X \= Y.
def isSibling (x y : String) : Bool :=
  x != y && allPeople.any (fun z => isParent z x && isParent z y)

-- grandchild(X,Y) :- parent(Y,Z), parent(Z,X).
def isGrandchild (x y : String) : Bool :=
  allPeople.any (fun z => isParent y z && isParent z x)

-- auntOrUncle(X,Y) :- parent(P,Y), sibling(X,P).
def isAuntOrUncle (x y : String) : Bool :=
  allPeople.any (fun p => isParent p y && isSibling x p)

-- cousin(X,Y) :- parent(PX,X), parent(PY,Y), sibling(PX,PY).
def isCousin (x y : String) : Bool :=
  allPeople.any (fun px =>
    allPeople.any (fun py =>
      isParent px x && isParent py y && isSibling px py))


/- =====================================================================
   GROUP 1 (CSE) : check a pair
   ===================================================================== -/

-- 1. isSibling x y
#eval isSibling "arjun" "neha"        -- true
#eval isSibling "arjun" "vivek"       -- false

-- 2. isGrandchild x y  (x is y's grandchild)
#eval isGrandchild "vivek" "rahul"    -- true
#eval isGrandchild "neha" "rahul"     -- false

-- 3. isAuntOrUncle x y  (x is y's aunt or uncle)
#eval isAuntOrUncle "arjun" "rani"    -- true
#eval isAuntOrUncle "arjun" "vivek"   -- false

-- 4. isCousin x y
#eval isCousin "vivek" "rani"         -- true
#eval isCousin "vivek" "meena"        -- false


/- =====================================================================
   GROUP 2 (CSE) : count the relations
   Idea: keep the people q for whom the relation holds, then take length.
   ===================================================================== -/

-- 1. how many siblings p has
def countSiblings (p : String) : Nat :=
  (allPeople.filter (fun q => isSibling p q)).length

-- 2. how many grandchildren p has
def countGrandchildren (p : String) : Nat :=
  (allPeople.filter (fun q => isGrandchild q p)).length

-- 3. how many aunts or uncles p has
def countAuntsOrUncles (p : String) : Nat :=
  (allPeople.filter (fun q => isAuntOrUncle q p)).length

-- 4. how many cousins p has
def countCousins (p : String) : Nat :=
  (allPeople.filter (fun q => isCousin q p)).length

#eval countSiblings "arjun"           -- 1   (neha)
#eval countGrandchildren "rahul"      -- 3   (vivek, meena, rani)
#eval countAuntsOrUncles "rani"       -- 1   (arjun)
#eval countCousins "vivek"            -- 1   (rani)


/- =====================================================================
   GROUP 3 (CSE - Data Science) : threshold test (>= 2) on the counts
   ===================================================================== -/

-- 1. at least two siblings
def hasAtLeastTwoSiblings (p : String) : Bool :=
  countSiblings p >= 2

-- 2. at least two grandchildren
def hasAtLeastTwoGrandchildren (p : String) : Bool :=
  countGrandchildren p >= 2

-- 3. at least two aunts or uncles
def hasAtLeastTwoAuntsOrUncles (p : String) : Bool :=
  countAuntsOrUncles p >= 2

-- 4. at least two cousins
def hasAtLeastTwoCousins (p : String) : Bool :=
  countCousins p >= 2

#eval hasAtLeastTwoSiblings "arjun"           -- false  (only 1 sibling)
#eval hasAtLeastTwoGrandchildren "rahul"      -- true   (3 grandchildren)
#eval hasAtLeastTwoGrandchildren "amit"       -- false  (0)
#eval hasAtLeastTwoAuntsOrUncles "rani"       -- false  (only 1)
#eval hasAtLeastTwoCousins "rani"             -- true   (vivek, meena)
#eval hasAtLeastTwoCousins "vivek"            -- false  (only rani)
