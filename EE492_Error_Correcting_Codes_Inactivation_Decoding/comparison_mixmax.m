%%Implementation of PEELING DECODER in Binary Erasure Channel(BEC)%%%%%%%%%%
%%%%

%%%%%%%trial min-max inactivation

clear all
%%
%%%%%%%%%%INITIALIZATION%%%%%%%%%%

max_nframe=5000;
ferlim=500;
p=0.05:0.05:0.5; % p:error probability
%p=0.35
nframe=zeros(length(p),1);
inactivation_used=zeros(length(p),1);
inactivation_used2=zeros(length(p),1);
size_stopping=zeros(length(p),1);
size_stopping2=zeros(length(p),1);
frozen=zeros(length(p),1);
ferrs=zeros(length(p),1);
frozen2=zeros(length(p),1);
ferrs2=zeros(length(p),1);
inactivation_success=zeros(length(p),1);
inactivation_fail=zeros(length(p),1);
inactivation_success2=zeros(length(p),1);
inactivation_fail2=zeros(length(p),1);
edge_count=0;
dumm=[];
%%

%Reed-Muller Generator Matrix and H matrice implementation
% 
h_row=64;       %row number of h matrice
h_col=128;      %column number of h matrice
rx_size=h_col;
m = 7;
n = 3^m;
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

        for err=1:length(p) %for each error value
%err=35

%while(1)
   while (nframe(err)<max_nframe)  && (ferrs(err)<ferlim)  %Monte-Carlo Simulation
       rx=rx_seed+0.5*(rand(1,h_col)<p(err)) ;%%received message with erasures
      
      
       
       indice=[];
       new_matrice=[];
       mult=[];
       new_rx=[] ;
       
      
       rest_new_rx=rx;
       rx2=rx;
       indice=find((rx==0.5)|(rx==1.5)); %erased 
       new_rx=rx(indice);
       new_rx2=rx(indice);
       rest_new_rx(indice)=0; %%add the effect of erased variable nodes later
       new_matrice=parity(:,indice);
       flag=0;%%shows there is no inactivation applied
       mult=mod(parity*rest_new_rx',2);%non-erased 
     
[row, col]=size(new_matrice);
%%
%%%%%%%%%%%%%%%%%%%%INACTIVATION DECODER%%%%%%
nframe(err)=nframe(err)+1;
if( any(new_matrice(:)))
%%%%%%
if(gfrank(new_matrice)==col) %%%inactivation decoder makes sense
    %%peeling decoder
    coeff=10;
    count=1;
    freeze_indice=[];
    mem_freeze=[];
    
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
    %%
   
       message_solved=[];
       rx(indice)=new_rx';
       new_rx2=new_rx;
       rx2=rx;
       message_solved=rx;
       new_matrice2=[];
       new_matrice2=new_matrice;
       mult2=mult
    
    if(any(new_matrice(:))~=0)%which means peeling was not enough
        
     if(flag==0) %where it starts inactivation
         size_stopping(err)=size_stopping(err)+gfrank(new_matrice);
         inactivation_used(err)=inactivation_used(err)+1;
         dumm=new_matrice
         edge_count=edge_count+length(dumm(dumm~=0))
     end
        flag=1;
     dd=[];
    
    dd=find(sum(new_matrice)==max(sum(new_matrice)));% en çok 1'in bukunduğu columnı donduracak
    freeze_indice=dd(1);
    mem_freeze=[mem_freeze freeze_indice];
    new_rx(freeze_indice)=coeff;
    rx_look=[];
    rx_look=new_rx;
     mult=mult+new_matrice(:,freeze_indice)*new_rx(freeze_indice);
     
     mult=new_mode(mult,40);
     new_matrice(:,freeze_indice)=0;
      coeff=coeff*10;
      count=count+1;
    end
 end
 
 
 

%
if(flag==1)
    frozen(err)=length(mem_freeze)+frozen(err);
%
%%%%%%%%%%%%%%%%%
%%%gaussian elimination partla frozen olmuş bitleri bulma
pseud_x=1;
for i=1:count-1
pseud_x=[pseud_x; pseud_x(end)*10] ;%create a matrice [ 1 10 100 .. ]
end

pseud_a=[];
pseud_a=zeros(length(mult),count);
res=[];
frozen_bits=[];
res=zeros(length(mult),1);

ccc=[];
for i=count:-1:1

    ccc=mod(mult,2*pseud_x(i));
ccc=floor(ccc./(pseud_x(i)));
pseud_a(:,i)=ccc;
end

res=pseud_a(:,1);
pseud_a(:,1)=[];

[frozen_bits,new_Al,b_l]=gauss_el(pseud_a,res);

%%
%silinen bitleri yerine koyma
pseud_f=[];
fff=[];
for i=count:-1:1

 fff=mod(new_rx,2*pseud_x(i));
fff=floor(fff./(pseud_x(i)));
pseud_f(:,i)=fff;
end
%%%
%%
%%finally answer
new_rx_new=pseud_f*[1; frozen_bits];
rx(indice)=new_rx_new;
end_res=[];
end_res=mod(rx,2);
if(end_res==rx_seed)
    inactivation_success(err)=inactivation_success(err)+1;
   
else
    inactivation_fail(err)=inactivation_fail(err)+1;
    
    break
end
end

else
    
    ferrs(err)=ferrs(err)+1; %number of unsolvable ones
 
 
end
end

first_num==length(mem_freeze)



       message_solved=[];
       rx(indice)=new_rx';
       message_solved=rx;
       new_matrice2=[];
       new_matrice2==new_matrice;
       flag=0
       count=1
    
    if(any(new_matrice2(:))~=0)%which means peeling was not enough
        
     if(flag==0) %where it starts inactivation
         size_stopping2(err)=size_stopping2(err)+gfrank(new_matrice2);
         inactivation_used2(err)=inactivation_used2(err)+1;
         dumm=new_matrice
         edge_count=edge_count+length(dumm(dumm~=0))
     end
        flag=1;
     dd=[];
    
    dd=find(sum(new_matrice2)==min(sum(new_matrice2)));% en çok 1'in bukunduğu columnı donduracak
    freeze_indice=dd(1);
    mem_freeze2=[mem_freeze2 freeze_indice];
    new_rx2(freeze_indice)=coeff;
    rx_look=[];
    rx_look=new_rx2;
     mult2=mult2+new_matrice2(:,freeze_indice)*new_rx2(freeze_indice);
     
     mult2=new_mode(mult2,40);
     new_matrice2(:,freeze_indice)=0;
      coeff=coeff*10;
      count=count+1;
    end
 %end
 
 
 

%
if(flag==1)
    frozen2(err)=length(mem_freeze2)+frozen2(err);
%
%%%%%%%%%%%%%%%%%
%%%gaussian elimination partla frozen olmuş bitleri bulma
pseud_x=1;
for i=1:count-1
pseud_x=[pseud_x; pseud_x(end)*10] ;%create a matrice [ 1 10 100 .. ]
end

pseud_a=[];
pseud_a=zeros(length(mult2),count);
res=[];
frozen_bits=[];
res=zeros(length(mult2),1);

ccc=[];
for i=count:-1:1

    ccc=mod(mult2,2*pseud_x(i));
ccc=floor(ccc./(pseud_x(i)));
pseud_a(:,i)=ccc;
end

res=pseud_a(:,1);
pseud_a(:,1)=[];

[frozen_bits2,new_Al,b_l]=gauss_el(pseud_a,res);

%%
%silinen bitleri yerine koyma
pseud_f=[];
fff=[];
for i=count:-1:1

 fff=mod(new_rx2,2*pseud_x(i));
fff=floor(fff./(pseud_x(i)));
pseud_f(:,i)=fff;
end
%%%
%%
%%finally answer
new_rx_new2=pseud_f*[1; frozen_bits];
rx2(indice)=new_rx_new2;
end_res=[];
end_res=mod(rx,2);
if(end_res==rx_seed)
    inactivation_success2(err)=inactivation_success2(err)+1;
   
else
    inactivation_fail2(err)=inactivation_fail2(err)+1;
    
   % break
end
end




second_num=length(mem_freeze2)





if(first_num~=second_num)
break
end
end

        end
%%
%%%%%%%PLOTTING%%%%%%%%%
% 

 
 figure();
semilogy(p',(frozen./inactivation_used),'-x');
 xlabel("Erasure Probability")
ylabel("Average Number of Inactivation")
title("RM(2,5)")
grid on;grid minor
set(gca,'YScale','log')
 figure()
 semilogy(p',(inactivation_used./nframe),'-x');
xlabel("Erasure Probability")
ylabel("Inactivation is used")
title("RM(2,5)")
grid on;grid minor
set(gca,'YScale','log')
figure()
 semilogy(p',(size_stopping./nframe),'-x');
xlabel("Erasure Probability")
ylabel("Size of Stopping Set for Full Rank Cases")
title("RM(2,5)")
grid on;grid minor
set(gca,'YScale','log')



