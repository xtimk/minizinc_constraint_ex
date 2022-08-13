%% Travel salesman problem
%% E.g. find Hamiltonian circuit of a graph
%% Shortest path which visits all nodes exactly one time

include "globals.mzn";

% number of nodes of the graph
int: n = 5;

% distance matrix between each node of the graph
array [1..n,1..n] of int: distance =
[| 0,  49, 29, 54, 64
 | 49,  0, 66, 21, 69
 | 29, 66,  0, 48, 30
 | 54, 21, 48,  0, 50
 | 64, 69, 30, 50,  0
|];

%% In this example:
 % Node 1: Cordenons
 % Node 2: Udine
 % Node 3: Portogruaro
 % Node 4: Palmanova
 % Node 5: Bibione

array [1..n] of var 1..n: path; %% here path[i] will contain the node we want to visit after node i

% constraint
%   all_different(path);
  
constraint
  circuit(path);
  
array [1..n] of var int: d;

constraint
  forall(i in 1..n) (
    d[i] = distance[i, path[i]]
  );
  
var int: total_distance = sum(d);

solve minimize total_distance;

output
[
  "Total distance: " ++ show(total_distance)
]
++
[ 
  "\nPath: " ++
  show(path)
]