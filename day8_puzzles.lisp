;;; =====================================================================
;;; Day 8 : Lisp - Puzzle Solving with Recursion
;;; Artificial Intelligence Lab (CSE 3171)
;;; Contains: Group 1 + Group 2 + Group 3
;;; Load with:  (load "day8_puzzles.lisp")
;;;
;;; General search skeleton used by the state-space puzzles:
;;;   1. if the state is a goal, return the path
;;;   2. else try every legal move that is not already visited, recurse
;;;   3. if no move reaches the goal, fail (return NIL)
;;; =====================================================================

;;; ---------------------------------------------------------------------
;;; Small helpers used in several places (written from first principles)
;;; ---------------------------------------------------------------------
(defun p-reverse (lst)                       ; own REVERSE
  (if (null lst)
      nil
      (append (p-reverse (cdr lst)) (list (car lst)))))

(defun p-remove-first (x l)                  ; drop the first copy of X
  (cond ((null l) nil)
        ((eql x (car l)) (cdr l))
        (t (cons (car l) (p-remove-first x (cdr l))))))

(defun p-member-equal (x l)                  ; own MEMBER using EQUAL
  (cond ((null l) nil)
        ((equal x (car l)) t)
        (t (p-member-equal x (cdr l)))))

(defun range-n (n)                           ; (1 2 ... n)
  (if (= n 0)
      nil
      (append (range-n (- n 1)) (list n))))


;;; =====================================================================
;;; GROUP 1 (CSE)
;;; =====================================================================

;;; ---------------------------------------------------------------------
;;; (1) WATER JUG : 4-litre and 3-litre jugs, unlimited supply.
;;;     State is (x y).  Moves: fill / empty / pour.
;;;     Goal: exactly 2 litres in the 4-litre jug.  Visited list stops loops.
;;; ---------------------------------------------------------------------
(defun jug-goal-p (state)
  (= (first state) 2))

(defun jug-moves (state)
  (let* ((x (first state))
         (y (second state))
         (p43 (min x (- 3 y)))               ; amount pourable 4L -> 3L
         (p34 (min y (- 4 x))))              ; amount pourable 3L -> 4L
    (list (list 4 y)                         ; fill the 4L jug
          (list x 3)                         ; fill the 3L jug
          (list 0 y)                         ; empty the 4L jug
          (list x 0)                         ; empty the 3L jug
          (list (- x p43) (+ y p43))         ; pour 4L -> 3L
          (list (+ x p34) (- y p34)))))      ; pour 3L -> 4L

(defun water-jug (state visited)
  (if (jug-goal-p state)
      (append visited (list state))
      (jug-try-moves (jug-moves state) (append visited (list state)))))

(defun jug-try-moves (moves visited)
  (cond ((null moves) nil)
        ((p-member-equal (car moves) visited)
         (jug-try-moves (cdr moves) visited))
        (t (or (water-jug (car moves) visited)
               (jug-try-moves (cdr moves) visited)))))

;; Test case
;; (water-jug '(0 0) nil)
;;   => ((0 0) (4 0) (4 3) (0 3) (3 0) (3 3) (4 2) (0 2) (2 0))


;;; ---------------------------------------------------------------------
;;; (2) EIGHT (N) QUEENS : one queen per column, none attacking.
;;;     A solution is the list of row positions, e.g. (2 4 1 3).
;;;     Built column by column, generate and test.
;;; ---------------------------------------------------------------------
(defun safe-p (row placed d)
  ;; PLACED is the list of already-placed rows, nearest column first.
  ;; D is the column distance to the head of PLACED.
  (cond ((null placed) t)
        ((= row (car placed)) nil)                        ; same row
        ((= (abs (- row (car placed))) d) nil)            ; same diagonal
        (t (safe-p row (cdr placed) (+ d 1)))))

(defun extend-one (partial rows)
  ;; every safe way of adding one more queen to PARTIAL
  (cond ((null rows) nil)
        ((safe-p (car rows) (p-reverse partial) 1)
         (cons (append partial (list (car rows)))
               (extend-one partial (cdr rows))))
        (t (extend-one partial (cdr rows)))))

(defun extend-all (partials rows)
  (if (null partials)
      nil
      (append (extend-one (car partials) rows)
              (extend-all (cdr partials) rows))))

(defun queen-solve (k n)
  ;; all safe placements of K queens in the first K columns of an N x N board
  (if (= k 0)
      (list nil)                                  ; one empty placement
      (extend-all (queen-solve (- k 1) n) (range-n n))))

(defun queens (n)
  (queen-solve n n))

;; Test case
;; (queens 4)  => ((2 4 1 3) (3 1 4 2))
;; (length (queens 6))     => 4      ; a 6x6 board has 4 solutions


;;; ---------------------------------------------------------------------
;;; (3) PERMUTATIONS of a small list, recursively.
;;; ---------------------------------------------------------------------
(defun prefix-all (x perms)
  (if (null perms)
      nil
      (cons (cons x (car perms))
            (prefix-all x (cdr perms)))))

(defun perm-each (items lst)
  ;; for every item, put it first and permute what is left
  (if (null items)
      nil
      (append (prefix-all (car items)
                          (permute (p-remove-first (car items) lst)))
              (perm-each (cdr items) lst))))

(defun permute (lst)
  (if (null lst)
      (list nil)
      (perm-each lst lst)))

;; Test case
;; (permute '(1 2 3))
;;   => ((1 2 3) (1 3 2) (2 1 3) (2 3 1) (3 1 2) (3 2 1))     ; 6 permutations


;;; ---------------------------------------------------------------------
;;; (4) PALINDROME : is the list the same forwards and backwards ?
;;; ---------------------------------------------------------------------
(defun palindromep (l)
  (equal l (p-reverse l)))

;; Test cases
;; (palindromep '(1 2 3 2 1))  => T
;; (palindromep '(1 2 3 4))    => NIL


;;; =====================================================================
;;; GROUP 2 (CSE)
;;; =====================================================================

;;; ---------------------------------------------------------------------
;;; (1) RIVER CROSSING : farmer, fox, goose, beans.
;;;     State is (farmer fox goose beans), each LEFT or RIGHT.
;;;     fox+goose or goose+beans must never be left without the farmer.
;;; ---------------------------------------------------------------------
(defun other-side (s)
  (if (eq s 'left) 'right 'left))

(defun river-safe (st)
  (let ((f (first st)) (fx (second st)) (g (third st)) (b (fourth st)))
    (and (not (and (eq fx g) (not (eq f g))))      ; fox with goose, no farmer
         (not (and (eq g b)  (not (eq f g)))))))   ; goose with beans, no farmer

(defun keep-safe (states)
  (cond ((null states) nil)
        ((river-safe (car states))
         (cons (car states) (keep-safe (cdr states))))
        (t (keep-safe (cdr states)))))

(defun river-moves (st)
  (let* ((f (first st)) (fx (second st)) (g (third st)) (b (fourth st))
         (nf (other-side f)))
    (keep-safe
     (append (list (list nf fx g b))                         ; farmer alone
             (if (eq fx f) (list (list nf nf g b))  nil)     ; takes the fox
             (if (eq g  f) (list (list nf fx nf b)) nil)     ; takes the goose
             (if (eq b  f) (list (list nf fx g nf)) nil))))) ; takes the beans

(defun river-goal-p (st)
  (equal st '(right right right right)))

(defun river-cross (state visited)
  (if (river-goal-p state)
      (append visited (list state))
      (river-try-moves (river-moves state) (append visited (list state)))))

(defun river-try-moves (moves visited)
  (cond ((null moves) nil)
        ((p-member-equal (car moves) visited)
         (river-try-moves (cdr moves) visited))
        (t (or (river-cross (car moves) visited)
               (river-try-moves (cdr moves) visited)))))

;; Test case
;; (river-cross '(left left left left) nil)
;;   => ((LEFT LEFT LEFT LEFT) (RIGHT LEFT RIGHT LEFT) (LEFT LEFT RIGHT LEFT)
;;       (RIGHT RIGHT RIGHT LEFT) (LEFT RIGHT LEFT LEFT) (RIGHT RIGHT LEFT RIGHT)
;;       (LEFT RIGHT LEFT RIGHT) (RIGHT RIGHT RIGHT RIGHT))


;;; ---------------------------------------------------------------------
;;; (2) OPERATORS : insert + - * between consecutive numbers of a list so
;;;     that the expression, evaluated LEFT TO RIGHT, equals the target.
;;; ---------------------------------------------------------------------
(defun arith-try (acc rest target)
  (if (null rest)
      (= acc target)
      (or (arith-try (+ acc (car rest)) (cdr rest) target)
          (arith-try (- acc (car rest)) (cdr rest) target)
          (arith-try (* acc (car rest)) (cdr rest) target))))

(defun solve-arith (lst target)
  (if (null lst)
      nil
      (arith-try (car lst) (cdr lst) target)))

;; Test cases
;; (solve-arith '(2 3 5 7) 11)   => T        ; 2 - 3 + 5 + 7 = 11
;; (solve-arith '(2 3 5 7) 100)  => NIL


;;; ---------------------------------------------------------------------
;;; (3) POWER SET : all the subsets of a small list, recursively.
;;; ---------------------------------------------------------------------
(defun add-to-each (x subsets)
  (if (null subsets)
      nil
      (cons (cons x (car subsets))
            (add-to-each x (cdr subsets)))))

(defun powerset (l)
  (if (null l)
      (list nil)
      (let ((rest (powerset (cdr l))))
        (append rest (add-to-each (car l) rest)))))

;; Test case
;; (powerset '(1 2 3))
;;   => (NIL (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))     ; 8 subsets


;;; ---------------------------------------------------------------------
;;; (4) NEAR PALINDROME : the list differs from its own reverse in at
;;;     most one PAIR of positions (a mismatched pair shows up twice
;;;     when the list and its reverse are compared element by element).
;;; ---------------------------------------------------------------------
(defun count-diff (a b)
  (cond ((null a) 0)
        ((equal (car a) (car b)) (count-diff (cdr a) (cdr b)))
        (t (+ 1 (count-diff (cdr a) (cdr b))))))

(defun near-palindrome (l)
  (<= (count-diff l (p-reverse l)) 2))

;; Test cases
;; (near-palindrome '(1 2 3 2 9))  => T      ; only the two ends differ
;; (near-palindrome '(1 2 3 2 1))  => T      ; a true palindrome qualifies
;; (near-palindrome '(1 2 3 4))    => NIL


;;; =====================================================================
;;; GROUP 3 (CSE - Data Science)
;;; =====================================================================

;;; ---------------------------------------------------------------------
;;; (1) TOWER OF HANOI : move N disks from FROM to TO using VIA.
;;; ---------------------------------------------------------------------
(defun hanoi (n from to via)
  (if (= n 0)
      nil
      (progn
        (hanoi (- n 1) from via to)
        (format t "Move disk ~a from ~a to ~a~%" n from to)
        (hanoi (- n 1) via to from))))

;; Test case
;; (hanoi 3 'A 'C 'B)
;;   Move disk 1 from A to C
;;   Move disk 2 from A to B
;;   Move disk 1 from C to B
;;   Move disk 3 from A to C
;;   Move disk 1 from B to A
;;   Move disk 2 from B to C
;;   Move disk 1 from A to C


;;; ---------------------------------------------------------------------
;;; (2) COIN CHANGE : how many combinations of the given denominations
;;;     add up to the target amount ?
;;; ---------------------------------------------------------------------
(defun make-change (amount coins)
  (cond ((= amount 0) 1)                 ; one complete combination
        ((< amount 0) 0)                 ; overshot
        ((null coins) 0)                 ; no coins left
        (t (+ (make-change (- amount (car coins)) coins)   ; use this coin again
              (make-change amount (cdr coins))))))         ; skip this coin

;; Test cases
;; (make-change 5 '(1 2 5))   => 4    ; 1x5, 1x3+2, 1+2+2, 5
;; (make-change 4 '(1 2))     => 3


;;; ---------------------------------------------------------------------
;;; (3) STAIRCASE : ways to climb N steps taking 1 or 2 steps at a time.
;;;     count(N) = count(N-1) + count(N-2)
;;; ---------------------------------------------------------------------
(defun climb-stairs (n)
  (cond ((= n 0) 1)
        ((= n 1) 1)
        (t (+ (climb-stairs (- n 1))
              (climb-stairs (- n 2))))))

;; Test cases
;; (climb-stairs 5)  => 8
;; (climb-stairs 3)  => 3


;;; ---------------------------------------------------------------------
;;; (4) PARENTHESES CHECK : are the parentheses of a string balanced ?
;;;     A recursive depth counter walks the characters.
;;; ---------------------------------------------------------------------
(defun bal-helper (chars depth)
  (cond ((< depth 0) nil)                              ; closed too early
        ((null chars) (= depth 0))                     ; balanced iff back to 0
        ((char= (car chars) #\() (bal-helper (cdr chars) (+ depth 1)))
        ((char= (car chars) #\)) (bal-helper (cdr chars) (- depth 1)))
        (t (bal-helper (cdr chars) depth))))

(defun balancedp (s)
  (bal-helper (coerce s 'list) 0))

;; Test cases
;; (balancedp "(a(b)c)")  => T
;; (balancedp "(a(b)c")   => NIL
;; (balancedp ")a(")      => NIL
