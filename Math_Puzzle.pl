%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:   Archit Verma <architv@student.unimelb.edu.au>    
% Purpose:  Solve Mathematical Puzzles                       
%
% A maths Puzzle, which is a square grid of squares, each
% to be filled with a single digit 1-9, such that:
% -each row and each column has no repeated digits.
% -all squares on the diagonal line from upper left to
%  lower right contain the same value.
% -the heading of each row and column holds either the 
%  sum or the product of all digits in that row or column.
%
% The goal of the puzzle is to fill in all the squares 
% according to the rules. A proper maths puzzle will have
% at most one solution.

% EXAMPLE
%  __ __ __ __              __ __ __ __
% |  |14|10|35|            |  |14|10|35|
% |14|  |  |  |            |14| 7| 2| 1|
% |15|  |  |  |            |15| 3| 7| 5|
% |28|  | 1|  |            |28| 4| 1| 7|
%
%
% ASSUMPTIONS
%
% -Argument to the predicate puzzle_solution/1 will be a 
% proper list of proper lists.
% -All header squares of the puzzle (plus the ignored corner
% square) are bound to integers.
% -Soe of the other squares in the puzzles may also be bound
% to integers, but the others will be unbound.
% -If the puzzle is not solvable, the predicate should return
% fail.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- use_module(library(apply)).
:- use_module(library(clpfd)).
%
% Libraries used are apply, SWIPL and clpfd.
%

% The main predicate
% puzzle_solution(Puzzle) holds when Puzzle is the represent-
% -ation of a solved maths puzzle.
%
% transpose is to change the columns to rows for testing
% since our predicates are designed to test rows.
% digit is to check all elements are digits from 1 to 9.
% no_duplicates is to ensure there is no repetition along
% rows and columns.
% same_diagonal is to check whether all the values in the
% top left to bottom right diagonal are same.
% valid_header checks if the heading values are either the
% sum or product of values in that row or column.


puzzle_solution(Puzzle):-
    transpose(Puzzle,InversePuzzle),
    digit(Puzzle),
    no_duplicates(Puzzle), no_duplicates(InversePuzzle),
    same_diagonal(Puzzle),
    valid_header(Puzzle),valid_header(InversePuzzle),
    ground_vars(Puzzle).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Puzzle squares are to be filled with digits between 1 to 9.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% digit/1 holds true if all the values in the puzzle are digits
% between 1 to 9.
% it checks if rows are rows of digits.
%
% The terms '#=' or '#=<' are arthemetic constraints from the
% clpfd library. (https://www.swi-prolog.org/man/clpfd.html)
% for reference. They subsume and supersede low-level predicates
% over integers and are true relations.

digit(Puzzle):-
    Puzzle = [[_|Header]|Rows],
    maplist(#=<(1), Header),
    maplist(row_digits, Rows).

% row_digits/1 inputs the row and holds if each element
% satisfies the above mentioned condition.

row_digits([Heading|Row]):-
    Heading #>=1,
    Row ins 1..9.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Each row and each column contains no repeated digits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% no_duplicates/1 holds when the none of the rows have any
% repeated values

no_duplicates(Puzzle):-
    Puzzle = [_|Rows],
    maplist(unique_values, Rows).

% unique_values/1 checks each row for having unique elements
unique_values([_|Row]):-
    all_distinct(Row).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All squares on the diagonal line from upper left to lower
% right contain the same value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% same_diagonal/1 holds true if all the diagonal values are
% same. It does so by taking the first puzzlr row and 
% obtaining the first value, and then using same_diag_value/1
% to check other diagonal values.

same_diagonal([_Headrow|[Firstrow|Rows]]):-
    nth0(1, Firstrow, X),
    same_diag_value(Rows, 2, X).

% same_diag_value/1 holds when nth element of nth row is equal
% to the n+1th element of n+1th row.

same_diag_value([],_,_).

same_diag_value([Row|Rows], Nth, X) :-
    nth0(Nth, Row, X),
    Next #= Nth + 1
    same_diag_value(Rows, Next, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The heading of each row and column holds either the sum or
% the product of all the digits in that row or column.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% valid_header/1 ensures that each heading row is either sum 
% or product of the elements in that row with the help of
% valid_header_rows/1.

valid_header(Rows):-
    Rows = [_|Puzzlerows],
    maplist(valid_header_rows, Puzzlerows).

valid_header_rows([Heading|Row]):- sum(Row, #=, Heading).
valid_header_rows([Heading|Row]):- product(Row, 1, Heading).

product([], X, X).
product([Y|Ys], A, X):-
    A1 #= Y*A
    product(Ys, A1, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ground_vars/1 holds when all the variables are ground.

ground_vars([_Headingrow|Rows]) :- maplist(label, Rows).