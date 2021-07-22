#include <iostream>
#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
#include <stdlib.h>
#include <stdio.h>
#include <iomanip>
#include <new>
	using namespace std;
	
	
	//Matrix class is defined. This class will be used in order to make matrix operations easier. 
	//Class name is "matrix".
class matrix
{ 
 // m,n are private members because by default, all members of a class declared with the class keyword have private access for all its members.
   int  m,n; 
   //since they have private access,they can only be referred to from within other members of that same class.
    public: 
    //Since p's values will be used in main,it should not be a private member because only the members of class have access to private members.
   float **p;
  
   matrix(int row, int col) 
   { 
   //Dynamic memmory allocation is used because in the beginning the size of the input matrix is unknown.
   //Referrings are made.
      m = row; 
      n = col; 
      p = new float*[m]; 
      for (int i = 0; i < m; i++) 
	 p[i] = new float[n]; 
	 //memory allocation error detection
	 if (p == NULL)
    cout << "Error: memory could not be allocated";
	  

   }
   void plugin(float **a) 
   {  
   //This function takes a 2 dimensional dynamical array as an input and equalizes the values of p[i][j] with a[i][j] values. 
   //This **a is constructed in main by reading from the text file.

      for(int i = 0; i < m; i++) 
      { 
	 for(int j = 0; j < n; j++) 
	 { 
	     p[i][j]=a[i][j]; 
	 } 
      } 
   } 
   void show() 
   { 
   //This function prints out the matrix.
   //It is a void function so it takes no input.
      
      for(int i = 0; i < m; i++) 
      { 
	 cout <<endl; 
	 for(int j = 0; j < n; j++) 
	 { 
	    cout << p[i][j] <<" "; 
	 } 
      } 
      cout<<endl;
   }

   matrix transpose(){
   	//Transpose function
   	//It takes no extra input. Here class property is used because of that there is no need for extra input. 
   	//This function returns transpose of the matrix.
   	matrix temp3(n,m);
   	
   	for(int i = 0; i < m; i++) 
      { 
	 
	 for(int j = 0; j < n; j++) 
	 { 
	 //temp should be used otherwise changing the values made on the original matrice will cause error.
	    temp3.p[j][i]=p[i][j]; 
	 } 
   }
   return temp3;
}
float vectordot(){
	//for a column matrix, matrice multiplication of the transpose of the matrix with itself gives a float value.Normally this calculation can be written 
	//by using transpose and multiplication functions but for the sake of simplicity for the column vectors' dotproducts can be calculated with this function.
	 
	float result=0;
	//result must be initialized as zero.
	for(int i=0;i<m;i++){
		result=result+p[i][0]*p[i][0];
	}
	return result;
	
}
   matrix multiplication (const matrix& T)
   {
   	//Matrix multiplication function
   	//Function takes one extra matrix. This matrix is also type of this class matrix. When matrix is called, the reference should be used. 
   	 matrix temp(m,T.n);
   	 //initializing the temp matrice
 
 for(int i=0;i<m;i++){
		   	 for(int j=0;j<T.n;j++){
		   	 	temp.p[i][j]=0;}}
 
 
		   for(int i=0;i<m;i++){
		   	 for(int j=0;j<T.n;j++){
		   	 	 for(int k=0;(k<n);k++)
            temp.p[i][j]+=(p[i][k])*(T.p[k][j]);
				}      
		   }
      return temp;
   }
   
   float findnorm(){
   	//This function finds the element of the matrice whose absolute value is the biggest.
float max;
int index=0;

max=abs(p[0][0]);
for(int i=0;i<m;i++){
	if(abs(p[i][0])>max){
			max=abs(p[i][0]);
			index=i;
	}

}
//Function return the float value of the value of the element whose absolute value is the biggest.
return p[index][0];
   }
    
    void division(float num){
    	//This function divides the matrice by a constant.
    	//It takes float number as an input and it is void function.
    	for(int i=0;i<m;i++){
    		for(int j=0;j<n;j++){
    		p[i][j]	=(p[i][j])/num;
			}
		
		 }
    	
	}
   
matrix addition (const matrix& rhs)
   {
   	//This function makes matrix addition.
   	matrix temp1(m,n);
      for(int i = 0; i < m; i++)
      {
	 for(int j = 0; j < n; j++)
	 {
	    temp1.p[i][j]=p[i][j]+rhs.p[i][j]; 
	 } 
      }      
      return temp1;
   }
   
   matrix subtraction (const matrix& rhs)
   {
   	//This function subtract matrices.
   	matrix temp2(m,n);
      for(int i = 0; i < m; i++)
      {
	 for(int j = 0; j < n; j++)
	 {
	    temp2.p[i][j]=p[i][j]-rhs.p[i][j]; 
	 } 
      }      
      return temp2;
   }
   matrix& operator= (const matrix& T)
   {
   	//equal sign is overloaded.
   	//With this function matrices can be equalized.
   	for(int i=0;i<m;i++){
   		for (int j=0;j<n;j++){
   			p[i][j] = T.p[i][j];
		   }
	   }
   	
      //Here the column and row numbers are assigned from left side into right side.
      n = T.n;
      m = T.m;
      
      return *this;
   } 
};	
    
	int main (int argc, char *argv[]){
		string line;
		float tolerance;
		//size must be 0 in the beginning otherwise random values will be assigned to it.
  	int size=0;
  	int i,j=0;
  	//argc number must be 1 more than the number of command lines.In this project there are 3 command variables.
  	if(argc==4){
  		
		float tolerance;
		//argv[] is a string variable. In order to convert string into float, atof function should be used. Corresponding library should be added.
		tolerance=atof(argv[2]);
		
	//Since matrice size is unknown first size must be identified.
		ifstream myfile (argv[1]);
  if (myfile.is_open())
  {
    while ( getline (myfile,line) )
    {
      size++;

    }
   
    //File should be closed because it is the part where the savings are done.
        myfile.close();
  }
//This part is error detection. It is shown whenever there is an error when opening the file.
  else cout << "Unable to open file inputfile";
  //In order to be in a really safe situation the cursor is pulled into beginning and also clear commend is given.
  myfile.clear();
  myfile.seekg(0,ios::beg); 
  //By using dynamical memory,2 dimensional float matrice is declared. Now it can be declared because the size is identified before.The reason why we use dynamical
  //memory is that size is not known. If static memory was used even if the size is found above, it would cause an error. Matrice can be defined dynamically
  //by pointers.
   float** a=new float*[size];
    for(i = 0; i < size;i++)
    a[i] = new float[size];
     if (a == NULL)
    cout << "Error: memory could not be allocated";
    

      ifstream secfile (argv[1]);
  if (secfile.is_open())
  {
    //The matrice inside the A.txt file is written into a matrice.
    for(i=0;i<size;i++){
    for(j=0;j<size;j++){
    secfile>>a[i][j];

}
      
  }
  //Closing the file.
  secfile.close();
  }
//error detection for closing the input file
  else cout << "Unable to open file inputfile"<<endl;

//memory should be allocated.
matrix anew(size,size);

//values should be plugged in.
anew.plugin(a); 

  float ratio,ratiomem,dominanteigen;
   float diff=100;
   //diff is defined very big in order to start to loop. 
   matrix eigenvector(size,1);
   
    // iteration with deflation algorithm will be implemented.
   //starting vector is defined
   matrix T(size,1);
   
   //this started vector is randomly constructed column vector whose elements are 1.
   for(int i=0;i<size;i++){
   	T.p[i][0]=1;
   }

//this value for the first matrice will be one. Inside the while loop 2 ratios will be used.
   ratiomem=T.findnorm();
  
   int turn=0;
   	while(diff>tolerance){
   		//It is the precaution for the case of infinite loop. If there is such a condition, program will stop and exit.
   				if(turn>100)
   				{
				   exit(1);
				   }
				   else{
	//anew matrix will be multiplied by T matrix.		
				   		T=anew.multiplication(T);
 		 		//resulting T's absolutely maximum element will be assigned to ratio.
 		 ratio=	T.findnorm();
 	// This ratio will be in the end the first dominant eigen value.
 		 dominanteigen=ratio;
 		 //abs should be added because we are not interested in the sign of the difference. maybe this difference will oscillate. If we do not add
 		 //absolute program will cut the iteration whenever difference is smaller than zero but normally if iteration could continue absolute of difference
 		 //colud be much smaller.
 		 diff=abs(abs(ratio)-abs(ratiomem));
 		 //before normalization ratio should be kept in memory in order to use it in the next step.
 		 ratiomem=ratio; 
 		 //normalization;
	 T.division(ratio);
	 //eigenvector is found.
	 eigenvector=T;
		 turn++;
				   }
 		 
	 }
	 //after finding first eigenvalue's corresponding eigenvector householder method will be used in order to make 0 the elements in the first column except the first element 
	 //of the matrix
	 
 	float ara,norms;
		matrix V(size,1);
		matrix e(size,1);
		matrix firstcolumn(size,1);
//finding the dot product of the eigenvector.
ara=eigenvector.vectordot();
 norms=sqrt(ara);

//e column vector is identified. Its first element is squareroot of the dot product and the other elements are 0.
  e.p[0][0]=norms;
 	for(int i=1;i<size;i++){
 		e.p[i][0]=0;
	 }
	 //In order to identify v matrice to apply householder algortihm sign must decided.e's sign must not be the same as the sign of the first element of the original matrix.
	 if(eigenvector.p[0][0]>0){
	 	V=eigenvector.addition(e);
	 }
	 else
	V=eigenvector.subtraction(e);
//identity matrice is constructed.
 matrix identity(size,size);
 for(int i=0;i<size;i++){
 	for(j=0;j<size;j++){
 		if(i==j){
 			identity.p[i][j]=1;
		 }
		 else
		 identity.p[i][j]=0;
	 }
 }

 matrix householder(size,size);
 matrix yan(size,size);
 matrix mal(1,size);

//V matrix's transpose will be multiplied with itself. As a result this will give us size by size matrix.
 mal=V.transpose();
 yan=(V.multiplication(mal));

float vnorm;
vnorm=V.vectordot();
//yan is the matrice which will be subtracted from the identity.
//result will be multiplied with 2.
 yan.division((0.5));
 yan.division(vnorm);
 
 //householder matrice is attained.
 householder=identity.subtraction(yan);
 
 matrix endd(size,size);
 //householder matrice should be multiplied with the A matrice and result shoul be multiplied with the inverse of the householder matrice but householder matrices' inverses are itself.
 //This property helps a lot. Otherwise it is needed to find the inverse of the matrice
 endd=householder.multiplication(anew);

 endd=endd.multiplication(householder);
 
 //what is needed the square matrice on the right and the bottom whose size is (size-1).
 matrix anew2(size-1,size-1);
 
 //the values will be obtained.
 for(int i=1;i<size;i++){
 	for(int j=1;j<size;j++){
 		anew2.p[i-1][j-1]=endd.p[i][j];
	 }
 }
 
 //This is the part where the second dominant eigenvalue is found.
 matrix T2(size-1,1);
   //again random starting vector is assigned but this time size will be one less value.
   for(int i=0;i<size-2;i++){
   	T2.p[i][0]=1;
   }
   
   T2.p[size-2][0]=1;

//same procedure as above will be applied.
   float ratiomem2=T2.findnorm();
   float dominanteigen2;
   float diff2=1000.0;
   float ratio2;
  

  
   	while(diff2>tolerance){
   		
 		
 		 	T2=anew2.multiplication(T2);
 		 	
 		 	
 		 ratio2=T2.findnorm();
 		 dominanteigen2=ratio2;
 		 diff2=abs(abs(ratio2)-abs(ratiomem2));

 		 ratiomem2=ratio2;
 		 
 		 
	 T2.division(ratio2);
	 
		 
	 }
//This is the part where the results would be written into the file.
//argv[3] is the string which is the name of the output file. 
 ofstream outputFile(argv[3]);
	{
		
	outputFile << dominanteigen<<endl;
	for(int i=0;i<size;i++)
	outputFile<< eigenvector.p[i][0]<<endl;
	outputFile<< dominanteigen2;
	
	}
}
//If user plugs in different than 4 command lines this will give error messsage.
  else
  cout<<"Invalid input try!!";
}
		
	
	
	

