% Use this editor as a MiniZinc scratch book

include "globals.mzn";

set of int: digits = 0..9;

var digits : S;
var digits : E;
var digits : N;
var digits : D;
var digits : M;
var digits : O;
var digits : R;
var digits : Y;

array [1..8] of var int : moneyArray = [S,E,N,D,M,O,R,Y];

constraint (1000*S + 100*E + 10*N + D) + (1000*M + 100*O + 10*R + E) == (10000*M + 1000*O + 100*N + 10*E + Y);

constraint S != 0;
constraint M != 0;

constraint all_different(moneyArray);

solve satisfy;

output [ 
  " " ++ show(S) ++ show(E) ++ show(N) ++ show(D) ++ " +" ++ "\n" ++
  " " ++ show(M) ++ show(O) ++ show(R) ++ show(E) ++ " =" ++ "\n" ++
  "-------" ++ "\n" ++
  show(M) ++ show(O) ++ show(N) ++ show(E) ++ show(Y) ++ "\n"
];