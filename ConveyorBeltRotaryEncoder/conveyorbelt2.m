
%%% Additional Step by Step filtering of the data. Getting Rid of glitches
%%% just looks that the peak is sustained for a while, to remove short
%%% peaks. Additional filtering does the same thing as well. Dial pushed
%%% start is the point at which the patient locks in their answer and is
%%% found using data6.

%1. Dialpushed start finds all the points at which the user pushes the dial
%assumptions: no extra pushes are made, if the pushes are too close in time
%those glitches are stopped

o=start;
dialpushedstart=lockedin(data6,peak4pos1,o,n,sl); %find all possible points of pushed dials
[dialpushedstart]= dialcleaning(dialpushedstart); %remove any peaks that are glitches
[dialpushedstart,peak4pos1,peak5pos1]=startremoved(dialpushedstart,peak4pos1,peak5pos1); %remove any glitches before the start

%2. Filtering the dial rating peaks. These peaks have a lot of glitches and
%counting every single one is important for accurate dial rating, so this
%is just a preliminatry step
[filtering5,test5]=additionalfiltering(peak5pos1,data5,n1);
[filtering4,test4]=additionalfiltering(peak4pos1,data4,n2);


%functions for cleaning dialpushedstart, which is when the participant
%locks in answer
function dialpushedstart5=lockedin(data6, peak4pos1,ooo,n,sl)
%--------------DIAL PUSHED START---------------------
%data6-when the data was locked in
sizedata6=size(data6,1)-100;
j=1;o=1;y=0;z=1;h=1;g=1;firstnum=true;endnum=true;lp=0;


for (i=1:1:sizedata6)
    if firstnum==false
    if (data6(i+2)-data6(i))>=sl && data6(i)<n
    for(x=i-40:1:i-3)
        if data6(x)<n
            y(z)=1;
            z=z+1;
        end
        if data6(x)>n
            y(z)=0;
            z=z+1;
        end
    end
    end
         
    end
   
    %summing it
    if sum(y)>35 
        firstnum=true;
        y=[];
    end
    if firstnum==true
        for(x=i+2:1:i+12)
            if data6(x)>n
            lp=lp+1;
            else
                lp=0;
            end
        end
        
    end
    

    if j>1
        if (data6(i+2)-data6(i))>=sl && data6(i)<n && firstnum==true && (i-l)>20 && lp>6
            dialpushedstart5(j)=i;
            l=i;
            j=j+1;
            firstnum=false;
            noglitch=false;
            lp=0;
        end
          
    end
    if j==1
        if (data6(i+2)-data6(i))>=sl && data6(i)<n
            dialpushedstart5(j)=i;
            j=j+1;
            firstnum=false;
            l=i;
            noglitch=false;
            lp=0;
            
        end
    end
end
yq=1;

%automate this
start=ooo;
indices1 = find(abs(dialpushedstart5)<start);
dialpushedstart5(indices1) = [];
end
%this removes any peaks that are too close together 
function [dialpushedstart]= dialcleaning(dialpushedstart)
o=1;
tonote=0;
dialpushedstart1=dialpushedstart;
indices=[];
i=1;

while i<(size(dialpushedstart,2)-1)
if abs(dialpushedstart(1,i+1)-dialpushedstart(1,i))<10000
    indices(o)=i+1;
    o=o+1;
end
i=i+1;
end
if isempty(indices)==0
dialpushedstart(indices)=[];
end

%in case they are pushing the dial too frequently or repeatedly 
indices2=[];
for i=1:1:((size(dialpushedstart,2)-1))
    if (dialpushedstart(1,i+1)-dialpushedstart(1,i))<100000 %less than 20 seconds
        dialpushedstart(1,i+1)=0.5;
    end
end

end

function [dialpushedstart,peak4pos1,peak5pos1]=startremoved(dialpushedstart,peak4pos1,peak5pos1)
o=1;
zz=0;
d=0;
di=0;
indices=[];
first=false;
for i=2:1:(size(dialpushedstart,2)-1)
    if (dialpushedstart(1,i+1)-dialpushedstart(1,i))>2000000 && first==false
       zz=i;
       first=true;
    end
    end
    dd=zz-25;%25 if #of trials*2-1
    if dd>0
    di=dialpushedstart(1,dd);
indices = find(abs(dialpushedstart)<di);
dialpushedstart(indices) = [];
    end
multiplier=7/191861;
tm=10/multiplier;
    
    start=di-tm;
indices1 = find(abs(peak4pos1)<start);
peak4pos1(indices1) = [];

indices2 = find(abs(peak5pos1)<start);
peak5pos1(indices2) = [];

end

%this looks at 80 values after the peak, and is saying that if at least 30
%of them are below the threshold value, then its not a peak, but a glitch
%another way to remove a glitch
function [peak5pos1]=gettingridofglitches(peak5pos1,data5,n)
%n=1;
zz=0;
xx=1;
i=1;
while i< size(peak5pos1,2)
    
    xx=peak5pos1(1,i); %peak5pos1(1,i)
    for(j=xx:1:xx+80) %previously 80 and 30
        if data5(j,1)<n
        zz=zz+1;
        end
    end
    
    if zz>30 
        peak5pos1(1,i)=1;
        
    end
    zz=0;
    i=i+1;
end
end

%this is saying that if the peaks are less than 500 values apart, one is a
%glitch or if a value 200 or 300 points away from the start is less than
%the threshold its not a peak
function [peak5pos1,test]=additionalfiltering(peak5pos1,data5,n)
w=0;
h=1;

indices=0;
for(i=1:1:size(peak5pos1,2)-1)
    if abs(peak5pos1(i)-peak5pos1(i+1))<500
        peak5pos(i)=0;
        indices(h)=i;
        h=h+1;
    end
end
for(i=1:1:size(peak5pos1,2)-1)
    x=peak5pos1(i);
    for (j=1:1:150)
    if data5(x+j)>n
        w=w+1;
    end
    
    end
    test(i)=w;
    if w<105 
        peak5pos1(i)=0;
        indices(h)=i;
        h=h+1;
    end
    w=0;
    if data5(x+300)<n && (data5(x+250)<n || data5(x+300)<n || data5(x+350)<n)
        indices(h)=i;
        h=h+1;
    end
end


peak5pos1(indices)=[];
end


