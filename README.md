# Minizinc models
Set of problems modelled by using minizinc, that can then be solved by using a constraint solver.

# List of problems modelled

## Send More Money
An old classic toy problem. The goal is to find an assignment of each letter into a number (from 1 to 9) in such a way that the following math expression holds:

`SEND + MORE = MONEY`

## Latin square
The classic latin square problem, with numbers instead of letters. Given a N x N, populate the square with numbers from 1 to N in such a way that in each row and column the numbers are all different

## Magic square
Given a N x N, populate the square with numbers from 1 to NxN in such a way that:
 - All numbers are different (e.g. use all numbers from 1 to NxN)
 - The sum of all numbers in the rows and columns and the 2 diagonals must be the same.

## Sudoku
Not much to explain here. Note that this is very similar to the latin square problem.

## Timetable
Given
 - number of courses
 - number of timeslot in a week
 - number of rooms

and given constraints:
 - Courses in conflicts (courses that cannot be run at the same time)
 - Courses availability
 - Timeslots needed for each course (e.g. number of hours per week that each course needs)

Find a valid schedule for the courses over the timeslots.

## Encode generator
The problem is to find an encode for a set of words such that a minimum hamming distance is always granted.

In details, the input of this models consists in:
 - the desired length of each encoded word
 - the number of words that we want to encode
 - the minimum hamming distance that we want between words
 