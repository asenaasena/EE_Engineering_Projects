%%%%%%%%%%%%%%%GUESSING DECODER%%%%%%%%%%%%%%%%%
 clear all
%%correct algorithm
%%%%%%%%%%INITIALIZATION%%%%%%%%%%

max_nframe=200;
ferlim=100
p=0.2:0.01:0.5; % p:error probability
nframe=zeros(length(p),1);
ml_decoder=zeros(length(p),1);
peeling_solved=zeros(length(p),1);
size_stopping=zeros(length(p),1);
guessing_used=zeros(length(p),1);
guessing_success=zeros(length(p),1);
guessing_fail=zeros(length(p),1);
number_guess=zeros(length(p),1);
tekrar_deneme=zeros(length(p),1);
guessing_number=zeros(length(p),1);
ferr=zeros(length(p),1);
full_rank=zeros(length(p),1);
ferrs=zeros(length(p),1);
mem_guess=[];

%%

%Reed-Muller Generator Matrix and H matrice implementation
% 
h_row=64;       %row number of h matrice
h_col=128;      %column number of h matrice
rx_size=h_col;
m = 7;
n = 2^m;
r = 3;
G = [1 0;1 1];
GN = 1;
for i =1:m
    GN = kron(G,GN);
end
weights = sum(GN,2);%column vector containing the sum of the row
indices = find(weights >= 2^(m-r));
new_GN= GN(indices,:);
[row col]=size(new_GN);
[A_before,diagonal_GN]=diagonal(new_GN); %makes the left part of the matrice identity matrice

%%

parity=diagonal_GN(:,[65:end]);
parity=[transpose(parity) eye(64)];



         rx_seed = diagonal_GN(1,:); %message sent

        for err=1:length(p)/2 %for each error value



     while (nframe(err)<max_nframe)  && (ferrs(err)<ferlim)  %Monte-Carlo Simulation
       rx=rx_seed+0.5*(rand(1,h_col)<p(err)) ;%%received message with erasures
      
      
       
       indice=[];
       new_matrice=[];
       mult=[];
       new_rx=[] ;
       
      
       rest_new_rx=rx;
       indice=find((rx==0.5)|(rx==1.5)); %erased 
       new_rx=rx(indice);
       rest_new_rx(indice)=0; %%add the effect of erased variable nodes later
       new_matrice=parity(:,indice);
       flag=0;%%shows there is no inactivation applied
       guess_flag=0;
       mult=mod(parity*rest_new_rx',2);%non-erased 
     
[row, col]=size(new_matrice);
new_matrice_memo=[];
mult_memo=[];
new_matrice_memo=new_matrice
mult_memo=mult;
%%
%%%%%%%%%%%%%%%%%%%%GUESSING DECODER%%%%%%

if( any(new_matrice(:)))
 
%%%%%%
if(gfrank(new_matrice)==col) %%%guessing decoder makes sense
      
nframe(err)=nframe(err)+1;
    %%peeling decoder
 
    
 while( any(new_matrice(:))) %if it is full-rank but needed inactivation
    
     %%%first, try peeling decoder
     
    while(any(sum(new_matrice,2)==1)) %peel until you can 
            [row,col]=size(new_matrice);
            %display("peelinge girdi");
       for a=1:col %peeling decoder
           
           for i=1:row
               row_mem=[];
               col_mem=[];
               [row_mem,col_mem]=find(new_matrice(i,:));
              row_mem=i;
               if(length(col_mem)==1) %check every row if it includes only one '1' value
                   new_rx(col_mem)=mult(i);
                   rx_look=new_rx;
                   mult=mult+new_matrice(:,col_mem)*new_rx(col_mem);
                   mult=new_mode(mult,40);
                   %multiply and yana at,update et
                   new_matrice(:,col_mem)=0; %if you find such a row, then remove column vector at column position of this 1 
                   
               end                
               
           end
       end 
    end
    
     rx(indice)=new_rx';
        message_solved=[];
       message_solved=rx;
       
     if((flag==0)&(rx==rx_seed))
         peeling_solved(err)=peeling_solved(err)+1
     end
    %%
   %while(rx~=rx_seed)
      guess_indice=[];
    
       
    
    if(any(new_matrice(:))~=0)%which means peeling was not enough
        
     if(flag==0) %where first time guessing
         size_stopping(err)=size_stopping(err)+gfrank(new_matrice);
         guessing_used(err)= guessing_used(err)+1
         new_matrice_memo=[];
         new_rx_memo=[];
         new_matrice_memo=new_matrice;
         new_rx_memo=new_rx;
         
     end
        flag=1;
         dd=[];
    
    dd=find(sum(new_matrice)==max(sum(new_matrice)));% en çok 1'in bukunduğu columnı donduracak
    guess_indice=dd(1);
    
    if(guess_flag==0)
    number=randi(2)-1  %%it randomly guesses 
     new_rx(guess_indice)=number
     guess_flag=1
    else
       new_number=abs(number-1)  %%it randomly guesses 
     new_rx(guess_indice)=new_number
    end
    
    guessing_number(err)=guessing_number(err)+1;
     mult=mult+new_matrice(:,guess_indice)*new_rx(guess_indice);
     new_matrice(:,guess_indice)=0;
      
     

      contr=[];
   contr=find(sum(mult,2)==0)%here we check if there is any contradiction
   if(mult(contr)~=0)
 mult=[];
 mult=mult_memo
 new_matrice=[];
 new_matrice=new_matrice_memo;
 
   else 
      guess_flag=0
      mult_memo=[];
      new_matrice_memo=[]
        rx(indice)=new_rx;
       
   
    end
     

    end
   
     
   %end of guessing decoder procedure
 

  % end
   
     %if we have a contradictory we go back to above
 end
   
  if((rx==rx_seed)&(flag==1))
      guessing_success(err)=guessing_success(err)+1
      flag=0
    
  end
else
  ferr(err)=ferr(err)+1 %%rank is not sufficient
      
 
end

end

     
     end
        end
        
        %%
        %%
        figure()
       
        semilogy(p',guessing_used./nframe,'-x');
xlabel("Erasure Probability")
ylabel("Number of Frames where Guessing is used")
title("RM(3,7)")
grid on;grid minor
set(gca,'YScale','log')
 figure()
       
        semilogy(p',number_guess./guessing_used,'-x');
xlabel("Erasure Probability")
ylabel("Average Number of Guesses")
title("RM(3,7)")
grid on;grid minor
set(gca,'YScale','log')
 figure()
       
        semilogy(p',tekrar_deneme./guessing_used,'-x');
xlabel("Erasure Probability")
ylabel("Number of Guess of Total Set")
title("RM(3,7)")
grid on;grid minor
set(gca,'YScale','log')

        %