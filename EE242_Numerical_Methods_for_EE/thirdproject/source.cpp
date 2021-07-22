
#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <stdlib.h>
#include <stdio.h>
#include <iomanip>
#include <new>

	using namespace std;
        //class polynom is defined.
class polynom{
	    //degree is private member by default, it can be only used by the other members of the class.
	 int degree;
	 
	 public:
	 	float *p;
	 	//dynamic memory allocation
	 	//It is required because before running the program the size is unknown.
	 	polynom(int size){
	 		//size is defined in main an assigned into degree variable.
	 		degree=size;	
    		p= new float[degree];
		 }
		 //It is the function where the polynom's coefficent values are assigned into p array.User plugs the coefficients from the biggest to the smallest degree but the values inside
		 //the p array will be kept from smallest to biggest. 
	void plugin(float *k){
		 	for(int i=0;i<degree;i++){
		 		p[i]=k[degree-i-1];
			 }
		 }
		 //This function takes num as input and return the value of the polynom at that value. 
	double result(double num){
		double res=p[0];
		//constant is added
		for(int i=1;i<degree;i++){
			double mult=1;
		for(int j=0;j<i;j++){
			//here the input will be multiplied with itself its degree times.
			mult=mult*num;
		}
		//in the end it will multiplied with its coefficient. 
		mult=mult*p[i];
		//it will summed into result.At the next loop mult will be again 1 and the same procedure will be applied.
		res=res+mult;
		}
		return res;
	}
	
	    //bisection method
double *bisection(double tol,double bignum,double smallnum){
		//	The function values at bignum and smallnum are of opposite sign (there is at least one zero crossing within the interval).
		double *res=new double[4];
		double middle;
		double counter=0;
		//converge up td difference of numbers are less than the tolerance value. 
	while ((bignum-smallnum) >= tol)
    {
        // Find middle point
        //it will increase the precision
        middle= smallnum+(bignum-smallnum)/2;
       
        //iteration number
      counter++;
  if(result(middle)==0){
  		res[2]=counter;
    		res[3]=middle;
    		return res;
    		exit(1);
  }
 //if sign of the middle is the same with the bignum, at the next iteration middle will be bignum.
        if (result(middle)*result(smallnum) < 0)
            bignum = middle;
        else
            smallnum = middle;
            if(counter==100000){
            	cout<<"iteration number is too big more than 100000";
            	exit(1);
			}
            
    }
    //return value res is a dynamic array
            res[0]=bignum;
            res[1]=smallnum;
     		res[2]=counter;
    		res[3]=middle;
    		return res;
	}
	
	//secant method
	double *secantmethod(float toler,float bignum,float smallnum){
		double *res=new double[2];
		double zero=smallnum;
		double one=bignum;
		double two;
			two=((zero*result(one))-(one*result(zero)))/(result(one)-result(zero));
   //first iteration is made so counter is 1.
	int counter=1;
		while(abs(two-one)>toler){
			counter++;
			zero=one;
			one=two;
			two=((zero*result(one))-(one*result(zero)))/(result(one)-result(zero));
			//if the program does not find after too many iterations it will stop
			if(counter==100000){
            	cout<<"iteration number is too big more than 100000";
            	exit(1);
			}
		}
		
    res[0]=(two+one)/2;
    res[1]=counter;
		return res;	
	}
	
	//hybrid method
	double *hybridmethod(double tol,double bignum,double smallnum){
	
		double *root=new double[2];
		double middle;
		int count=0;
	//iteration will start with bisection method for 2 times
	for (int i=0;i<2;i++)
    {
    	count++;
    // Find middle point
        middle= (smallnum+bignum)/2;
         if (result(middle)*result(smallnum) < 0)
            bignum = middle;
            
        else
            smallnum = middle;
            if(abs(bignum-smallnum)<tol){
    //if the value is enough close when 1 iteration is made program will stop and return that value.
            root[0]=middle;
             root[1]=1;
             return root;
             exit(1);
			}
    }
    //after two iterations are made with bisection method the other iterations will be made with secant method.
		root=secantmethod(tol,bignum,smallnum);
		//root 1 keeps the count value.
		root[1]=root[1]+count;
		return root;
	}
};

int main(int argc, char** argv) {
	//argc is one more than the input number
  int inputnum=argc-1;
  float *coef;
  int i;
  //command line inputs consists of the coeffients,big number,small numbe and the tolerance value. Because of that size is 3 less than the input number.
  int size=inputnum-3;
  //dynamic mmeory allocation
  coef= new float[size];
  
    for (i=0; i<size; i++)
    {
    	//atof function must be used because argv keeps the inputs as string but we need to convert them into float
       coef[i]=atof(argv[i+1])  ;
    }
    //assigning small number
    float small=atof(argv[size+1]) ;
    //assigning big number
    float big=atof(argv[size+2]);
    //assigning tolerance
	float tol=atof(argv[size+3]);
	
	//initializing polynom
polynom first(size);
//plugging the values into coef array
first.plugin(coef);
//printing out the results

cout<<"bisection method iteration number is:"<<endl;
cout<<first.bisection(tol,big,small)[2]<<endl;
cout<<"root found by the bisection method is"<<endl;
cout<<first.bisection(tol,big,small)[3];
cout<<"+-"<<tol/2<<endl;
cout<<"secant method iteration number is:"<<endl<<first.secantmethod(tol,big,small)[1]<<endl;

cout<<"root found by the secant method is:"<<endl<<first.secantmethod(tol,big,small)[0];
cout<<"+-"<<tol/2<<endl;

cout<<"hybrid method iteration number is"<<endl<<first.hybridmethod(tol,big,small)[1]<<endl;
cout<<"root found by the hybrid method"<<endl<<first.hybridmethod(tol,big,small)[0];
cout<<"+-"<<tol/2<<endl;	

	return 0;
	
}
