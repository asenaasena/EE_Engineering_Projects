%%Implementation of Guessing DECODER%%%%%%%%%%
%%%%toy example with simple cases
tic;
clear all
%%
%received code after Binary Erasure Channel(BEC)

max_nframe=200;
%ferlim=10;

p=0.01:0.01:1; % p:error probability
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

h_row=4;       %row number of h matrice
h_col=8;      %column number of h matrice
rx_size=h_col;
%classical H matrice Reed Müller code implementation obtained from generator matrice


% = reduced_form(new_GN,row,col)


parity=[1 1 0 1 1 0 0 0; 1 0 1 1 0 1 0 0; 1 1 1 0 0 0 1 0; 0 0 1 0 0 1 1 1];

%%

        rx_seed = [1, 1 , 0 , 1, 1 , 0 , 0, 0]; 


for err=1:length(p)/2 %for each error value

    while (nframe(err)<max_nframe) %% && (ferrs(err)<ferlim)  %iterate
       rx=rx_seed+0.5*(rand(1,h_col)<p(err)) ;%%erasure in received vector
     %rx=[ 0.5 , 0.5, 0.5,1,1,0,0,0.5];
       %%
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

%     
%                 if(rx_seed==rx)
%              guessing_success(err)=guessing_success(err)+1
%         else
%             guessing_fail(err)=guessing_fail(err)+1
%         
%         end 

end

end 
    end
end
%%
%%%%%%%PLOTTING%%%%%%%%%
% 
% 
% % grid on;grid minor
% set(gca,'YScale','log')
%  figure();
% semilogy(p',(peeling_solved./nframe),'-x');
% 
%  hold on
%  semilogy(p',(ml_decoder./nframe),'-x');


toc;