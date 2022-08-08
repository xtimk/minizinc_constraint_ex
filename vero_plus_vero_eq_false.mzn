% Use this editor as a MiniZinc scratch book

include "globals.mzn";

var 0..9 : V;
var 0..9 : E;
var 0..9 : R;
var 0..9 : O;
var 0..9 : F;
var 0..9 : A;
var 0..9 : L;
var 0..9 : S;

array [1..8] of var int : moneyArray = [V,E,R,O,F,A,L,S];

constraint (1000*V + 100*E +10*R + O) + (1000*V + 100*E +10*R + O) == (10000*F + 1000*A + 100*L + 10*S + O);

constraint V != 0;
constraint F != 0;

constraint all_different(moneyArray);

solve satisfy;

output [ 
  " " ++ show(V) ++ show(E) ++ show(R) ++ show(O) ++ " +" ++ "\n" ++
  " " ++ show(V) ++ show(E) ++ show(R) ++ show(O) ++ " =" ++ "\n" ++
  "-------" ++ "\n" ++
show(F) ++ show(A) ++ show(L) ++ show(S) ++ show(O) ++ "\n"
];