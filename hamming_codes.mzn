include "globals.mzn";

int: n = 8; %% length of each encoded word
int: k = 10; %% number of words
int: d = 4; %% minimum hamming distance we want to require in the code.

array [1..k,1..n] of var 0..1: encoding;

solve satisfy;

constraint
forall(i,j in 1..k where i<j) (
  sum( [ abs(encoding[i,t] - encoding[j,t]) | t in 1..n] ) >= d
);

% simmetry breaking: set the first word to all 0. (I can do it,proved by a theorem). 
% This is really effective: without it the execution of the sat can really be long.
constraint
forall(j in 1..n)(
  encoding[1,j] = 0
);

% another simmetry breaking: force a lexicographical order of the words.
constraint
forall(i,j in 1..k where i < j)(
  lex_less([encoding[i,t] | t in 1..n],[encoding[j,t] | t in 1..n])
);


output [
  if(j = 1) then ("\nWord " ++ format(i) ++ " - ") else " " endif ++
  show(encoding[i,j])
  | i in 1..k, j in 1..n
]
