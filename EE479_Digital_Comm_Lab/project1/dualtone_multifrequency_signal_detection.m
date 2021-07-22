%%EE479 PROJECT1: DUAL-TONE MULTI-FREQUENCY SIGNAL DETECTION
%%Zeliha Asena Kýrýk
clear all

%%
%%%%%%%%%%%%%%%%INITIALIZATION%%%%%%%%%%%%%%%%%%%%%%%%%%
data=[];   %%initializing all data
symbol_data=[];
symbol=[];
count=0

priorports=instrfind; % determine which port is open
delete(priorports); % close other ports otherwise it gives error
s = serial('COM3'); %COM3 is the input port which can be read from Arduino software

s.InputBufferSize = 356; %because of serial protocol, data should be taken by blocks,industrial speed for processing is around 40ms,
%by multiplying this value with sampling rate of Arduino, number of block can be determined.
%(0.040msecond x 8910 sample/second) =~ 356 sample
set(s,'BaudRate', 115200); % this rate should be the same with the rate which is set for Arduino
fopen(s); % open COM port


%%
% Symbol Set
dtmf_symbols=['1', '2', '3', 'A'; '4', '5', '6', 'B'; '7', '8', '9', 'C'; '*', '0', '#', 'D']; %output-symbols on dial
%it can be also considered as frequency matrice

%%Arduino rate calculation
fs=8925 ;%%(Hz)Arduino sampling rate; it can be found by sending a wave whose frequency is known beforehand, by checking the fft graph
% of this known signal, Arduino sampling rate can be determined

%%

%%%%%%%%%%%%%%FILTER DESIGN%%%%%%%%%%%%%%%%%%%%%%%%%%

%%For filtering operation, I am using 8 bandpass filters for 8 different frequencies.
%%in order to use these filters: filter type/order of filter / 2 frequency values in between signals can pass
%and sampling rate should be known

%As a design procedure I defined my bandwidth 70Hz for all of the bandpass
%filters, here choosing equal bandwidths will be important while
%calculating signal energies.
band_pass1 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',665,'HalfPowerFrequency2',735, ...
    'SampleRate',fs);  %filter for 697Hz
band_pass2 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',735,'HalfPowerFrequency2',805, ...
    'SampleRate',fs);   %filter for 770Hz
band_pass3 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',815,'HalfPowerFrequency2',885, ...
    'SampleRate',fs);   %filter for 852Hz
band_pass4 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',905,'HalfPowerFrequency2',975, ...
    'SampleRate',fs);   %filter for 941Hz
band_pass5 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',1175,'HalfPowerFrequency2',1245, ...
    'SampleRate',fs);   %filter for 1209 Hz
band_pass6 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',1305,'HalfPowerFrequency2',1375, ...
    'SampleRate',fs);  %filter for 1336 Hz
band_pass7 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',1445,'HalfPowerFrequency2',1515, ...
    'SampleRate',fs);  %filter for 1477Hz
band_pass8 = designfilt('bandpassiir','FilterOrder',20, ...
    'HalfPowerFrequency1',1595,'HalfPowerFrequency2',1665, ...
    'SampleRate',fs);  %filter for 1633Hz

%%all bandwidths are equally wide -70Hz-

%%
%%%%%%%%%%%%%%%DATA READING%%%%%%%%%%%%%%%
while 1 %%reading data continuously up to user stops
    data= fread(s); %read quantized data from Arduino
    
    %  avg=mean(data);%%if I even use this subtraction I got clearer
    %  results,since DC component is eliminated
    %    data=data-avg;
    
    %%
    %%%%%%%%%%%%%FILTERING OPERATION%%%%%%%%%%%%%%
    
    %Filter data with all of the bandpass filters, check the energy of
    %those filtered signals
    
    %since it is dual tone,one symbol includes 2 different frequencies
    %first 4 filter is to determine the frequency on rows
    filtered_1=filter(band_pass1,data);
    power1=sum(abs(filtered_1).*abs(filtered_1));
    
    filtered_2=filter(band_pass2,data);
    power2=sum(abs(filtered_2).*abs(filtered_2));
    
    filtered_3=filter(band_pass3,data);
    power3=sum(abs(filtered_3).*abs(filtered_3));
    
    filtered_4=filter(band_pass4,data);
    power4=sum(abs(filtered_4).*abs(filtered_4));
    
    %compare the powers of filtered signals
    power_set=[power1 power2 power3 power4];
    max_power=max(power_set);
    [row_low col_low]=find(power_set==max_power);
    %%dual tone's first frequency element is determined which has maximum power
    
    %%%%%%%%%%%%%%%%THRESHOLD CHECK%%%%%%%%%%%%
    %since not all the time we are pushing buttons we need to check if the signal meets threshold energy,if not
    %it means noise and not an actual data
    
    if(max_power>1.000)%if signal has more energy than threshold,button is pushed and we should display it
        %I determined this threshold value after checking power values of signal and noise without signal
        
        if(col_low==1)
            row_dtmf=1; %row_dtmf corresponds to row of frequency matrix,one frequency which dual-signal includes
        elseif(col_low==2)
            row_dtmf=2;
        elseif(col_low==3)
            row_dtmf=3;
        elseif(col_low==4)
            row_dtmf=4;
            
        end
    end
    
    %same procedure in order to find frequency on columns
    
    %last 4 filters are to determine the frequency on rows
    filtered_5=filter(band_pass5,data);
    power5=sum(abs(filtered_5).*abs(filtered_5));
    
    filtered_6=filter(band_pass6,data);
    power6=sum(abs(filtered_6).*abs(filtered_6));
    
    filtered_7=filter(band_pass7,data);
    power7=sum(abs(filtered_7).*abs(filtered_7));
    
    filtered_8=filter(band_pass8,data);
    power8=sum(abs(filtered_8).*abs(filtered_8));
    
    power_set_col=[power5 power6 power7 power8];
    max_power2=max(power_set_col);
    [row col]=find(power_set_col==max_power2);
    
    
    if(max_power2>1.000)%I determined this threshold value after checking power values of in presence of sound signal and noise without signal
        if(col==1)
            col_dtmf=1; %col_dtmf corresponds to column of frequency matrix,other frequency which dual-signal includes
        elseif(col==2)
            col_dtmf=2;
        elseif(col==3)
            col_dtmf=3;
        elseif(col==4)
            col_dtmf=4;
            
        end
    end
    
    %%%%%%%%%%%%%%%%%%DISPLAY SYMBOLS%%%%%%%%%%%%%%%%%%
    
    if(max_power>1000 && max_power2>1000 ) %check if it is dual tone, one frequency is not enough
        
        if count==0  %it means before that symbol button was not pushed just before
           
            symbol=dtmf_symbols(row_dtmf,col_dtmf); %by acquired frequencies determine symbols
            symbol_data=[symbol_data symbol]; %write data next to previous one
            display(symbol_data) %show symbols
            
        end
        count=3; %in order to wait for 3 periods where button is not pushed, to avoid continuosly writing one symbol when user pushes
        %same button without releasing
        
    else  % checks the times when button is not pushed because at that time energy will be considerably small
        if count>0 %if it is bigger than 0 it will decrease 1 value; if it is 0 and without enough energy it will not do anything
            count=count-1;
        end
    end
    
end


