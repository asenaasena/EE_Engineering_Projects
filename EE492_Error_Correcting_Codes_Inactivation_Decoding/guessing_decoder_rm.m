%%%%%%%%%%%%%%%GUESSING DECODER%%%%%%%%%%%%%%%%%
 clear all
%%
%%%%%%%%%%INITIALIZATION%%%%%%%%%%

max_nframe=200;
p=0.01:0.01:0.5; % p:error probability
nframe=zeros(length(p),1);
ml_decoder=zeros(length(p),1);
peeling_solved=zeros(length(p),1);
guessing_used=zeros(length(p),1);
guessing_success=zeros(length(p),1);
guessing_fail=zeros(length(p),1);
number_guess=zeros(length(p),1);
tekrar_deneme=zeros(length(p),1);
ferrs=zeros(length(p),1);
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



   while (nframe(err)<max_nframe)  %&& (ferrs(err)<ferlim)  %Monte-Carlo Simulation
       rx=rx_seed+0.5*(rand(1,h_col)<p(err)) ;%%received message with erasures
      


nframe(err)=nframe(err)+1;
indice=[];
       indice2=[];
       new_matrice=[];
       new_matrice2=[];
       mult=[];
       mult2=[];
       flag=0;
        
       rest_new_rx=rx;
       indice=find((rx==0.5)|(rx==1.5));
       new_rx=rx(indice)
       rest_new_rx(indice)=0; %%gonna add the effect of erasure later
       new_matrice=parity(:,indice);
       mult=mod(parity*rest_new_rx',2);
      
 
[row, col]=size(new_matrice);
%%
%%%%%%%%%%%%%%%%%%%%INACTIVATION DECODER

%%%%%%
if(col~=0)
if(gfrank(new_matrice)==col)%%%guessing decoder makes sense
    %%peeling decoder
  
    guess_indice=[];
    mem_guess=[];
    guess_memo=[];
         %%%first, try peeling decoder
     
    while(any(sum(new_matrice,2)==1)) %peel until you can 
           
           
       for a=1:col %peeling decoder
           
           for i=1:row
               [row_mem,col_mem]=find(new_matrice(i,:))
              row_mem=i
               if(length(col_mem)==1) %check every row if it includes only one '1' value
                   new_rx(col_mem)=mult(i)
                   mult=mult+new_matrice(:,col_mem)*new_rx(col_mem)
                   mult=mod(mult,2)
                   new_matrice(:,col_mem)=0 %if you find such a row, then remove column vector at column position of this 1 
                   
               end                
               
           end
       end 
    end
       
       rx(indice)=new_rx';
       rest_new_rx(indice)=new_rx';
      
       
       indice2=find((rest_new_rx==0.5)|(rest_new_rx==1.5));
       new_rx2=rest_new_rx(indice2);
     
       rest_new_rx(indice2)=0; %%gonna add the effect of erasure later
       new_matrice2=parity(:,indice2);
       mult2=mod(parity*rest_new_rx',2);
      
 
[row, col]=size(new_matrice2);
    
    if(any(new_matrice(:)))%which means peeling was not enough
     flag=1;
     guessing_used(err)=guessing_used(err)+1;
    end
         save_new_matrice=new_matrice2;
         save_mult2=mult2;
     
    while(any(mult2(:)))  %%%it means our guess was wrong
        new_matrice2=save_new_matrice;
        mult2=save_mult2;
       guess_memo=[];
       mem_guess=[];
        
        
        while(any(new_matrice2(:)))
    %d=[];
    d=find(sum(new_matrice2)==max(sum(new_matrice2)));% en çok 1'in bukunduğu columnı donduracak
    guess_indice=d(1);
    mem_guess=[mem_guess guess_indice]
 
    number=randi(2)-1  %%it randomly guesses 
     new_rx2(guess_indice)=number
   
    
     mult2=mult2+new_matrice2(:,guess_indice)*new_rx2(guess_indice);
    
     new_matrice2(:,guess_indice)=0
    
    while(any(sum(new_matrice2,2)==1)) %peel until you can 
            
       for a=1:col %peeling decoder
           
           for i=1:row
               [row_mem,col_mem]=find(new_matrice2(i,:))
              row_mem=i
               if(length(col_mem)==1) %check every row if it includes only one '1' value
                   new_rx2(col_mem)=mult2(i)
                   mult2=mult2+new_matrice2(:,col_mem)*new_rx2(col_mem)
                   mult2=mod(mult2,2)
                   new_matrice2(:,col_mem)=0 %if you find such a row, then remove column vector at column position of this 1 
                   
               end                
               
           end
       end 
    end
    
      tekrar_deneme(err)=tekrar_deneme(err)+1;  
    
     
        end
        
      rx(indice2)=new_rx2
      number_guess(err)=number_guess(err)+length(mem_guess);
      
    end

    
                if(rx_seed==rx)
             guessing_success(err)=guessing_success(err)+1
        else
            guessing_fail(err)=guessing_fail(err)+1
        
        end 

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