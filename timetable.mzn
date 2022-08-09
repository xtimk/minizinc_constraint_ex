include "globals.mzn";

int: courses = 5;
int: periods = 20; % 4 lecture periods in a day
int: rooms = 2;


%% here are listed constraints for professors: I can 
array [1..courses, 1..periods] of int: available;
%% here i list constraint on courses: e.g: two courses cannot be run in parallel
array [1..courses, 1..courses] of int: conflict;
% ?
array [1..courses] of int: requirements;
%% ToDo: add preferences: e.g: Professors prefers morning instead of afternoon. etc...


%% specify inputs
available = 
%% Monday |Tuesday| Wedn   |Thursday | Friday |
[|0,0,1,1, 1,1,1,1, 1,1,1,1, 0,1,1,0, 1,1,1,1
 |1,1,0,0, 1,0,1,1, 0,1,1,1, 1,1,1,1, 1,1,1,1
 |0,0,0,1, 1,1,1,0, 1,1,1,1, 0,1,1,1, 1,0,1,1
 |1,1,1,0, 0,0,1,1, 1,1,1,1, 1,1,1,1, 1,0,1,1
 |1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1, 1,1,1,1
 |];
 
conflict = 
[|0,1,0,0,1
 |1,0,0,1,0
 |0,0,0,0,1
 |0,1,0,0,1
 |1,0,1,1,0
 |]; 

% first course requires 6 slots, and so on..
requirements = [6,10,14,6,4];

array[1..courses,1..periods] of var 0..1: timetable;

solve satisfy;

%% require that each course must have the required number of hours (per week)
constraint
  forall(c in 1..courses) (
    sum([timetable[c, p] | p in 1..periods]) = requirements[c]
  );

%% require that 2 courses in conflict cannot be in the same timeslot
constraint
  forall(c1,c2 in 1..courses where c1 < c2) (
    if (conflict[c1,c2] = 1) then
      forall(p in 1..periods) (
        timetable[c1,p] + timetable[c2,p] <= 1 %% at period p only one course can be deployed.
      )
    endif
  );

%% require that we cant have more than 2 courses at same time (since we got only 2 rooms)
constraint
  forall(p in 1..periods) (
    sum([timetable[c,p] | c in 1..courses]) <= rooms
  );
  
%% require courses can be only deployed when available
constraint
  forall(c in 1..courses, p in 1..periods) (
    if (available[c,p] = 0) then
      timetable[c,p] = 0
    endif
  );
  




output [
  if(j = 1) then ("\nCourse " ++ format(i) ++ " - ") else " " endif ++
  show(timetable[i,j])
  | i in 1..courses, j in 1..periods
]