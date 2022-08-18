%% Cumulative task problem
%% E.g. Find a way to schedule various tasks, which takes time and resources to be completed
%% So basically i will output a start time foreach task

include "globals.mzn";

%% number of tasks
int: n = 7;
array [1..n] of int: tasksDuration = [16,6,13,7,5,18,4];
array [1..n] of int: tasksRequiredResources = [2,9,3,7,10,1,11];

%% total resources available  
var int: totalResources;

array[1..n] of var 1..80: tasksStartingTime;
var 1..80: EndTime;


constraint
  forall(i in 1..n) (
    tasksStartingTime[i] + tasksDuration[i] <= EndTime
  )
;

constraint
  cumulative(tasksStartingTime, tasksDuration, tasksRequiredResources, totalResources)
;


%% for example: require that task 3 and 5 must start after task 1, AND task 7 must start after task 5
constraint
  tasksStartingTime[3] >= tasksStartingTime[1] + tasksDuration[1] /\
  tasksStartingTime[7] >= tasksStartingTime[5] + tasksDuration[5] /\
  tasksStartingTime[5] >= tasksStartingTime[1] + tasksDuration[1]
;

%% max resources available are 13 
constraint
  totalResources <= 13
;

%% We can solve this by minimize time, or by minimize needed resources, or by minimize the total cost (EndTime * totalResources)
solve minimize EndTime;
% solve minimize totalResources;
% solve minimize EndTime * totalResources;