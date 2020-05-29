%Generates timepoints for analysis 

subject='subject';
cutoff=1;
load('path to conveyor_behavior');

%Initial Values
fs=1000;

data_behavior=; %place time array in here of position of interest

%Time regions for each position on Conveyor Belt depending on event chosen
[first1 idx1]=find(conveyor_behavior(:,2)==0);
[second idx2]=find(conveyor_behavior(:,2)==0.25);
[third idx3]=find(conveyor_behavior(:,2)==0.5);
[fourth idx4]=find(conveyor_behavior(:,2)==0.75);
[closest1 idx5]=find(conveyor_behavior(:,2)==1);
X1=NaN(1,9); %9 frequency bands
X2=NaN(1,9);
for i=1:size(closest1,1)
X5(i)=data_behavior1(closest1(i,1),1);
hold on;
end
for i=1:size(first1,1)
X1(i)=(data_behavior1(first1(i,1),1));
hold on;
end
for i=1:size(second,1)
X2(i)=(data_behavior1(second(i,1),1));
hold on;
end
for i=1:size(third,1)
X3(i)=(data_behavior1(third(i,1),1));
hold on;
end
for i=1:size(fourth,1)
X4(i)=(data_behavior1(fourth(i,1),1));
hold on;
end


%%For Scon1 and Scon2
endpointR2=[];endpointR1=[];
R1=conveyor_behavior(:,3); %rating 1
R2=conveyor_behavior(:,4); %rating 2
a=[0,1,2,3,4,5,6,7,8,9,10;0,1,2,3,4,5,6,7,8,9,10];
n=20;

%rating 2
j=2;
zero=NaN(n,1);one=NaN(n,1); two=NaN(n,1);
third=NaN(n,1); fourth=NaN(n,1);fifth=NaN(n,1);
six=NaN(n,1);seven=NaN(n,1);eight=NaN(n,1);nine=NaN(n,1);
ten=NaN(n,1);
[zero idx1]=find(R2==a(j,1));
[one idx2]=find(R2==a(j,2));
[two idx3]=find(R2==a(j,3));
[three idx3]=find(R2==a(j,4));
[fourth idx3]=find(R2==a(j,5));
[fifth idx1]=find(R2==a(j,6));
[six idx2]=find(R2==a(j,7));
[seven idx3]=find(R2==a(j,8));
[eight idx3]=find(R2==a(j,9));
[nine idx3]=find(R2==a(j,10));
[ten idx3]=find(R2==a(j,11));
%because arrays are different sizes, in order to make into a matrix
%they need to be standardized to the same size
zero(end+1:n,1)=NaN;
one(end+1:n,1)=NaN;
two(end+1:n,1)=NaN;
three(end+1:n,1)=NaN;
fourth(end+1:n,1)=NaN;
fifth(end+1:n,1)=NaN;
six(end+1:n,1)=NaN;
seven(end+1:n,1)=NaN;
eight(end+1:n,1)=NaN;
nine(end+1:n,1)=NaN;
ten(end+1:n,1)=NaN;
D=NaN(n,11);
D=[zero,one,two,three,fourth,fifth,six,seven,eight,nine,ten];
endpointR2=D;
%rating1
j=1;
zero=NaN(n,1);one=NaN(n,1); two=NaN(n,1);
third=NaN(n,1); fourth=NaN(n,1);fifth=NaN(n,1);
six=NaN(n,1);seven=NaN(n,1);eight=NaN(n,1);nine=NaN(n,1);
ten=NaN(n,1);
[zero idx1]=find(R1==a(j,1));
[one idx2]=find(R1==a(j,2));
[two idx3]=find(R1==a(j,3));
[three idx3]=find(R1==a(j,4));
[fourth idx3]=find(R1==a(j,5));
[fifth idx3]=find(R1==a(j,6));
[six idx2]=find(R1==a(j,7));
[seven idx3]=find(R1==a(j,8));
[eight idx3]=find(R1==a(j,9));
[nine idx3]=find(R1==a(j,10));
[ten idx3]=find(R1==a(j,11));
zero(end+1:n,1)=NaN;
one(end+1:n,1)=NaN;
two(end+1:n,1)=NaN;
three(end+1:n,1)=NaN;
fourth(end+1:n,1)=NaN;
fifth(end+1:n,1)=NaN;
six(end+1:n,1)=NaN;
seven(end+1:n,1)=NaN;
eight(end+1:n,1)=NaN;
nine(end+1:n,1)=NaN;
ten(end+1:n,1)=NaN;
D=NaN(n,11);
D=[zero,one,two,three,fourth,fifth,six,seven,eight,nine,ten];
D(end+1:n)=NaN;
endpointR1=D;


