%%LDPC PEELING DECODER
tic;
clear all
%%
%received code after Binary Erasure Channel(BEC)

max_nframe=2000;
ferlim=100;

p=0.01:0.01:1; % p:error probability
nframe=zeros(length(p),1);
nframe2=zeros(length(p),1);
ferrs=zeros(length(p),1);
count=zeros(length(p),1);
stopping_set=zeros(length(p),1);
peeling_solved=zeros(length(p),1);%count array:keeps how many of code words can be decoded succeesfully for specific error value
number_of_iterations=zeros(length(p),1);
decoding_okey=zeros(length(p),1);
unable_to_decode=zeros(length(p),1);
peeling=zeros(length(p),1);
inactivation=zeros(length(p),1);
ML_Decoder_solved=zeros(length(p),1);

%%
h_row=64;       %row number of h matrice
h_col=128; 
ldpc_row=8;      %number of ones in every row of ldpc
ldpc_column=4;    %number of ones in every column of ldpc%column number of h matrice
rx_size=h_col;
unit_matrice=h_row/ldpc_column;
x=eye(unit_matrice);  %%identity matrice
%%random H parity check matrice generation
for i=1:ldpc_column
   for j=1:ldpc_row
       random_x = x(randperm(size(x, 1)), :);
       h_matrice([(i-1)*size(x)+1]:(size(x)*i), [(j-1)*size(x)+1]:(size(x)*j))=random_x; %placing permutation matrice to h matrice
   end
end

[row col]=size(h_matrice);
parity=h_matrice;

for err=1:length(p)/2 %for each error value

    while (nframe(err)<max_nframe) && (ferrs(err)<ferlim)  %iterate
       rx=rand(1,h_col)<p(err) ;%%erasure in received vector
       %%
       %Erasure Decoder
       indice=[];
       new_matrice=[];
       indice=find(rx);
       new_rx=ones(1,length(indice));  %%only take the erasure values in rx and create new_rx
       new_matrice=parity(:,indice);



       [row,col]=size(new_matrice);

       if(rank(new_matrice)==col)
           ML_Decoder_solved(err)= ML_Decoder_solved(err)+1;
       end 

       for a=1:col
           [row,col]=size(new_matrice);
           for i=1:row
               [row_mem,col_mem]=find(new_matrice(i,:));
               if(length(col_mem)==1) %check every row if it includes only one '1' value
                   new_rx(col_mem)=[];
                   number_of_iterations(err)=number_of_iterations(err)+1;
                   new_matrice(:,col_mem(1))=[]; %if you find such a row, then remove column vector at column position of this 1 
               end                
               if(isempty(new_rx)==1) %if all rx values are decoded(all zero) finish the loops
                   break
               end 
           end
       end 
       %%
       nframe(err)=nframe(err)+1;
       %checking if all the erasures can be decoded
       [row col]=size(new_rx);
       peeling(err)=peeling(err)+col;        
       if(isempty(new_rx)==1)
       %display("decoding is okey only with peeling decoder")
           peeling_solved(err,1)=peeling_solved(err,1)+1;     
       else
           nframe2(err)=nframe2(err)+1;
      if(gfrank(new_matrice)==col)
          stopping_set(err)=stopping_set(err)+gfrank(new_matrice);
           inactivation(err)=inactivation(err)+1;  
           ferrs(err)=ferrs(err)+1;
           end
       end
   end
end

%%

%plot(p,(inactivation/nframe2));

%title('Inactivation decoding')
grid on;grid minor
%set(gca,'YScale','log')
figure();
semilogy(p',ones(100,1)-(peeling_solved./nframe),'-x');

hold on
semilogy(p',ones(100,1)-(ML_Decoder_solved./nframe),'-o')
xlabel('Probability of Error')
ylabel('FER')
title('LDPC (64 X 128)')
hold on
grid on;grid minor
semilogy(p',ones(100,1)-((peeling_solved+inactivation)./nframe),'-d')
ldpc128_peeling = peeling_solved./nframe;
ML_Decoder_solved = ML_Decoder_solved./nframe;
peeling_solved_inactivation = (peeling_solved+inactivation)./nframe;
figure()
histogram(round(stopping_set./nframe))
title('LDPC 64X128 Histogram of rank of stopping sets')
figure()
stem(p',round(stopping_set./nframe))
title('LDPC 64X128 Rank of stopping sets')

% legend('Peeling Decoder','ML Decoder','Modified Inactivation Decoder')


toc;

Von meinem iPhone gesendet