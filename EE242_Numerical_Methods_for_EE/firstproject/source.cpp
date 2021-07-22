#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
//cmath library is added in order to execute abs() function.
	using namespace std;
//In the beginning, some functions are defined.
//First one is called rowchange function. It takes A matrice,b vector and 2 row numbers. For both b and A,function changes the corresponding rows.

		void rowchange(float **A,int size,int row1,int row2,float *b){
	int i;
	float temp;
	for(i=0;i<size;i++){
//basically before assigning one row to another we have to use temp variable and assign first row into the temp,then the second into the first and temp into the second. Naturally it is needed to use "for loop" for the matrice but not for the vector.
	temp=A[row1][i];
	A[row1][i]=A[row2][i];
	A[row2][i]=temp;
	}	
		{
	temp=b[row1];
	b[row1]=b[row2];
	b[row2]=temp;

		}
}

	void findingmax(float **A,int size,float *b){
//findingmax function takes matrice A,vector b and size as inputs. This function is necessary for partial pivoting.For every column the row 
//which includes the greatest number in the corresponding column should be up. Code executes such that:it finds the biggest number in the first column and makes that row first row. Then it applies the same operation for the second column with the remaining rows, then makes it second row.Then
//it continues the same way. The reason is to place biggest numbers into pivots. It makes the dividing operations easy. By doing this the Gaussian
// elimination can be applied easier.Because without this function, even if the function is nonsingular,some zeros can be encountered in pivot position which is problem for Gaussian elimination.
// But with this function there is no reason to think about the possibility of zeros in pivot position where the function is nonsingular.  

	int i,j=0;
	float max;
		int indexmemory=0;

for(j=0;j<size;j++){
//In order to find max value in the corresponding column,we assign the first value to the max,then by comparing the max with the other numbers, max number can be found but also
//the index number must be in the memory because we will use that index later.
	max=abs(A[j][j]);
		indexmemory=j;
		for(i=j;i<size;i++){
	if(abs(A[i][j])>max){
	max=abs(A[i][j]);
		indexmemory=i;
}
}
//After finding the row number which includes the max value we call the function rowchange and change the indexed row with the row corresponding column number. 
	rowchange(A,size,j,indexmemory,b);

}
}
//This function takes A matrice,2 rows and a column as inputs.It divides the value of the row2 element into row1 element which has corresponding value col.
//This function returns a float value. With this value Gaussian elimination can be made because we need to equate the elements under the pivots to 0.  
 		float pro(float **A,int row1,int row2,int col){
	float i;
		i=A[row2][col]/A[row1][col];
			return i;
}
//subst function subtract a proportinal value from rows which are under the pivots . That proportion can be found by the pro function. After subst function we can be sure that 
//the elements under the pivots are equal to '0'. After applying this function into the matrice, matrice becomes an upper triangular matrice.
	void subst(float **A,int size,int row1,int row2,float *b,float katsayi){
	int i;
	for(i=0;i<size;i++){
		A[row2][i]=A[row2][i]-(katsayi*A[row1][i]);
	}
	b[row2]=b[row2]-(katsayi*b[row1]);

}

	int main () {
  	string line;
  	int size=0;
  	int i,j=0;
//"A.txt" is the name of the input file which contains the matrice.We do not know the size of the matrice in the beginning because of that we can not simply define a matrice. First we have to find
//the size of the matrice. With the help of the getline function, lines will be read and for every line size counter will increase.At the end of the 
//process size will be identified.
  ifstream myfile ("A.txt");
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
  else cout << "Unable to open file A";
  //In order to be in a really safe situation the cursor is pulled into beginning and also clear commend is given.
  myfile.clear();
  myfile.seekg(0,ios::beg); 
  //By using dynamical memory,2 dimensional float matrice is declared. Now it can be declared because the size is identified before.The reason why we use dynamical
  //memory is that size is not known. If static memory was used even if the size is found above, it would cause an error. Matrice can be defined dynamically
  //by pointers.
   float** a=new float*[size];
    for(i = 0; i < size;i++)
    a[i] = new float[size];

      ifstream secfile ("A.txt");
  if (secfile.is_open())
  {
    //The matrice inside the A.txt file is written into a matrice.
    for(i=0;i<size;i++){
    for(j=0;j<size;j++){
    secfile>>a[i][j];

}
      
  }
  secfile.close();
  }

  else cout << "Unable to open file A"; 

cout<<endl;
//this is the part where the condition number at 1 and infinity is identified if the matrice dimension is 2×2. Condition number 1 is the absolutely biggest
// column summation and condition number at infinity is the absolutely biggest row summation. Since it is 2×2 matrice,there is no need to use for loop,
// conditions can be written seperately.It can be seen both from the implementaiton result and manually at 1 and infinity condition numbers are the same.
// Because when inversing a 2×2 matrice, 2 nondiagonal elements change their places. So the max row summation at infinity will be equal to the inverse of the 
//matrice's maximum column summation. So for the 2×2 case condition numbers will be equal.
	if(size==2){
	float connum1,connuminf,det;
	float stretching,shrinking;
	if(abs(a[0][0])+abs(a[1][0])>abs(a[0][1])+abs(a[1][1])){
		stretching=abs(a[0][0])+abs(a[1][0]);
	}else
		stretching=abs(a[0][1])+abs(a[1][1]);
//streching for condition number at 1 which is absolutely max column summation.
	if(abs(a[1][1])+abs(a[1][0])>abs(a[0][0])+abs(a[0][1])){
		shrinking=abs(a[1][1])+abs(a[1][0]);
	}else
//streching for condition number at 1 which is inverse of the matrice's absolutely max column summation.
		shrinking=abs(a[0][1])+abs(a[0][0]);
			det=(a[0][0]*a[1][1]-a[0][1]*a[1][0]);
				shrinking=shrinking/det;
					connum1=shrinking*stretching;
	cout<<connum1<<endl;


	if(abs(a[0][0])+abs(a[0][1])>abs(a[1][0])+abs(a[1][1])){
		stretching=abs(a[0][0])+abs(a[0][1]);
}else
//streching for condition number at infinity which is absolutely max row summation.
	stretching=abs(a[1][0])+abs(a[1][1]);

	if(abs(a[0][0])+abs(a[1][0])>abs(a[0][1])+abs(a[1][1])){
		shrinking=abs(a[0][0])+abs(a[1][0]);
}else
//streching for condition number at infinity which is inverse of the matrice's absolutely max row summation.
	shrinking=abs(a[0][1])+abs(a[1][1]);
	det=(a[0][0]*a[1][1]-a[0][1]*a[1][0]);
	shrinking=shrinking/det;
		connuminf=shrinking*stretching;
	cout<<connuminf<<endl;

}

// b vector is read from the file.
float* b = new float[size];
ifstream bfile ("b.txt");
  if (bfile.is_open())
  	{

    
	for( i = 0; i < size; i++){

	bfile>>b[i];
	}


	myfile.close();
	}
  else cout << "Unable to open file b"; 
//partial pivoting is made.
  findingmax(a,size,b); 



	int colindex,rowindex;
	float rate;
	for(colindex=0;colindex<size;colindex++){

	for(rowindex=colindex+1;rowindex<size;rowindex++){

	rate=pro(a,colindex,rowindex,colindex);

	subst(a,size,colindex,rowindex,b,rate);
	}

	}
//matrice becomes upper triangular.
//x is the solution vector.
	float x[size];
//It is the where the singularity is detected.If after all the above operations pivot is still less than 0.000001, the matrice is singular. The reason 
//for assigning not exactly the 0 is the machine precision problem. The code may not operate exactly correct. Without this condition a singular matrice
// can be taken as nonsingular.  
	for(j=size-1;j>-1;j--){
	if(abs(a[j][j])<0.0000001){
	cout<<"The matrice is singular.";
	//if the matrice is singular program exits.
		exit(1);
	}
// this is the part where the solution is found by backward substitution. Since matrice is now upper triangular and nonsingular it will have always a unique solution.
// Code starts from the last term and simply divide. Last term of the solution will be found. The other equations which includes the last term will be simplified in
// each case by using founded values of x.
		else
	x[j]=b[j]/a[j][j];
	for(i=0;i<j;i++){
	b[i]=b[i]-(a[i][j]*x[j]);
	}

	}

// solution x will be written into a text file.
	ofstream outputFile("programresults.txt");
	for(i=0;i<size;i++){
	outputFile << x[i]<<endl;
	}


  return 0;
}
