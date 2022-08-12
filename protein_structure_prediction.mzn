%% Protein structure prediction
include "globals.mzn";

int: n = 16;
%% here input the protein as a list of amino acids. Only two amino acids are allowed (0,1)
array [1..n] of var 0..1: protein = 
% [1,0,0,1,0,1,0,0,1,0,1,0,0,0,1,0];
[1,0,0,1,0,0,1,0,0,1,0,0,1,0,0,1];

array [1..2*n,1..2*n] of var -1..1: space;

array [1..n] of var 0..2*n: x; %% x coordinate  x[i] = 5
array [1..n] of var 0..2*n: y; %% y coordinate

%% energy between proteins (E.G number of contacts between 1 proteins). 
% The idea is to specify foreach couple of protein the energy generated.
array [1..n,1..n] of var 0..1: energy;

var int: e;

%% x[i] = 5, y[i] = 6 means that the element proteines[i] is in position (5,6)
%% why x and why can contain vars from 0 to 2*n. Since we decide to put the first element of proteines at the center: (n,n)
 
% NEXT CONSTRAINT: states that each proteines[i] must be next to proteines[i+1] in the 2d space.
constraint
  forall(i in 1..n-1) (
    abs(x[i] - x[i+1]) + abs(y[i] - y[i+1]) = 1
  );

% NO OVERLAP: a single point in the 2d space cannot be occupied by more than 1 protein
% 1) First approach: naive
constraint
  forall(i,j in 1..n where i < j) (
    x[i] != x[j] \/ y[i] != y[j]
  );

% 2) Second approach: consider that we already have some constraints on NEXT
% that states that proteins[i] and proteins[i+1] must be at distance 1.
% And so they must be in different positions
% So we can skip constraints on next items and constraint only on i,i+2 items
% We can reason on the distance: we can just say that these elements must have distance >= 1 and we are done.
% constraint
%   forall(i in 1..n-1, j in i+2..n) (
%     abs(x[i] - x[j]) + abs(y[i] - y[j]) >= 1
%   );
%% this 2) approach works bad, because is using abs, which works really bad in constraint programming.

%% break simmetries
constraint
  x[1] = n /\ y[1] = n /\
  x[2] = n /\ y[2] = n+1;
  
% 3) Third approach: consider using big-M strategy:
% x1 != x2 /\ y1 != y2 can be written in: 10000*x1 + y1 != 10000*x2 + y2
% where 10000 has to be big enought, out of the possible values (the domain) of x1,x2,y1,y2
% Here I'll use this strategy combined with all_different
% array [1..n] of var int: pairs;
% int: bigM = n;
% constraint
%   forall(i in 1..n) (
%     pairs[i] = bigM*x[i] + y[i]
%   );
% constraint
%   all_different(pairs);
%% This should be working better, but it seems not: the first opt is always going very better: 40secs vs 7 secs

%% constraint on energy
constraint
  forall(i,j in 1..n where i < j) (
    if (abs(x[i] - x[j]) + abs(y[i] - y[j]) = 1 /\ protein[i] = 1 /\ protein[j] = 1) then energy[i,j] = 1 else energy[i,j] = 0 endif
  );
  
constraint
  e = sum(i,j in 1..n where i < j) (energy[i,j]);


%% Constraint on space array just to smart ouput. Is not necessary for solving the problem
constraint
  forall(i in 1..n) (
    space[x[i],y[i]] = protein[i]
  );
  
% solve maximize e;
solve :: int_search(x++y, first_fail,  indomain_min)
%      :: restart_constant(10000)
%       :: restart_linear(10000)
%       :: restart_geometric(1.2,500)
%         :: restart_luby(100000)
%restart_none;
       maximize e;
output 
[
  "Proteins: " ++ show(protein) ++
  "\nx: " ++ show(x) ++ 
  "\ny: " ++ show(y) ++ 
  "\ne: " ++ show(e) ++ "\n"
]
++
["\nSpace 2d\n"]
++
[
  if(j = 1) then "\n" else " " endif ++
  if(fix(space[i,j]) = -1) then "-" else show(space[i,j]) endif
  | i,j in 1..2*n
]