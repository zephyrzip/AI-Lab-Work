;;; =====================================================================
;;; Day 6 : Lisp - Numbers and Lists in Lisp
;;; Artificial Intelligence Lab (CSE 3171)
;;; Contains: Common part + Group 1 + Group 2 + Group 3
;;; Load with:  (load "day6_numbers_lists.lisp")
;;; Everything is written recursively, without the built-in versions.
;;; =====================================================================

;;; ---------------------------------------------------------------------
;;; COMMON (all groups) : mypow - base raised to a non-negative power
;;; ---------------------------------------------------------------------
(defun mypow (bse exp)
  (if (= exp 0)
      1
      (* bse (mypow bse (- exp 1)))))

;; Test cases
;; (mypow 2 5)  => 32
;; (mypow 3 0)  => 1
;; (mypow 5 3)  => 125


;;; =====================================================================
;;; GROUP 1 (CSE)
;;; =====================================================================

;;; (1) Count the elements of a list, by recursion (no built-in LENGTH).
(defun my-length (lst)
  (if (null lst)
      0
      (+ 1 (my-length (cdr lst)))))

;;; (2) Membership : does M occur in LST ? (no built-in MEMBER)
(defun my-member (m lst)
  (cond ((null lst) nil)
        ((equal m (car lst)) t)
        (t (my-member m (cdr lst)))))

;;; (3) Count the positive numbers in a list.
(defun count-positive (lst)
  (cond ((null lst) 0)
        ((> (car lst) 0) (+ 1 (count-positive (cdr lst))))
        (t (count-positive (cdr lst)))))

;;; (4) Product of all the numbers of a non-empty list.
(defun list-product (lst)
  (if (null (cdr lst))
      (car lst)
      (* (car lst) (list-product (cdr lst)))))

;; Test cases (Group 1)
;; (my-length '(a b c d))            => 4
;; (my-length '())                   => 0
;; (my-member 'c '(a b c d))         => T
;; (my-member 'z '(a b c d))         => NIL
;; (count-positive '(4 -2 8 -5 6))   => 3
;; (list-product '(2 3 4))           => 24


;;; =====================================================================
;;; GROUP 2 (CSE)
;;; =====================================================================

;;; (1) Nth Fibonacci number, by recursion.
(defun fibonacci (n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (t (+ (fibonacci (- n 1))
              (fibonacci (- n 2))))))

;;; (2) GCD of two numbers by Euclid's algorithm (no built-in GCD).
(defun my-gcd (x y)
  (if (= y 0)
      x
      (my-gcd y (mod x y))))

;;; (3) Prime test for N > 1, trying divisors from 2 upwards.
(defun prime-helper (n d)
  (cond ((> (* d d) n) t)              ; no divisor up to sqrt(n) -> prime
        ((= 0 (mod n d)) nil)          ; d divides n              -> not prime
        (t (prime-helper n (+ d 1)))))

(defun is-prime (n)
  (if (<= n 1)
      nil
      (prime-helper n 2)))

;;; (4) Number of digits of a positive integer (repeated division by 10).
(defun digit-count (n)
  (if (< n 10)
      1
      (+ 1 (digit-count (floor n 10)))))

;; Test cases (Group 2)
;; (fibonacci 7)        => 13
;; (fibonacci 10)       => 55
;; (my-gcd 48 18)       => 6
;; (my-gcd 12 0)        => 12
;; (is-prime 17)        => T
;; (is-prime 15)        => NIL
;; (digit-count 4938)   => 4
;; (digit-count 7)      => 1


;;; =====================================================================
;;; GROUP 3 (CSE - Data Science)
;;; =====================================================================

;;; (1) Nth triangular number, by recursive addition (not the formula).
(defun triangular (n)
  (if (= n 0)
      0
      (+ n (triangular (- n 1)))))

;;; (2) Largest number of a non-empty list, by recursion.
(defun my-max (l)
  (if (null (cdr l))
      (car l)
      (let ((m (my-max (cdr l))))
        (if (> (car l) m) (car l) m))))

;;; (3) Smallest number of a non-empty list, by recursion.
(defun my-min (l)
  (if (null (cdr l))
      (car l)
      (let ((m (my-min (cdr l))))
        (if (< (car l) m) (car l) m))))

;;; (4) Count the negative numbers in a list.
(defun count-negative (l)
  (cond ((null l) 0)
        ((< (car l) 0) (+ 1 (count-negative (cdr l))))
        (t (count-negative (cdr l)))))

;; Test cases (Group 3)
;; (triangular 6)                    => 21
;; (triangular 1)                    => 1
;; (my-max '(4 8 2 10 6))            => 10
;; (my-min '(4 8 2 10 6))            => 2
;; (count-negative '(4 -2 8 -5 6))   => 2
