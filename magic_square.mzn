% magic square
% this needs to be optimized, since with n=6 solving time is higher than 1 minute
include "globals.mzn";

int: n = 5;
int: m = n*n;

array[1..n, 1..n] of var 1..n*n: square;

var int: magicSum;
magicSum = sum(i in 1..m)(i) div n;

solve satisfy;

constraint
  alldifferent([square[i,j] | i,j in 1..n]);
  
constraint
  forall(i in 1..n) (
    sum(j in 1..n) (square[i,j]) = magicSum /\
    sum(j in 1..n) (square[j,i]) = magicSum
  );

constraint
  sum(i in 1..n) (square[i,i]) = magicSum /\
  sum(i in 1..n) (square[i,n-i+1]) = magicSum;

% remove some simmetry
constraint
  square[1,1] < square[1,n] /\
  square[1,1] < square[n,1]
;

output [
  if(j = 1) then "\n" else " " endif ++
  show(square[i,j])
  | i, j in 1..n
]