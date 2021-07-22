        EE242 THIRD Project 3: Secant and Bisection Methods

	In this project the aim is to implement secant and bisection algorithms in order to solve f(x)=0 for any given polynomial f.Program takes the coefficients
of the function, initial guesses and the tolerance value as command line arguments and return the resulting values of x as well as the numbers of iterations for each
method. I implement both methods separately first. Then I use a hybrid method where the program start with bisection methods for the first two iterations and then 
continue with secant method for the rest of the iterations. Program prints out the number of iterations required for each of the 3 methods (i.e., bisection, secant,
and hybrid).

 	User will plug in the inputs as command line arguments first the coefficients of the polynom from biggest one' to the constant term. Then user should plug in
the initial guesses first the small number and then the big number and at the end user should plug in the tolerance value. It is the enough convergence value. In order
to prevent the infinite number of iterations,program controls itself whether or not it is more than 10000 if it is so program will stop and print out "iteration 
number is more than 10.000".

	 The program is object oriented designed.Polynom class is defined. Inside this class,polynom initialization is made by dynamic memory allocation because before
running the program, size is unknown. It will be identified in main. In main part size will be defined. The array called coeff is allocated dynmically. Again before
running,the size is unknown. Inside the class, result function is defined which takes a number as input then plug into the polynom and returns the result of the polynom.
Bisection,secant,hybrid methods are seperately defined as funcitons inside the class.Hybrid method function must be above than the secant method function because
inside the hybrid method function secant method is used.

	The bisection method in mathematics is a root-finding method that repeatedly bisects an interval and then selects a subinterval in which a root must lie for 
further processing. It is a very simple and robust method, but it is also relatively slow. Because of this, it is often used to obtain a rough approximation to a
solution which is then used as a starting point for more rapidly converging methods.The method is applicable for numerically solving the equation f(x) = 0 for the
 real variable x, where f is a continuous function defined on an interval [a, b] and where f(a) and f(b) have opposite signs.
  
	In numerical analysis, the secant method is a root-finding algorithm that uses a succession of roots of secant lines to better approximate a root of a function f.
 The secant method can be thought of as a finite difference approximation of Newton's method.