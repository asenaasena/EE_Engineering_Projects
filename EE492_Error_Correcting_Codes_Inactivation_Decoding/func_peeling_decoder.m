function [message_solved,newer_matrice] = func_peeling_decoder(new_matrice,mult,rx,new_rx,indice)


 while(any(sum(new_matrice,2)==1)) %peel until you can 
            [row,col]=size(new_matrice);
       for a=1:col %peeling decoder
           
           for i=1:row
               [row_mem,col_mem]=find(new_matrice(i,:));
              
               if(length(col_mem)==1) %check every row if it includes only one '1' value
                   new_rx(col_mem)=mult(i);
                   mult=mod(mult+new_matrice(:,col_mem)*new_rx(col_mem),2); %multiply and yana at,update et
                   new_matrice(:,col_mem)=0; %if you find such a row, then remove column vector at column position of this 1 
                   %erased_memo=[erased_memo new_rx(col_mem)]
                   
               end                
               
           end
       end 
   end
       
       rx(indice)=new_rx';
       message_solved=rx;
       newer_matrice=new_matrice;

end

