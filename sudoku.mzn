% Use this editor as a MiniZinc scratch book

include "globals.mzn";

array [1..9,1..9] of var 1..9: square;

solve satisfy;

predicate row_all_different(int: r) = 
  all_different(c in 1..9) (square[r,c]); %% this is just a short-hand for list comprehensions

predicate col_all_different(int: c) = 
  all_different(r in 1..9) (square[r,c]);
  
predicate subquare_all_different(int: r, int: c) =
  all_different (i,j in 0..2) (square[r+i,c+j]);


constraint
  forall(i in 1..9) (
    row_all_different(i) /\ col_all_different(i) 
  );

constraint
  forall(i,j in {1,4,7}) (
    subquare_all_different(i,j)
  );
  
constraint
  square = 
    [| 3, _, 6, 5, _, 8, 4, _, _
     | 5, 2, _, _, _, _, _, _, _
     | _, 8, 7, _, _, _, _, 3, 1
     | _, _, 3, _, 1, _, _, 8, _
     | 9, _, _, 8, 6, 3, _, _, 5
     | _, 5, _, _, 9, _, 6, _, _
     | 1, 3, _, _, _, _, 2, 5, _
     | _, _, _, _, _, _, _, 7, 4
     | _, _, 5, 2, _, 6, 3, _, _
     |];

output [
  if(j = 1) then "\n" else " " endif ++
  show(square[i,j])
  | i, j in 1..9
]