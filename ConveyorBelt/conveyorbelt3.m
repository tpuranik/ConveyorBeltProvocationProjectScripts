%Code: Now that we have preliminary peak counts, this code removes numerous
%glitches while preserving maximum data. Examples of glitches are found in
%the readme. 

%The code starts by removing short peaks that are called "glitches", where
%there is a peak but it is not a sustained peak, which indicates movement
%of the dial. 


%Condition: If the patient pushes the dial multiple times to lock in answer
dialpushedstart= del(dialpushedstart,1,78,0.5);
%Condition: post filtering peaks, this removes any pushes the patient does to practice

%Initializing empty arrays
peak4rating=zeros(15,78);
peak5rating=zeros(15,78);


%1. Filtering for glitches: defined as short peaks
%numerical values for glitches set at 400 through examination of dataset
for i=1:1:size(filtering5,2)
    x=filtering5(i);
    A=data5(x:x+400,1);
    idx=find(A<n2);
    m(i)=size(idx,1);
    if m(i)>100
        filtering5(i)=0.5;
    end
end
for i=1:1:size(filtering4,2)
    x=filtering4(i);
    A=data4(x:x+400,1);
    idx=find(A<n1);
    m(i)=size(idx,1);
    if m(i)>100
        filtering4(i)=0.5;
    end
end
filtering5(filtering5==0.5)=[];
filtering4(filtering4==0.5)=[];

%This separates the peaks into peaks based on the time the patient locks in
%the answer (dialpushedstart). That way we have groups of peaks for rating.
peak4rating=rate(filtering4,dialpushedstart);
peak5rating=rate(filtering5,dialpushedstart);


%This combines the peaks into peak4 and peak5 side by side for the same
%dial rating
[Allpeaks]=combiningpeaks(peak4rating,peak5rating);
Allpeaks=Allpeaks(:,1:156);
[L,M]=size(Allpeaks);%defines the value and size array
Allpeaks= del(Allpeaks,L,M,.5);

%2. Glitches in the beginning and middle, establishing 1:1: data4 and data5
%method: by verifying whether there is a one to one ratio of data4 to data5
%this works because short peaks already removed
o1=1;%odd
o2=1; %even
b=1;
for j=1:2:(size(Allpeaks,2))
   o1=1;%odd
   o2=1; %even
    for o=1:1:(size(Allpeaks,1)-1) %or while b<size(all33,1)
    if Allpeaks(o1,j)>Allpeaks(o2+1,j+1) && Allpeaks(o2+1,j+1)>1
        Allpeaks(o2,j+1)=0.5;
        o2=o2+1;
    else
        o2=o2+1;
        o1=o1+1;
    end
    end
    
end
for j=1:2:(size(Allpeaks,2))
   o1=1;%odd
   o2=1; %even
    for o=1:1:(size(Allpeaks,1)-1)
    if Allpeaks(o1+1,j)<Allpeaks(o2,j+1) && Allpeaks(o1+1,j)>1 
        Allpeaks(o1,j)=0.5;
        b=b-1;
        o1=o1+1;
    elseif Allpeaks(o1+1,j)>Allpeaks(o2,j+1)
        o1=o1+1;
        o2=o2+1;
    end
     
    end
end
[Allpeaks]= del(Allpeaks,L,M,.5);


%3. Running Same code again: just for verification
o1=1;%odd
o2=1; %even
b=1;
for j=1:2:(size(Allpeaks,2))
   o1=1;%odd
   o2=1; %even
    for o=1:1:(size(Allpeaks,1)-1) %or while b<size(all33,1)
    if Allpeaks(o1,j)>Allpeaks(o2+1,j+1) && Allpeaks(o2+1,j+1)>1
        Allpeaks(o2,j+1)=0.5;
        o2=o2+1;
    else
        o2=o2+1;
        o1=o1+1;
    end
    end
    
end
for j=1:2:(size(Allpeaks,2))
   o1=1;%odd
   o2=1; %even
    for o=1:1:(size(Allpeaks,1)-1)
    if Allpeaks(o1+1,j)<Allpeaks(o2,j+1) && Allpeaks(o1+1,j)>1 
        Allpeaks(o1,j)=0.5;
        b=b-1;
        o1=o1+1;
    elseif Allpeaks(o1+1,j)>Allpeaks(o2,j+1)
        o1=o1+1;
        o2=o2+1;
    end
     
    end
end
[Allpeaks]= del(Allpeaks,L,M,.5);

%To verify beginning glitches are gone
for j=1:2:(size(Allpeaks,2))
    O1=Allpeaks(:,j);
    O2=Allpeaks(:,j+1);
   U(:,j)=O2-O1;
end

%4. Checking when recording starts or ends on rating periods
%If the recording ends on recording pin and starts: thats one full one rating
%However if the recording ends on the recording pin but does not start on
%the recording pin, that is not an additional value.
p=1;m=[];startsonrecording=[];in=1;i=15;A=[];
%Extracting values that started on recording
for i=2:2:size(Allpeaks,2)
    o1=Allpeaks(:,i);
    o1(o1==0)=[];
    if isempty(o1)==0
    x=o1(1);
    s=size(o1,1);
    A(:,p)=data5(x-10000:x-9500,1);
    idx=find(A(:,p)>n);
    m(p)=size(idx,1);
    if m(p)>200
        startsonrecording(in)=i;
        in=in+1;
    end
    end
    p=p+1;
end
for i=1:2:size(Allpeaks,2)
    o1=Allpeaks(:,i);
    o1(o1==0)=[];
    if isempty(o1)==0
    x=o1(1);
    s=size(o1,1);
    A=data4(x-10000:x-9500,1);
    idx=find(A>n);
    m(p)=size(idx,1);
    if m(p)>200
        startsonrecording(in)=i;
        in=in+1;
    end
   
    end
    p=p+1;
end

%Extracting values that ended on recording by lack of negative slope to
%peak
p=1;m=[]; B=[];in=1;
for i=2:2:size(Allpeaks,2)
  
    o1=Allpeaks(:,i);
    o1(o1==0)=[];
    if isempty(o1)==0
    x=o1(end);
    s=size(o1,1);
    A=data5(x:x+15000,1);%original:10000,11000could change these numbers, these were optimized
    idx=find(A<n);
    if isempty(idx)==0 %not empty
    l=idx(1)+x;
    newA=data5(l:(l+5000),1); %finding sustained negative
    idm=find(newA<n);
    m(p)=size(idm,1);
    if m(p)>2000
        %all33(s,i)=0.5;
        B(in)=i;
        in=in+1;
    end
  
    end
    end
      p=p+1;
end
for i=1:2:size(Allpeaks,2)
  
    o1=Allpeaks(:,i);
    o1(o1==0)=[];
    if isempty(o1)==0
    x=o1(end);
    s=size(o1,1);
    A=data5(x:x+15000,1);%original:10000,11000could change these numbers, these were optimized
    idx=find(A<n);
    if isempty(idx)==0
    l=idx(1)+x;
    newA=data5(l:(l+5000),1);
    idm=find(newA<n);
    m(p)=size(idm,1);
    if m(p)>2000
        %all33(s,i)=0.5;
        B(in)=i;
        in=in+1;
    end
  
    end
    end
      p=p+1;
end


%5. Filtering outliers: Occasionally there is a full peak after the end of
%the dataset. Even though these will likely be filtered out later, any
%recording ten seconds after untouched activity (which automatically
%signals the next recording) is placed.
all44=Allpeaks; 
for i=1:1:size(Allpeaks,2)
    o1=Allpeaks(:,i);
    o1(o1==0)=[];
    if isempty(o1)==0
    x=o1(end);
    s=size(o1,1);
    for j=1:1:s-1
        %10 seconds, probably not same recording
        if (Allpeaks(j+1,i)-Allpeaks(j,i))>300000 
            all44(j,i)=0.5;
        end
    end
    
    end
end
Allpeaks=all44;
[Allpeaks]= del(Allpeaks,L,M,.5);

%6. Deleting Values that end on recording pin
%Property of dataset: primarily takes data from dataset5 (if data5 is first
%pin).
final=setdiff(endsonrecording2,startsonrecording); 
for i=1:size(final,2)
    o1=Allpeaks(:,final(1,i));
    o1(o1==0)=[];
    x=o1(end);
    s=size(o1,1);
    Allpeaks(s,final(1,i))=0.5;
end
[Allpeaks]= del(Allpeaks,L,M,.5);
ALL4=Allpeaks;

%7. Removing anything that does not start with turning right (positive)
%Assume that the participant starts by turning the dial right
%Only Assumption made on rating value because of the lack of event marker
%If this is untrue: comment out
startsonrecording=sort(startsonrecording);
o1=1;o2=1;
for j=1:2:(size(Allpeaks,2)) 
        if Allpeaks(o1,j)<Allpeaks(o2,j+1) 
        Allpeaks(o1,j)=0.5;   
        end  
end
[Allpeaks]= del(Allpeaks,L,M,.5);

%7. Removing any glitches at the end
l=size(Allpeaks,1);
for i=1:2:(size(Allpeaks,2))
    o1=Allpeaks(:,i);
    o1(o1==0)=[];
    
    o2=Allpeaks(:,i+1);
    o2(o2==0)=[];
    
    if isempty(o1)==0 && isempty(o2)==0
    
    if o1(1)~=0 && o2(1)~=0 
    x=o1(end); %start to have errors when there are nothing there
    s=size(o1,1);
    x2=o2(end);
    s2=size(o2,1);
    q=min(s,s2);
    Allpeaks((q+1):end,i)=0;
    Allpeaks((q+1):end,i+1)=0;
    else 
    q=1;
    Allpeaks((q+1):end,i)=0;
    Allpeaks((q+1):end,i+1)=0;
    end
    end
    
    if isempty(o1)==1 && isempty(o2)==0 %o2 isn't empty
        Allpeaks(:,i+1)=0;
    end
    if isempty(o2)==1 && isempty(o1)==0
        Allpeaks(:,i)=0;
    end
    
end


%8. Verification and Rating Value Calculaiton
t=1;
for j=1:2:(size(Allpeaks,2))
    O1=Allpeaks(:,j);
    O2=Allpeaks(:,j+1);
   U1(:,t)=O2-O1;
   t=t+1;
end
U1(U1>0)=-1; %if turning counterclockwise: -1 value
U1(U1<-2)=1; %if turning clockwise: +1 value
dir1=cumsum(U1,1); %verify and troubleshoot if it is not working, can see exact values as they are added
total=0;
for i=1:size(U1,2) 
    total=0; %have to make sure not going above 10 or below 0
    for j=1:size(U1,1)
        d=U1(j,i);
        total=total+d;
    if total<0 
        total=0;
    end
    if total>10
        total=10;
    end
    end
    D(i)=total; %final rating values
end
totalrating=D';

%9. Optional: Code for Visualizing segments of rotary encoder data with
%vertical lines of recorded peak values

%options for input matrix
% B = reshape(all33,[],1); %reshaping to get identical values
% B= all33(:,47)
% figure()
% plot(data4([60057112]-10000:[60180882]+10000,:))
% hold on;
% for i=1:size(B,1)
%     xline(B(i),'b');
% end
%  hold on;
%  plot(data5([60057112]-10000:[60180882]+10000,:))


%%----------------------FUNCTIONS--------------------------------


%separating into different ones based on dialpushed start
function [All]=combiningpeaks(peak4rating,peak5rating)
j=1;
X=[size(peak4rating,1),size(peak5rating,1)];
L=max(X);%rows
M=max(size(peak4rating,2),size(peak5rating,2));%columns
All=zeros(L,M);

%populatingarray
if size(peak4rating,2)<size(peak5rating,2)
    peaks=size(peak4rating,2);
else
    peaks=size(peak5rating,2);
end
for(i=1:1:peaks)
    
  
All(1:size(peak4rating(:,i),1),j)=peak4rating(:,i);
j=j+1;
All(1:size(peak5rating(:,i),1),j)=peak5rating(:,i);
j=j+1;
    
end
end

%separating into different ones based on dialpushed start
function [RatingFinal] = rate(peak4pos,dialpushedstart)
a=1;
j=1;
d=1;
i=1;
for i=1:1:size(peak4pos,2)
    if j<=size(dialpushedstart,2)-1
    
    if j>1
        if(peak4pos(i)<dialpushedstart(j)) && peak4pos(i)>dialpushedstart(j-1) 
            RatingFinal(a,d)=peak4pos(i);
            a=a+1;
            i=i+1;
        end
        if peak4pos(i)>dialpushedstart(j) && peak4pos(i)>dialpushedstart(j+1)
        d=d+1;
        j=j+1;
        a=1;
        RatingFinal(a,1+d)=0;
        j=j+1;
        d=d+1;
        a=1;
%       
        end
        if peak4pos(i)>dialpushedstart(j) && peak4pos(i)<dialpushedstart(j+1) 
        %if the peak is greater than dialpushed start and less than next
        %dial pushed start
        %moving to the next one
        d=d+1;
        j=j+1;
        a=1;
        RatingFinal(a,1+d)=peak4pos(i);
        i=i+1;
        end  
    end
    if j==1
    if peak4pos(i)>dialpushedstart(j) 
        d=d+1;
        j=j+1;
        a=1;
        RatingFinal(a,1+d)=peak4pos(i);
    end
    if(peak4pos(i)<dialpushedstart(j)) 
        RatingFinal(a,d)=peak4pos(i);
        a=a+1;
        i=i+1;
    end
    end
    end
    if j==size(dialpushedstart,2)
        if peak4pos(i)>dialpushedstart(j) 
        d=d+1;
        j=j+1;
        a=1;
        RatingFinal(a,1+d)=peak4pos(i);  
   end
     if j<=size(dialpushedstart,2)
     if(peak4pos(i)<dialpushedstart(j)) 
        RatingFinal(a,d)=peak4pos(i);
        a=a+1;
        i=i+1;
    end
    end
    end
end
end

%deleting all values marked, moving up columns because deleting using
%matlab's functions would misalign the shape
function[All5]=del(All4,L,M,x)
j=2; %to get rid of the other one
o=1;
All5=zeros(L,M);
testdelete=[];
q=1;
indices=[];
for(i=1:1:size(All4,2)) %column
for(a=1:1:size(All4,1)) %row
    testdelete=All4(:,i);
    if testdelete(a,1)==x
        indices(o)=a;
        o=o+1;
    end
end
testdelete(indices)=[];
w=size(testdelete,1);
u=size(indices);
for(i=1:1:u)
    testdelete(w+i,1)=0;
    indices=[];
end
o=1;
All5(1:size(testdelete,1),q)=testdelete;
q=q+1;
testdelete=[];
end
end

