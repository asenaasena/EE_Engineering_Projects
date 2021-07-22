priorports = instrfind;
delete(priorports);
s = serial('COM6'); % Port can be changed


%%%
ascii_STR = 2;
ascii_ENDTR = 4;
%%%%%%
LEDperiod =60 ; %ms
%%%%%%%
sample_rate = 8930;       % measured sampling rate of Arduino
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
% For user to start transmission
'Ready'
%%% SYNC 
sync_buff = zeros(1,100);
sync_ct =0;
%sync_th = 50;
redge = 0;
fedge = 0;

%Initialize buffer
data_raw = fread(s);
sync_buff = (data_raw' > bin_th);
%Logical binary data buffer


%sync_buff = data_raw';
    

%Indicates if sync completed
sflag=1;

% Syncronization
while sflag
    data_raw = fread(s);
    for i=1:buffersize
        
    sync_ct = sync_ct + 1;
    data_s = data_raw(i);
    rec_bit = (data_s > bin_th);
    
    % Sliding window buffer
    sync_buff = circshift(sync_buff,-1);
    sync_buff(end) = rec_bit;
    
        
    rec_bit = (data_s > bin_th);
    total = [total rec_bit];
    tot = [tot data_s];
    
    
    %Check rising edge
    if(sync_buff(end)>sync_buff(end-1))
 
        redge = sync_ct - 1; %%%
        
    %Check falling edge
    elseif (sync_buff(end) < sync_buff(end-1)) && (redge ~=0)
        fedge = sync_ct - 1;
        
    end
    
    % Check if preditermined '010' pilot happened, determine the
    % synchronization point
    if(redge~=0 && fedge~=0 && (fedge-redge < 1.4*T_samp) && (fedge-redge > 0.75*T_samp))
        samp_point = round((redge + fedge) / 2);
        sync_ct = sync_ct + buffersize - i;
        sflag = 0;
        break
    end
    end
end

toc
samp_ct = 0;

sync_comp = 0;
ct = 0;
edge_ct=0;
bits_ct = 0;
chars_rec =[];
datapts=[];

databits = [];
current_byte = zeros(1,7);


STR_flag = 0;
prev_bit=0;

finish=1;
tic
while finish
    
    data_raw = fread(s);
    
    for i=1:buffersize
        data_s = data_raw(i);
        rec_bit = (data_s > bin_th);
        %total = [total rec_bit];
        %tot = [tot data_s];
        edge_ct = edge_ct +1;
        
        %Checking edge
        if rec_bit ~= prev_bit
            edge_ct = 0;
        end
        
        
      if sync_comp
          %If sync completed
         samp_ct = samp_ct +1;
      else
          %If sync not completed yet
        sync_ct = sync_ct + 1;
      end
      ct=ct+1;
      %%% SYNC
      if (sync_ct == samp_point + T_samp) 
          
          sync_comp = 1; % sync completed
          sync_ct = sync_ct +1;
          
          if(data_s > bin_th)
              'PROBLEM!'
          end
      %%% SAMPLING
      % Take 1 sample each period
      elseif (samp_ct == T_samp)
            databits = [databits rec_bit];
             bits_ct = bits_ct +1;
            current_byte(bits_ct)=rec_bit;
            datapts=[datapts ct];
            
            
            % resync correction
            if edge_ct < T_samp
                samp_ct = (  edge_ct - round(T_samp/2));
                
            else
                samp_ct = 0;
            end
            
            
            current_byte(bits_ct)=rec_bit;
           
            %If 1 character (7 bits) is received
            if bits_ct == 7
                rec_val = bi2de(current_byte,'left-msb');
               
                if STR_flag %If received transmission start indicator
                    
                    if rec_val == ascii_ENDTR %If end transmission char
                        STR_flag = 0;
                        finish =0;
                    
                    else
                        rec_char = char(rec_val);
                        rec_char
                        chars_rec = [chars_rec rec_char]
                    end
                end
                
                if rec_val == ascii_STR %If start transmission char
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