

  This code is written in order to find solutions of the problems in the form of Ax=b.Program first make partial pivoting,then makes Gaussian elimination
after changing the matrice upper triangular, by the backward substitution it finds the solution.Program takes two text files as an input. These files and the cpp code
 must be in the same folder. "A.txt" file should contain the square matrice and the "b.txt" file should contain the vector. This code finds unique solution if A is
 nonsingular,otherwise program will write "the matrice is singular". If the matrice's size is 2,then it will write also the condition numbers at 1 and infinity 
otherwise it will write nothing.

  Solution will be written into "programresults.txt". When detecting the singularity, the limit is identified as 0.000001. When taking care of the machine precision,
it is the limit where the numbers smaller than this value will be rounded into "0". Matrices are identified as float. 

  Dynamical memory must be used because before running the program, size of the matrice is unknown. With the help of the pointers dynamical arrays can be defined. 

  Code writes the condition numbers at 1 and infinity. For size 2 case condition numbers at 1 and infinity will be the same because when taking inverse of an 2 size matrice undiagonal 
elements will change and for the max row summation will be the same for inverse matrice's max column summation.

 When the examples are analyzed, their condition numbers are 4003.81 which is really high. High condition number means that the matrice is close to singular.When the
different b examples are taken into account, it can be seen that such a small change '0.001' in b effects the solution too much. For the first b case, x vector will 
be [2 0] and for the other case b will be [1.00012 0.999881]. From this equation it can be seen that the matrices with high condition number is too sensitive and 
little changes can cause very big consequences. If the matrice had a small condition number it would not be so much affected.  