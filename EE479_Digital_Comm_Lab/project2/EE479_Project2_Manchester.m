priorports = instrfind;
delete(priorports);
s = serial('COM6'); % Port can be changed


%%%
ascii_STR = 2;
ascii_ENDTR = 4;
%%%%%%
LEDperiod = 50; %ms
%%%%%%%
sample_rate = 8930;   % measured sampling rate of Arduino
T_samp = round((sample_rate / 1000) *LEDperiod);


buffersize = 100;
%Bit rate = 115,200 bits/sec
s.InputBufferSize = buffersize;
set(s,'BaudRate', 115200); 
fopen(s);

tot = [];
total =[];
%Threshold value to determine bits
bin_th = 160; %out of 256


tic
% To destroy initial pulses, garbage
for i=1:2
    data_raw = fread(s);
    
end


%%% SYNC 
sync_buff = zeros(1,100);
sync_ct =0;
%sync_th = 50;
redge = 0;
fedge = 0;


data_raw = fread(s);
 
sync_buff = (data_raw' > bin_th);

sflag=1;

cont_ct = 0;
up_ct = 0;
down_ct=0;
edge_len =0;


% For user to start transmission
'Ready'

while sflag
    data_raw = fread(s);
    for i=1:buffersize
        
    sync_ct = sync_ct + 1;
    data_s = data_raw(i);
    rec_bit = (data_s > bin_th);
    % Sliding window buffer
    sync_buff = circshift(sync_buff,-1);
    sync_buff(end) = rec_bit;
    
        
    
    total = [total rec_bit];
    tot = [tot data_s];

    % Check for rising edge
    if(sync_buff(end) > sync_buff(end-1))
        redge = sync_ct ; %%%
  
       
   % Check for falling edge, but first detect a rising edge
    elseif (sync_buff(end) < sync_buff(end-1)) && (redge ~=0)
        fedge = sync_ct ;
        
       
    end
    
    % Check if preditermined '10' pilot happened, determine the
    % synchronization point
    if(redge~=0 && fedge~=0 && (fedge-redge < 1.3*T_samp) && (fedge-redge > 0.75*T_samp))
        midbit_edge = fedge;
        %sync_ct =  sync_ct + buffersize - i;%%%%%%%%%%%%%%%%%
        samp_ct =  buffersize - i;%%%%%%%%%%%%%%%%%
        sflag = 0;
        break
    end
    end
end



toc
%samp_ct = 0;

sync_comp = 0;
ct = 0;
bits_ct = 0;
chars_rec =[];
datapts=[];
%total=[];
databits = [];
current_byte = zeros(1,7);
%tot =[];


STR_flag = 0;

finish=1;
tic
while finish
    
    data_raw = fread(s);
    
    for i=1:buffersize
        data_s = data_raw(i);
        rec_bit = (data_s > bin_th);
        %total = [total rec_bit];
        %tot = [tot data_s];
        
        
      
      samp_ct = samp_ct +1;
      
      ct=ct+1;

      %%% SAMPLING
      %Check for edges in the interval around mid-bit area
        if (samp_ct < 1.25*T_samp) && (samp_ct > 0.75*T_samp) && (prev_bit~=rec_bit) %edge interval
            
            result_bit = (rec_bit>prev_bit);
            databits = [databits result_bit];
            bits_ct = bits_ct +1;
            current_byte(bits_ct)=result_bit;
            
            %samp_ct = 0;
            
            %Correction for LDR imperfections. Because 1 pulses are longer than 0
            %pulses, need to compensate.
            if result_bit == 1
                samp_ct = - round(T_samp/20);
            else
                samp_ct = round(T_samp/20);
            end
            
            datapts=[datapts ct];

           %If 1 character (7 bits) is received
            if bits_ct == 7
                rec_val = bi2de(current_byte,'left-msb');
               
                if STR_flag  %If received transmission start indicator
                    
                    if rec_val == ascii_ENDTR  %If end transmission char
                        STR_flag = 0;
                        finish =0;
                    
                    else
                        rec_char = char(rec_val);
                        rec_char
                        chars_rec = [chars_rec rec_char]
                    end
                end
                
                if rec_val == ascii_STR  %If start transmission char
                    STR_flag = 1;
                end
                
                bits_ct =0;
            end
  
        end
 
        prev_bit = rec_bit;
    end
    
end

toc

fclose(s);