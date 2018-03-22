# suso

### About

Suso is a very simple Sudoku puzzle solver written in IA32 Assembly language.
Because of the calling conventions it will only run on *BSD, but can be easily
adapted to run on Linux.

### Building
~~~
% make
~~~

### Usage

Write your puzzle into a file, where a '0' represents a missing number, and pipe
it into suso.

### Example
~~~
0 8 0 9 5 0 0 0	6
0 0 0 0 0 0 0 0	7
0 0 0 1 0 6 2 0 0
0 0 3 6 0 0 7 9 0
8 0 0 0 9 0 0 0 1
0 9 1 0 0 3 6 0 0
0 0 4 3 0 1 0 0 0
6 0 0 0 0 0 0 0 0
7 0 0 0 6 4 0 5 0
~~~
~~~
% suso < sudoku.txt
1 8 2 9 5 7 3 4 6
3 6 5 2 4 8 9 1 7
9 4 7 1 3 6 2 8 5
4 2 3 6 1 5 7 9 8
8 7 6 4 9 2 5 3 1
5 9 1 7 8 3 6 2 4
2 5 4 3 7 1 8 6 9
6 1 8 5 2 9 4 7 3
7 3 9 8 6 4 1 5 2
~~~

