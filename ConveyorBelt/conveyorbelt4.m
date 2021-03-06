
%This code  decodes the placement of the conveyor belt and direction of the
%movement. It then formats the values into conveyor_behavior, which is the
%table. 

sizedata=size(data1,1)-1000;

%Data1 and 2 Finding Peaks
sl=(max(data1)-min(data1))/2;
[indexplace,peakindex,movingend,peakcount]=peakfinder(sl,data1,sizedata)
sl=(max(data2)-min(data2))/2
[indexplace2,peakindex2,movingend2,peakcount2]=peakfinder(sl,data2,sizedata)

%Calculating Direction
%Calculating position and direction of movement of conveyor belt.
%Note: for this task, there is a set movement pattern so the vector below 
%can be used if data1 and data2 optical fibers are broken. 
%direction1=[0,1,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,1,0,0,1,0,0,1,0,1,0,1,0,0,1,0,0,1,0,0,1,0,1];

%If the positioning is changed in the future, use methods below. 
%This confirms that the number of peaks going forward and back was the same
eachwave=distance/peakcount(1);
sizepeakcount=size(peakcount);
numberofconveyortrials=size(peakindex,2)/objects;%each trial has 13 movements
endoftrial=[numberofconveyortrials:numberofconveyortrials:size(peakindex,2)];
for (i=1:1:size(peakindex,2))
if data2(peakindex(i)+10)<data1(peakindex(i)+10)
   direction1(i)=0; %forward
else
   direction1(i)=1; %backward
    
end
end
direction1(endoftrial)=-1; %goes to home position at end of trial
direction1(direction1==0)=0.25;
direction1(direction1==1)=-0.25;
DIR=cumsum(direction1);
direction=[0,DIR];
[dialpushedstart1]=doubledialpushed(dialpushedstart);

%----------------RATING TIME Points------------------------
o=1;
multiplier=1/sample_rate;
twenty=20/multiplier; ten=10/multiplier;

%Due to lack of event marker, first few ratings will be preset 
ratingtime=0;ratingstart=0;
ratingtime(1,1)=dialpushedstart1(1,1)-20*sample_rate;
ratingstart(1,1)=dialpushedstart1(1,1)-sample_rate*5;
ratingtime(2,1)=dialpushedstart(1,2);
ratingstart(2,1)=dialpushedstart(1,2);

d=1;x=3;
%Aassuming that they don't take more than 20 seconds to rate for rating1
for(p=3:2:size(dialpushedstart,2))
    %1. Rating time right after conveyor stops moving
    ratingtime(p,1)=dialpushedstart(1,x)-movingend(1,d);
    ratingstart(p,1)=movingend(1,d);
    ratingend(p,1)=dialpushedstart(1,x);
    x=x+1;
    %2. Rating time 20 seconds after
    ratingtime(p+1,1)=dialpushedstart(1,x)-movingend(1,d)-ten-ten;
    ratingstart(p+1,1)=movingend(1,d)+ten+ten;
    ratingend(p+1,1)=dialpushedstart(1,x);
    x=x+1;
    d=d+1;
end

%Converts everything to seconds
for(x=1:1:size(ratingtime,1))
    ratingtimeinseconds(x,1)=ratingtime(x,1)*multiplier;
end

dialpushedstartT(:,1)=dialpushedstart(1,:);

%----------------------Formatting for Table------------------------------- 
%Initializing all the Variables and arrays
di=0;peaksize=0;ratingtime1=0;ratingtime2=0;rating1=0;rating2=0;ratingtime1start=0;ratingtime1end=0; ratingtime2start=0;
ratingtime2end=0;t=1;
i=1;
%Looping through and converting each array into format for Table
for(x=1:2:size(dialpushedstart,2))%-1
          peaksize(i,1)=t;%counter
          di(i,1)=direction(1,i);%distance
          ratingtime1(i,1)=ratingtimeinseconds(x,1);
          ratingtime2(i,1)=ratingtimeinseconds(x+1,1);
          rating1(i,1)=totalrating(x,1);
          rating2(i,1)=totalrating(x+1,1);
          ratingtime1start(i,1)=ratingstart(x,1)*multiplier;
          ratingstart(x,1)=ratingstart(x,1);
          ratingtime1end(i,1)=ratingend(x,1)*multiplier;
          ratingtime2start(i,1)=ratingstart(x+1,1)*multiplier;
          ratingtime2end(i,1)=ratingend(x+1,1)*multiplier;
          ratingstart(x+1,1)=ratingstart(x+1,1);
          i=i+1;
          t=t+1;
end

%Ratingtime1 is an estimate, its not actually recorded. Just needed a
%starting point to adjust the rest
%initializing first few values because there are no event markers
ratingtime1start(1,1)=0;
ratingtime1(1,1)=5;
ratingtime1end(1,1)=dialpushedstart(1,1)*multiplier;%for sake of this, assuming first one is 5 seconds rating
ratingtime2start(1,1)=dialpushedstart(1,1)*multiplier+15;
ratingtime2end(1,1)=dialpushedstart(1,2)*multiplier;
ratingstart(1,1)=0;

%%--------------------Table----------------------------------------
sc=size(rating1,1); %size of the conveyor_behavior
rstart=dialpushedstart(1,1)*multiplier-5;%for normalizing to 0
conveyor_behavior=zeros(sc,10);
conveyor_behavior(:,1)=peaksize(1:sc,1);
conveyor_behavior(:,2)=di(1:sc,1);
conveyor_behavior(:,3)=rating1(1:sc,1);
conveyor_behavior(:,4)=rating2(1:sc,1);
conveyor_behavior(:,5)=ratingtime1(1:sc,1);
conveyor_behavior(:,6)=ratingtime2(1:sc,1);
conveyor_behavior(:,7)=ratingtime1start(1:sc,1)-rstart;
conveyor_behavior(:,8)=ratingtime1end(1:sc,1)-rstart;
conveyor_behavior(:,9)=ratingtime2start(1:sc,1)-rstart;
conveyor_behavior(:,10)=ratingtime2end(1:sc,1)-rstart;

%initial time values that are not 

conveyor_behavior(1,5)=5;
conveyor_behavior(1,6)=NaN;
conveyor_behavior(1,7)=0;
conveyor_behavior(sc/objects+1,5)=NaN;
conveyor_behavior(sc/objects+1,6)=NaN;
conveyor_behavior(sc/objects+1,7)=NaN;
conveyor_behavior(sc/objects+1,9)=NaN;
conveyor_behavior(sc/objects+sc/objects+1,5)=NaN;
conveyor_behavior(sc/objects+sc/objects+1,6)=NaN;
conveyor_behavior(sc/objects+sc/objects+1,7)=NaN;
conveyor_behavior(sc/objects+sc/objects+1,9)=NaN;
conveyor_behavior(1,8)=dialpushedstart(1,1)*multiplier-rstart;
conveyor_behavior_headers={'Position Number', 'Position','Rating1','Rating2', 'Rating Time 1 (seconds)', 'Rating Time 2 (seconds)', 'Rating Time 1 Start (Seconds)', 'Rating time 1 End (Seconds)', 'Rating Time 2 Start (Seconds)', 'Rating Time 2 End (Seconds)'};

save('Saving Information')

%just filtering dialpushed and removing anything form start
function [dialpushedstart1]=doubledialpushed(dialpushedstart)
o=1; %counter of All5
y=1; 
j=1;
e=1;%comparison counter
for(i=1:1:size(dialpushedstart,2))
    dialpushedstart1(e)=dialpushedstart(i);
    e=e+1;
    dialpushedstart1(e)=dialpushedstart(i);
    e=e+1;
end
j=1;
o=1;
end
function [indexplace,peakindex,movingend,peakcount]=peakfinder(sl,data1,sizedata)
b=1;c=1;peak1=0;z=1;upslope=true;peak=false;set=false;peakcount=0;
index=0;peakstart=false;peakindex=0;binarydata1=0;binarydata2=0;
firstnum=true;cd=1;negdone=false;mark1=0;yy=1;movingend=[];
%SECTION 1: counting the number of peaks, when it is going forward and
%back, and how much it is going forward and back
for (a=1:1:sizedata)
 
    if (data1(10+a)-data1(a))>sl  %if difference is greater than 0.5 there is a peak
        peak=true; %yes there is a peak
        set=true;%yes this set has started
        upslope=true;%the slope of the individual peak is positive     
    end
    
   
    if peak==true && set==true  %if this peak is there, start counting sin waves
        if data1(a)>4 && upslope==true  %counting everytime there is a peak, immediately turns it off after peak recorded
            peak1=peak1+1;
            binarydata1(a)=1;

            upslope=false;%going down the peak
            if peakstart==true %if the peak is started, record just the first value
                peakindex(z)= a;
                peakstart=false;
                z=z+1;
            end
        end
        
        %peak is ending
        if abs(data1(a+3)-data1(a+30))<sl  && upslope==false && set==true && abs(data1(a+7)-data1(a))<sl && peak1>2000
            for (x=a+3:1:a+73)
                if abs(data1(x)-data1(x+1))<sl
                    index(c)=1;
                    if firstnum==true 
                        indexplace(cd)=x;
                        cd=cd+1;
                        firstnum=false;
                        
                    end
                    c=c+1;
                else
                    c=1;
                    index=[];
                end
                
            end
            if sum(index)>60
                peakcount(b)=peak1;
                movingend(b)=a;
                firstnum=true;
                set=false;
                peakstart=true;
                b=b+1;
                peak1=0;
            end
            
        end
        if abs(data1(a)-data1(a+10))<sl && upslope==false %upslope only true when it has now dropped below 0 (sin value has been completed)
            peak=false;
            binarydata1(a)=0;
        end    
    end
end
end

