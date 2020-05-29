close all;
clear all;

%%Note about Code: This code downloads both the rotary encoder data and
%%does the initial peak count for data 4 and data 5, which have the dial
%%rotary encoder information. 

%This first part of the code manually detects peaks that are defined based
%on the data. Matlab functions such as peak finder did not work and the
%code had a number of variations and glitches that are filtered out in
%conveyorbelt2 and conveyorbelt3. The rotary encoders used in this project
%are www.adafruit.com/product/377.

%To use code: 
%1.input pathway to 6 rotary encoder data channels and change
%subject name, sample rate, day and trial information, and distance that the conveyor_belt moves
%everytime.
%2. establish start time and note this value if not 1

%Ouput of four codes: conveyor_behavior and conveyor_behavior_headers

%Input Variables and trial information
subject=''; %subject name
objects=3;
distance=0.25; %each movement moves 1/4 of the conveyor belt
sample_rate=30000;
day='';

%addpath('/Users/tanayapuranik/Documents/conveyorbeltdatafiles/100_ADC1.continuous')
addpath(genpath('Location of ADC files'));
addpath('Openephys tools pathway');

%Uploading the 6 data codes
data1 = load_open_ephys_data_faster('data file 1');%in conveyor
data2 = load_open_ephys_data_faster('data file 2');%in conveyor
data3 = load_open_ephys_data_faster('data file 3');%rating period: recise determination of a reference position
data4 = load_open_ephys_data_faster('data file 4');%turning
data5 = load_open_ephys_data_faster('data file 5');%turning
data6 = load_open_ephys_data_faster('data file 6'); %pushingofdial

% Setting Parameters for Rotary Encoders:
% Because of the amplitude variation in the data, initial slope and
% threshold values are manually chosen
figure()
plot(data4)
hold on;
plot(data5)
hold on;
plot(data6)
legend('data4','data5','data6')
xlabel('Time')
ylabel('Amplitude')

%%Initial Start, Slope (sl) and threshold (n) values manually because of
%%high variability in code 

prompt = {'Enter start time'}
dlgtitle = 'start time';
answer = inputdlg(prompt,dlgtitle)

start=answer{1}; %Usually 0, but if there is a long period of no recording before start before first peak
sl1=(max(data4)-min(data4))/2; % for data4
n1=(max(data4)-min(data4))/5; % for data4
sl2=(max(data5)-min(data5))/2; % for data5
n2=(max(data5)-min(data5))/5; % for data5
sl=(max(data6)-min(data6))/2; % for data6
n=(max(data6)-min(data6))/5; % for data6

%%1. Finding most peaks for dial  inputs, data 4 and data 5
[peak4pos1,peak4counter,countingtest4]=dialpeakfinder(data4,n1,sl1);
[peak5pos1,peak5counter,countingtest5]=dialpeakfinder(data5,n1,sl2);

%%2. deleting any indices that are less than start value 
indices1 = find(abs(peak4pos1)<start);
indices2 = find(abs(peak5pos1)<start);
peak4pos1(indices1) = [];
peak5pos1(indices2)=[];

%this function is broadly looking to count peaks, some filtering is done
%so that any glitches, defined as short peaks are removed
%this is saying that a peak is defined by at least 40 values of positive
%recording after
%Note: numerical values were chosen after optimization of datasets for the
%minimum number of values that defined some "peak" in signal without being
%quick glitches
function[peak4pos,peak4counter,countingtest]=dialpeakfinder(data4,n,sl)
%initial variables
peakstart=true;
peakset=false;
upslope=true;
peak4=0;
peak4pos=0;
peak=true;
cd=1;
firstnum=true;
c=1;
peak4neg=0;
peakcount4=0;
index4=0;
lp=0;
z=1;
o=1;
set4peak=0;
peak4counter=0;
noglitch=false;
xo=0;

for (a=4:1:size(data4,1)-100)
   
    if abs(data4(a)-data4(a+2))>sl &&(data4(a+3)-data4(a))>sl && data4(a+1)>n 
        peak=true;%yes there is a peak
        peakset=true;%yes this set has started
        upslope=true;%the slope of the individual peak is positive
        
    end
    
    if peak==true && peakset==true  %if this peak is there, start counting sin waves
        if data4(a)>0 && upslope==true  %counting everytime there is a peak, immediately turns it off after peak recorded
            peak4=peak4+1;
            upslope=false;%going down the peak
            %to catch any errors/glitches in the data
            
            for (x=a+5:1:a+25)%was +15, but adding to +25
                if (data4(x)>n)
                    xo=xo+1;
                
                end
            end
             
                 
        for(x=a+5:1:a+40)
            if(data4(x)>n ) %added second half&& abs(data4(x)-data4(x+1))<1
            lp=lp+1;
            end
        end
        if lp>=32
            noglitch=true;
            
        end
        if lp<32
            noglitch=false;
            lp=0;
        end
        
            if (peakstart==true && data4(a+20)>n && data4(a+30)>n && data4(a+40)>n && (data4(a+3))>n && abs(data4(a+3)-data4(a))>sl) && xo>17 && noglitch==true%if the peak is started, record just the first value
                xo=0;
                
                peak4pos(z)= a;
                peak4counter(z)=a;
                if(z>1 && (peak4pos(z)-peak4pos(z-1))<90)
                    peak4pos(z-1)=[];
                    
                    z=z-1;
                end
                z=z+1;
                peakstart=false;
            end
        end
        
        %checking if the set is over, if all of the numbers for a long time
        %are 0 records that
        if  upslope==false && peak4>0
            for (x=a+3:1:a+90)
                if abs(data4(x)-data4(x+1))<1
                    index4(c)=1;
                    if firstnum==true
                    peak4neg(cd)=a;
                 
                    if(cd>1 && peak4neg(cd)-peak4neg(cd-1)<60)
                        peak4neg(cd)=[];
                        cd=cd-1;
                    end
                    %fixing glitches
                    if(((data4(a)-data4(a+2)<sl) || (data4(a+1)-data4(a+3)<sl)) && (((data4(a+2)-data4(a+4))<0) || (data4(a+3)-data4(a+5))<0))
                        peak4neg(cd)=[];
                        cd=cd-1;
                    end
                    cd=cd+1;
                    firstnum=false;
                    end
                    c=c+1;
                else 
                    c=1;
                    index4=[];
                end
%                 
            end
            countingtest(o,1)=sum(index4);
            countingtest(o,2)=x;
            o=o+1;
            if sum(index4)>80
                peakcount4(b)=peak4;
                peakset=false;
                peakstart=true;
                firstnum=true;
                b=b+1;
                peak4=0;
                index4=[];
            end
            
        end
        if data4(a)<0 && upslope==false %upslope only true when it has now dropped below 0 (sin value has been completed)
            peak=false;
            lp=0;
            
        end
        if peakset==false 
         set4peak=size(peak4counter,2);
         
        end
        
    end
    
end

end

