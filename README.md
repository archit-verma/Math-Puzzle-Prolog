# Math-Puzzle-Prolog #
Prolog code to solve maths puzzles. __puzzle_solution(Puzzle)__ holds when Puzzle is the representation of a solved maths puzzle.
A maths puzzle is represented as a list of lists, each of the same length, representing a single row of the puzzle. The first element of each list is considered to be the header for that row. Each element but the first of the first list in the puzzle is considered to be the header of the corresponding column of the puzzle. The first element of the first element of the list is the corner square of the puzzle, and thus is ignored.

For example,
the program would solve the above puzzle as below:

?- Puzzle=[[0,14,10,35],[14,_,_,_],[15,_,_,_],[28,_,1,_]],
|   puzzle_solution(Puzzle).

Puzzle = [[0, 14, 10, 35], [14, 7, 2, 1], [15, 3, 7, 5], [28, 4, 1, 7]] ;
false.
