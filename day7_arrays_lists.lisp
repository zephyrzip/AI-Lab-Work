;;; =====================================================================
;;; Day 7 : Lisp - Arrays and Lists in Lisp
;;; Artificial Intelligence Lab (CSE 3171)
;;; Contains: Common part + Group 1 + Group 2 + Group 3
;;; Load with:  (load "day7_arrays_lists.lisp")
;;;
;;; Arrays are fixed size and indexed with AREF (0-based).  Array
;;; functions take an explicit length N and recurse by counting the
;;; index down to 0.  Lists are walked with CAR / CDR.
;;; =====================================================================

;;; Sample array used by all the tests:
;;; (setq myarr (make-array 5 :initial-contents '(10 20 30 40 50)))

;;; ---------------------------------------------------------------------
;;; COMMON (all groups) : recursive sum of the first N array elements
;;; ---------------------------------------------------------------------
(defun sum-array (arr n)
  (if (= n 0)
      0
      (+ (aref arr (- n 1))
         (sum-array arr (- n 1)))))

;; Test cases
;; (setq myarr (make-array 5 :initial-contents '(10 20 30 40 50)))
;; (sum-array myarr 5)  => 150


;;; =====================================================================
;;; GROUP 1 (CSE)
;;; =====================================================================

;;; (1) Return the first N elements of array A as a list, in REVERSE
;;;     order, using index-counting recursion (no built-in REVERSE).
(defun array-reverse (a n)
  (if (= n 0)
      nil
      (cons (aref a (- n 1))            ; last element first
            (array-reverse a (- n 1)))))

;;; (2) Return the first N elements of array A as a list, ORIGINAL order.
;;;     A helper walks the index upwards.
(defun arr-list-from (a i n)
  (if (>= i n)
      nil
      (cons (aref a i) (arr-list-from a (+ i 1) n))))

(defun array-to-list (a n)
  (arr-list-from a 0 n))

;;; (3) Reverse an ordinary list with car / cdr / append (no REVERSE).
(defun my-reverse (lst)
  (if (null lst)
      nil
      (append (my-reverse (cdr lst))
              (list (car lst)))))

;;; (4) Flatten an arbitrarily nested list.
(defun my-flatten (lst)
  (cond ((null lst) nil)
        ((listp (car lst))
         (append (my-flatten (car lst))
                 (my-flatten (cdr lst))))
        (t (cons (car lst) (my-flatten (cdr lst))))))

;; Test cases (Group 1)
;; (setq myarr (make-array 5 :initial-contents '(10 20 30 40 50)))
;; (array-reverse myarr 5)        => (50 40 30 20 10)
;; (array-to-list myarr 5)        => (10 20 30 40 50)
;; (my-reverse '(1 2 3 4))        => (4 3 2 1)
;; (my-flatten '(1 (2 (3 4)) 5))  => (1 2 3 4 5)


;;; =====================================================================
;;; GROUP 2 (CSE)
;;; =====================================================================

;;; (1) Sum of only the even-valued elements of the first N elements.
(defun sumeven (a n)
  (cond ((= n 0) 0)
        ((= 0 (mod (aref a (- n 1)) 2))
         (+ (aref a (- n 1)) (sumeven a (- n 1))))
        (t (sumeven a (- n 1)))))

;;; (2) Does the value X occur in the first N elements of array A ?
(defun arrsrch (x a n)
  (cond ((= n 0) nil)
        ((eql x (aref a (- n 1))) t)
        (t (arrsrch x a (- n 1)))))

;;; (3) Remove the FIRST occurrence of a value from a list.
(defun rmelem (x l)
  (cond ((null l) nil)
        ((eql x (car l)) (cdr l))        ; drop it and stop
        (t (cons (car l) (rmelem x (cdr l))))))

;;; (4) Count the occurrences of a value in the first N array elements.
(defun count-occ-array (x a n)
  (cond ((= n 0) 0)
        ((eql x (aref a (- n 1)))
         (+ 1 (count-occ-array x a (- n 1))))
        (t (count-occ-array x a (- n 1)))))

;; Test cases (Group 2)
;; (setq myarr (make-array 5 :initial-contents '(10 20 30 40 50)))
;; (sumeven myarr 5)                 => 150
;; (arrsrch 20 myarr 5)              => T
;; (arrsrch 25 myarr 5)              => NIL
;; (rmelem 2 '(1 2 3 4 2))           => (1 3 4 2)
;; (count-occ-array 20
;;    (make-array 5 :initial-contents '(20 30 20 40 20)) 5)   => 3


;;; =====================================================================
;;; GROUP 3 (CSE - Data Science)
;;; =====================================================================

;;; (1) Smallest of the first N array elements.
(defun array-min (a n)
  (if (= n 1)
      (aref a 0)
      (let ((m (array-min a (- n 1))))
        (if (< (aref a (- n 1)) m) (aref a (- n 1)) m))))

;;; (2) 0-based index of a value in the array, or -1 if it is not there.
(defun asi-helper (x a i n)
  (cond ((>= i n) -1)
        ((eql x (aref a i)) i)
        (t (asi-helper x a (+ i 1) n))))

(defun array-search-index (x a n)
  (asi-helper x a 0 n))

;;; (3) Sum of every number of an arbitrarily nested list.
(defun flatten-sum (l)
  (cond ((null l) 0)
        ((listp (car l))
         (+ (flatten-sum (car l)) (flatten-sum (cdr l))))
        (t (+ (car l) (flatten-sum (cdr l))))))

;;; (4) Largest of the first N array elements.
(defun array-max (a n)
  (if (= n 1)
      (aref a 0)
      (let ((m (array-max a (- n 1))))
        (if (> (aref a (- n 1)) m) (aref a (- n 1)) m))))

;; Test cases (Group 3)
;; (setq myarr (make-array 5 :initial-contents '(10 20 30 40 50)))
;; (array-min myarr 5)                 => 10
;; (array-search-index 30 myarr 5)     => 2
;; (array-search-index 99 myarr 5)     => -1
;; (flatten-sum '(1 (2 (3 4)) 5))      => 15
;; (array-max myarr 5)                 => 50
