include "globals.mzn";

int: n = 8;

array[1..n,1..n] of var 1..n: square;

solve satisfy;

constraint
  forall(i in 1..n) (
    all_different( [square[i,j] | j in 1..n] ) /\
    all_different( [square[j,i] | j in 1..n] )
  );

output [
  if(j = 1) then "\n" else " " endif ++
  show(square[i,j])
  | i, j in 1..n
]