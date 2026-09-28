# AI Lab (CSE 3171) — Day 1 to Day 10 solutions

Every file contains the **common part plus all three groups'** problems, with test
cases written as comments (as the lab notes require).

| File | Day | Language |
|---|---|---|
| `day1_family_tree.pl` | 1 — Facts & rules | SWI-Prolog |
| `day2_recursion.pl` | 2 — Numerical recursion | SWI-Prolog |
| `day3_lists.pl` | 3 — Lists | SWI-Prolog |
| `day4_cuts.pl` | 4 — Green & red cuts | SWI-Prolog |
| `day5_digital_circuits.pl` | 5 — Digital circuits | SWI-Prolog |
| `day6_numbers_lists.lisp` | 6 — Numbers & lists | Common Lisp |
| `day7_arrays_lists.lisp` | 7 — Arrays & lists | Common Lisp |
| `day8_puzzles.lisp` | 8 — Puzzles | Common Lisp |
| `day9_lean_recursion_lists.lean` | 9 — Functional recursion & lists | Lean 4 |
| `day10_lean_family.lean` | 10 — Family relations | Lean 4 |

## Running the Prolog files

```
$ swipl
?- ['day1_family_tree.pl'].
?- sibling(arjun, neha).
?- trace.        % step through a query
?- notrace.
?- halt.
```

Load **one day at a time**. A few helper names (`my_member/2`, `max2/3`) appear in
more than one day's file, so loading two files into the same session will make
SWI-Prolog print a redefinition warning.

## Running the Lisp files

```
> (load "day6_numbers_lists.lisp")
> (mypow 2 5)
32
```

For Days 7 and 8, create the sample array first:

```
> (setq myarr (make-array 5 :initial-contents '(10 20 30 40 50)))
```

## Running the Lean files

Easiest: open <https://live.lean-lang.org>, paste the file, and read the
`#eval` results in the right-hand panel. Offline: install `elan`, then use the
"Lean 4" VS Code extension and open the `.lean` file. No mathlib is needed.

Each `#eval` line has its expected value as a comment beside it. A red squiggle
means a type or syntax error at that spot.

## Notes on places where the question paper and the plain definition disagree

* **Day 1, Group 2 — Aunt.** Geeta is Rani's aunt *by marriage* (she is married to
  Rani's mother's brother), not a blood sibling of a parent, so `aunt/2` has a
  second clause for the marriage case. `uncle/2` and `niece/2` are handled the
  same way.
* **Day 1, Group 1 — Brother-in-law.** "Amit is a brother-in-law of Geeta" needs a
  third clause: the husband of your spouse's sibling.
* **Day 5, Group 2 — 4-to-1 MUX.** The sample answer `mux4(1,0,1,2,3,4,Out) → 3`
  uses non-binary data lines and the select index `2*S0 + S1`, so `mux4/7`
  cascades three *data-selecting* 2-to-1 muxes. A pure gate-level `mux4_g/7` is
  also included for binary data.
* **Day 8, Group 2 — Near palindrome.** `(1 2 3 2 9)` differs from its reverse at
  two *positions* but only one *pair*, so the check allows up to two differing
  positions.
* **Day 9 — "average".** Lean's `/` on `Nat` is integer division. For `nums` the
  average is exactly 40 / 8 = 5, so the tests match the sheet; for other lists
  the average is rounded down.
* **Day 9 — function shape.** Each `countMatchingN`, `sumMatchingN`,
  `listMatchingN` takes the list as an argument, so call them as
  `#eval countMatching1 nums`. They are all built from three small recursive
  helpers (`countIf`, `sumIf`, `keepIf`) that pattern-match on `[]` / `x :: xs`.
* **Day 10 — aunts/uncles.** The parent list has no marriage data, so
  aunts/uncles are *blood* relations only (a sibling of a parent). This is why
  `countAuntsOrUncles "rani"` is 1 (Arjun) and not 2 (Geeta is not counted), which
  is exactly what the sheet's expected answer says.
* **Day 10 — `allPeople`.** Lean has no Prolog-style "find any Z", so the file
  builds a duplicate-free list of everyone (`allPeople`) and searches it with
  `any` / `filter`.

