% SavingMedianValues of rating value at location, slopes, and median values
% of r1 and r2 separately on repeat

%Output: saves the slope, median values, and x values--> used in classifier

close all
subject='';
folder='path to Scon';
Scondition='Scon2'; %Scon1 or Scon2
filename='.mat';
load(strcat(folder,'\',subject,Scondition,filename))
Scon=[]; condition=2;Scon=Scon2;

r=1;
t=[1,5,10,13,11,18,26,23,42];num=1;number=1;
for channel=1:20
num=1;

for freq=1:9
n=20; gamma=NaN(20,11);gammaplot1=[];xvalues=[];r1=[];r2=[];r11=[];r22=[];
multiplier=t(1,freq);%multiplier number for the frequency
for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];r1=[];r2=[];r11=[];r22=[];
    r11=endpointR1(:,i);
    r1=r11(~isnan(r11));
    r22=endpointR2(:,i);
    r2=r22(~isnan(r22));
    if isempty(Scon{1,channel}{freq,i})==0
        M1=Scon{1,channel}{freq,i}(1:end,:);
    else
        M1=NaN(10,1);
    end
    if isempty(Scon{2,channel}{freq,i})==0
        M2=Scon{2,channel}{freq,i}(1:end,:); %for all of the things for that ratings
    else
        M2=NaN(10,1);
       
    end
    coun1=1;coun2=2;
     for h=1:1:size(r1,1) %1 and 2 will be rating 1, 3 and 4 are rating2
         gammam1(coun1)=nanmedian(M1(:,h),1);
          coun1=coun1+1;
     end
     coun1=1;coun2=1;
     for h=1:1:size(r2,1) %1 and 2 will be rating 1, 3 and 4 are rating2
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
u=50;
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
x=[xvalues;xvalues];
mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
fitobject(number,:)=polyfit(x_t,gamma_t,1);
x_t(end:u)=NaN;
gamma_t(end:u)=NaN;
gamma_T(:,number)=gamma_t;
X_T(:,number)=x_t;

mask2=isnan(gammaplotT);
x_t2=x(~mask2);
gamma_t2=gammaplotT(~mask2);
fitobject2(number,:)=polyfit(x_t2,gamma_t2,1);
gamma_t2(end:u)=NaN;
x_t2(end:u)=NaN;
gamma_T2(:,number)=gamma_t2;
X_T2(:,number)=x_t2;

xx=1:11;
y=fitobject(number,1)*xx+fitobject(number,2);
y2=fitobject2(number,1)*xx+fitobject2(number,2);
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];

num=num+1;
number=number+1;
end
end

save(strcat(subject,Scondition,'median'),'X_T','X_T2','gamma_T','gamma_T2','fitobject','fitobject2','-v7.3')
