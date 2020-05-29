%making the matrix for the permutationtest
%column1: rating1, column2: rating2, 3rd: rating3

%to run this code: run condition1Scon.m, condition2Scon.m, and timepoint.m

%output: C1 (rating1;rating2) EEG values and C2 (total rating EEG values) 

subject='';
folder='path to Scon';
Scondition='Scon2'; %Scon1 or Scon2
condition=2;
filename='';
load(filename and folder)
Scon=Scon2;

%Initial Variables
t=[1,5,10,13,11,18,26,23,42];num=1;number=1;
p=1;NN=300;column1=[];column2=[];column3=[];x1=[];x2=[];x3=[];

%Code for extracting median values: Unlike other codes saves each value
%instead of overwriting
for channel=1:20

for freq=1:9
n=20; gamma=NaN(20,11);gammaplot1=[];xvalues=[];
multiplier=t(1,freq);%multiplier number for the frequency
for i=1:11
    gamma_t=[];gamma_t2=[];x_t=[];x_t2=[];
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];r1=[];r2=[];r11=[];r22=[];
    r11=endpointR1(:,i);
    r1=r11(~isnan(r11));
    r22=endpointR2(:,i);
    r2=r22(~isnan(r22));
    if isempty(Scon{1,channel}{freq,i})==0
        g1=1;
    M1=Scon{1,channel}{freq,i}(g1:end,:);
    else
        M1=NaN(10,1); 
    end
    
    if isempty(Scon{2,channel}{freq,i})==0
        g1=1;
    M2=Scon{2,channel}{freq,i}(g1:end,:); %for all of the things for that ratings
    else
        M2=NaN(10,1);
    end
    coun1=1;coun2=2;
     for h=1:1:size(r1,1) %1 and 2 will be rating 1, 3 and 4 are rating2

         gammam1(coun1)=nanmedian(M1(:,h),1);
          coun1=coun1+1;

     end
     coun1=1;coun2=1;
     for h=1:1:size(r2,1) 
          gammam2(coun1)=nanmedian(M2(:,h),1);
          coun1=coun1+1;
     end
    gammam1(gammam1==0)=[];gammam2(gammam2==0)=[];
    if isempty(gammam1)==0 %accounting for empty ones
        gammam1(end+1:n)=NaN;
        gamma(:,i)=gammam1;
    else
        gammam1=NaN(20,1);
        gamma(:,i)=gammam1;        
    end
    if isempty(gammam2)==0 %for rating2
    gammam2(end+1:n)=NaN;
    gamma2(:,i)=gammam2;

    else
        gammam2=NaN(20,1);
        gamma2(:,i)=gammam2;

    end
end
gammaplot1=reshape(gamma,[],1);
gammaplot2=reshape(gamma2,[],1);
gammaplot=[gammaplot1];
gammaplotT=[gammaplot2];
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
x=[xvalues;xvalues];

mask=isnan(gammaplot);
x_t(:,1)=x(~mask);
gamma_t(:,1)=gammaplot;

mask2=isnan(gammaplotT);
x_t2(:,1)=x(~mask2);
gamma_t2(:,1)=gammaplotT;

gamma_t(end+1:NN,1)=NaN;
gamma_t2(end+1:NN,1)=NaN;
x_t(end+1:NN,1)=NaN;
x_t2(end+1:NN,1)=NaN;
column1(:,p)=gamma_t;
column2(:,p)=gamma_t2;
column3(:,p)=[gamma_t;gamma_t2];
x1(:,p)=x_t;
x2(:,p)=x_t2;
x3(:,p)=[x_t;x_t2];
p=p+1;
end 
end


%Defining: matrices for permutationexecution.m for rating1, rating2, and
%all median values
C1=[column1,column2];
X1=[x1,x2];
C2=column3;

save(strcat(subject, Scondition,'median_permmatrix.mat','C1','C2')