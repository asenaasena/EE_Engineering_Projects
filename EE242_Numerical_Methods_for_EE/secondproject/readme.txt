 
  This code is written in order to find the dominant eigenvalue,its corresponding eigenvector and the second dominant eigenvalue. In this project, iteration with 
deflation algortihm is implemented. User must use 3 command line arguments.The first argument is the name of the file where the matrix is read from, the second argument
is the tolerance, which will be used in the normalized power iteration algorithm, and the third argument is the name of output file in txt format. Matrix will be read from a text 
file. This file and the cpp code must be in the same folder. It is assumed that "A.txt" file will contain the square matrice.

An example argument is : A.txt 0.0001 results.txt

Program will not print out the result. After implementing the code results.txt file will be created and results will be written inside the text file. Result will 
consists of first dominant eigen value its corresponding eigen vector and second eigenvalue.

  As it is mentioned above,  iteration with deflation and householder algorithms are used in the project.

  In order to allocate memory staticaly, size should be known because of that dynamical memory must be used because before running the program, size of the matrice 
is unknown.

  This project is designed as an object oriented;a class (an object) named Matrix is declared, and  all matrix operations such as multiplication, addition, transpose
 are implemented inside this class. In the main, the matrix in A.txt is read and assigned inside a dynamically allocated double array.Then this will be taken as an
input inside the matrix class. The size of the matrix will be identified in main with the help of getline. This size will be taken as input inside the class.

 Inside the class there is only 2 private members which are m and n,all of the others are public members.Because of that the functions can be used easily in main
and also functions can be used inside the other functions.Because they are in the same matrix class.

 Power iteration method sometimes causes problems. Starting vector is chosen random and this vector may have no component in the direction of the eigenvector but in 
practice because of the rounding it does not cause a problem. Also if there are more than one eigenvalue having the same modulus then iteration may converge to linear
combination of the corresponding eigenvectors. Also sometimes because of the rounding, values can be calculated a little bit more or less than it should be.
 
If user does not enter 3 command arguments, there will be an error message. Also in order to avoid infinite loop, I placed a counter inside the while loop, if counter
will surpass the 100 then program will stop.
  
 