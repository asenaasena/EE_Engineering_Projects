%%Implementation of PEELING DECODER%%%%%%%%%%
%%%%
tic;
clear all
%%
%received code after Binary Erasure Channel(BEC)

max_nframe=2000;
ferlim=1000;
p=0.1:0.01:0.5; % p:error probability
nframe=zeros(length(p),1);
ml_decoder=zeros(length(p),1);
peeling_solved=zeros(length(p),1);
ferrs=zeros(length(p),1);
rank_def=zeros(length(p),1);
size_stopping=zeros(length(p),1);
%%


%classical H matrice Reed Müller code implementation obtained from generator matrice


h_row=16;       %row number of h matrice
h_col=32;      %column number of h matrice
rx_size=h_col;
%classical H matrice Reed Müller code implementation obtained from generator matrice
m = 5;
n = 2^m;
r = 2;
G = [1 0;1 1];
GN = 1;
for i =1:m
    GN = kron(G,GN);
end
weights = sum(GN,2);%column vector containing the sum of the row
indices = find(weights >= 2^(m-r));
new_GN= GN(indices,:);
[row col]=size(new_GN);
[A_before,diagonal_GN]=diagonal(new_GN)

%%

parity=diagonal_GN(:,[17:end]);
parity=[transpose(parity) eye(16)];


%%

        rx_seed = diagonal_GN(1,:); 

cond=0
for err=1:length(p) %for each error value

    while ((cond*nframe(err))<max_nframe) && (ferrs(err)<ferlim)  %iterate

    %while (ferrs(err)<ferlim)  %iterate
       rx=rx_seed+0.5*(rand(1,h_col)<p(err)) ;%%erasure in received vector
       %%
      
       indice=[];
       new_matrice=[];
       mult=[];
        
       rest_new_rx=rx;
       indice=find((rx==0.5)|(rx==1.5));
       new_rx=rx(indice)
       rest_new_rx(indice)=0; %%gonna add the effect of erasure later
       new_matrice=parity(:,indice);
       
      
       mult=mod(parity*rest_new_rx',2);
       c=mult
 
[row, col]=size(new_matrice);
%%
nframe(err)=nframe(err)+1
%%%%%% %%peeling decoder
if( any(new_matrice(:)))
if(gfrank(new_matrice)==col)%%%
   
    ml_decoder(err)=ml_decoder(err)+1;
[message_solved,newer_matrice] = func_peeling_decoder(new_matrice,mult,rx,new_rx,indice)
     if(message_solved==rx_seed)
peeling_solved(err)=peeling_solved(err)+1;

     else
         size_stopping(err)=size_stopping(err)+col;
         ferrs(err)=ferrs(err)+1
         cond=1;
     end
else
   rank_def(err)=rank_def(err)+1 

end
end
    end

end


%%
%%%%%%%PLOTTING%%%%%%%%%

dum=[];
 dum=ml_decoder
 figure();
% semilogy(p',(1-peeling_solved./nframe),'-x');
% 
%  hold on
%  semilogy(p',(1-ml_decoder./nframe),'-o');
%  hold on
%  semilogy(p',(1-dum./nframe),'-x');
plot(p,size_stopping./ferrs)
grid on
xlabel("Erasure Probability")
ylabel("Size of Efficient Rank Stopping Sets ")
title(" RM(2,5)")
%legend('Peeling Decoder','ML Decoder','Inactivation Decoder')
grid on;grid minor
%set(gca,'YScale','log')
toc;