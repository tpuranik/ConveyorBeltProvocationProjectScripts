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
%recording afters
%Note: numerical values were chosen after optimization of datasets for the
%minimum number of values that defined some "peak" in signal without being
%quick glitches
function[peak4pos,peak4counter,countingtest]=dialpeakfinder(data4,n,sl)

%Initial variables
peakstart=true;
peakset=false;
upslope=true;
peak4=0;
peak4pos=0;
peak=true;
firstnum=true;
c=1;
peakcount4=0;
z=1;
o=1;
set4peak=0;
peak4counter=0;
noglitch=false;


%1. Checking initial increase in slope at multiple points, establishing
%start 
for (a=4:1:size(data4,1)-100)
    if abs(data4(a)-data4(a+2))>sl &&(data4(a+3)-data4(a))>sl && data4(a+1)>n 
        peak=true;%yes there is a peak
        peakset=true;%yes this set has started
        upslope=true;%the slope of the individual peak is positive    
    end
    
    if peak==true && peakset==true  %if this peak is there, start counting peaks
        if data4(a)>0 && upslope==true  %counting everytime there is a peak, immediately turns it off after peak recorded
            peak4=peak4+1;
            upslope=false;%going down the peak
            %to catch any errors/glitches in the data
            A=[]; lp=[];
            A=data4(a+5):data4(a+40);
            lp=size(find(A>n));
       if lp>=32
            noglitch=true;
       else
            noglitch=false;
       end
       
       %saying if peak has start and there are no glitches for a while we
       %have an inital peak and only want to record first value
       if (peakstart==true && noglitch==true %if the peak is started, record just the first value
                peak4pos(z)= a; %records first value
                peak4counter(z)=a; %counts number of peaks in value
                if(z>1 && (peak4pos(z)-peak4pos(z-1))<90) %if less than 90 values together, fraction of an s, its a glitch
                    peak4pos(z-1)=[];
                    z=z-1;
                end
                z=z+1;
                peakstart=false;
            end
        end
        
        %checking for end of the peak so that we record the positive value
        %as a full peak: defined by the positive and negative
        if  upslope==false && peak4>0
            for (x=a+3:1:a+90)
                if abs(data4(x)-data4(x+1))<n
                    c=c+1;
                else 
                    c=1;
                end                 
            end
            countingtest(o,1)=c; %for troubleshooting
            countingtest(o,2)=x;
            o=o+1;
            
            if c>80 %saying if at least 80 out of 90 values are below threshold, then peak is done
                peakcount4(b)=peak4;
                peakset=false;
                peakstart=true;
                firstnum=true;
                b=b+1;
                peak4=0;
                c=1;
            end
            
        end
        if data4(a)<n && upslope==false %upslope only true when it has now dropped below 0 (sin value has been completed)
            peak=false; %peak is over
            set4peak=size(peak4counter,2); %recording size of peaks (length of signal)
        end
        
    end
    
end

end

