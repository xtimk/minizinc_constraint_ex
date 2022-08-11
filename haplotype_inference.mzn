%% haplotype inference by pure parsimony problem

include "globals.mzn";

int: n = 4; % tuples of 4 elements (the size of genotypes and then of the haplotypes)
int: m = 3; % we have 3 tuples (number of genotypes for which we want to solve this)

%% genotype, to give as an input
array [1..m,1..n] of int: geno = 
[| 1,2,0,1,
 | 2,0,0,1,
 | 0,1,0,2
|];

array [1..2*m,1..n] of var 0..1: haplo;

%% the idea is that 
 %% haplo[1] and haplo[m] explains geno[1]
 %% haplo[2] and haplo[m+1] explains geno[2]
 %% etc...

constraint
  forall(i in 1..m, j in 1..n) (
    (geno[i,j] = 0 -> haplo[i,j] = 0 /\ haplo[m+i,j] = 0) /\
    (geno[i,j] = 1 -> haplo[i,j] = 1 /\ haplo[m+i,j] = 1) /\
    (geno[i,j] = 2 -> haplo[i,j] != haplo[m+i,j])
  );
  

% %% simmetry breaking. When geno says that haplo must be different I set that the second haplotype is 1 (and so the first haplo will be 0)
% constraint forall(i in 1..m, j in 1..n) (
%   if(geno[i,j] != geno[i+m,j]) then geno[i+m,j] = 1 endif
%   );
  
constraint forall(i in 1..m) (
  lex_less([haplo[i,j] | j in 1..n], [haplo[m+i,j] | j in 1..n])
);

array[1..2*m,1..2*m] of var 0..1: equals;

constraint
forall(i,j in 1..2*m where i < j)(
  sum(l in 1..n)(abs(haplo[i,l] - haplo[j,l])) > 0 
  <->
  equals[i,j] = 0
);

array[1..2*m] of var 0..1: representative;

constraint
  forall(i in 1..2*m) (
    sum(j in i+1..2*m) (equals[i,j]) = 0 <-> representative[i] = 1
  );
   
var int: e = sum(i in 1..2*m)(representative[i]);

solve minimize e;

output 
["[DBG]: Complete list of haplotypes "] ++
[
  if(j = 1) then ("\nHaplo " ++ format(i) ++ " - ") else " " endif ++
  show(haplo[i,j])
  | i in 1..2*m, j in 1..n
] 
++ ["\n\n[DBG]: Eq Matrix"] ++
[
  if(j = 1) then "\n" else " " endif ++
  show(equals[i,j])
  | i in 1..2*m, j in 1..2*m
] ++ ["\n\n[DBG]: Representative array: "] ++
[
  show(representative[i]) | i in 1..2*m
]
++ ["\n\n-------------\n\n ** Results **"]
++ ["\n\nMiminum number of haplotypes that explains the given genotypes: " ++ format(e)]
++ ["\n\nList of haplotypes "] ++
[
    if(fix(representative[i]) = 1) then
      if(j = 1) then ("\n - ") else " " endif ++
      show(haplo[i,j])
    else "" endif
  | i in 1..2*m, j in 1..n
]