
%Condition2.Time periods for Rating1 and Rating2 periods
%This code extracts information from the morlet wavelet analysis and gets
%the EEG power spectrum for each frequency band. Then, it divides up this
%power spectrum into smaller regions for investigation, in this case the
%Conveyor and Holding periods. 

%to use code: run timepoint.m before

folder='D:\tanaya_EEG_conveyorbelt\';
subject='ABV006';


cutoff=1;
endpoint=sort(endpoint,1);
%defining times
t=1; %1 sec periods for analysis
deltat=1;thetat=1/6; alphat=1/12; alpha1t=1/10;alpha2t=1/13; beta1t=1/18;
beta2t=1/26; gammat=1/40;

%Initial Values
fs=1000;
movingtime=6500;
movingtimebig=movingtime*4;
c=cutoff; %for abv002 3.5e7/30, 3.5e6/30 for abv005
data_behavior=[];data_info=[];
data_behavior1=movingend1'/30-movingtime-c;
data_behavior1(13,1)=movingend1(1,13)/30-movingtimebig-c;
data_behavior1(26,1)=movingend1(1,26)/30-movingtimebig-c;
data_behavior1(39,1)=movingend1(1,39)/30-movingtimebig-c;

filename='_elec';
number=1;
%r1low: whatever defined as r1low is put into the beginning
for i=1:20
    
load(strcat(folder,subject,'\',subject,'_',num2str(channel),filename))
M=real(freqanalysis_allelec{1,1});
C=log(M);
C1=real(C);
%--------------------Calculating frequency Bands--------------------------
%dividing up into frequency ranges
delta=C1(1:7,:);
delta_m=mean(delta,1);
theta=C1(8:16,:);
theta_m=mean(theta,1);
alpha1=C1(17:25,:);
alpha_m1=mean(alpha1,1);
alpha2=C1(26:31,:);
alpha_m2=mean(alpha2,1);
beta1=C1(32:39,:);
beta_m1=mean(beta1,1);
beta2=C1(40:47,:);
beta_m2=mean(beta2,1);
alpha=C1(17:31,:);
alpha_m=mean(alpha,1);
beta=C1(32:47,:);
beta_m=mean(beta,1);
gamma=C1(48:73,:);
gamma_m=mean(gamma,1);
 
%------------------for r1 power extraction--------------------------------

for u=1:1:11
    T1=endpointR1(:,u);
    r1s=[];
    C=[];
    endpoint1=T1(~isnan(T1));
    if isempty(endpoint1)==0

    dp_c=dialpushedstart/30-cutoff;
    dp_c_odd=dp_c(1:2:end);
    dp_c_odd(1,1)=8*fs;
    r_down_c=(ratingstart/30)-cutoff;
    r_c_odd=r_down_c(1:2:end);
    r_c_odd(1,1)=dialpushedstart(1,1)/30-cutoff-3;
    t=1;a=1;o=2;A=1;a=1;

if endpoint1(1,1)==1
    C=[];
    r1s(1,1)=A;
    a=[];a=2;
    for i=2:size(endpoint1,1)
        if endpoint1(i,1)==27 || endpoint1(i,1)==14
            r1s(a)=dp_c_odd(endpoint1(i,1))-5*fs;
            a=a+1;
        else
            d(i)=endpoint1(i,1);
            r1s(a)=r_c_odd(endpoint1(i,1),1);
            a=a+1;
        end
  
    end
else
    for i=1:size(endpoint1,1)
        if endpoint1(i,1)==27 || endpoint1(i,1)==14
            r1s(a)=dp_c_odd(endpoint1(i,1))-5*fs;
            a=a+1;
        else
            d(i)=endpoint1(i,1);
            r1s(a)=r_c_odd(endpoint1(i,1),1);
            a=a+1;
        end
    end
end
C=r1s';%starting values
dp=dp_c_odd;%ending values
t=1;%time sampling (t times a second)

[Adelta,Adeltar1low]=ratingcon(C,endpoint1,dp,t,fs,delta_m);
t=1/6;
[Atheta,Athetar1low]=ratingcon(C,endpoint1,dp,t,fs,theta_m);
t=1/10;
[Aalpha1,Aalpha1r1low]=ratingcon(C,endpoint1,dp,t,fs,alpha_m1);
t=1/13;
[Aalpha2,Aalpha2r1low]=ratingcon(C,endpoint1,dp,t,fs,alpha_m2);
t=1/12;
[Aalpha,Aalphar1low]=ratingcon(C,endpoint1,dp,t,fs,alpha_m);
t=1/22;
[Abeta,Abetar1low]=ratingcon(C,endpoint1,dp,t,fs,beta_m);
t=1/18;
[Abeta1,Abeta1r1low]=ratingcon(C,endpoint1,dp,t,fs,beta_m1);
t=1/26;
[Abeta2,Abeta2r1low]=ratingcon(C,endpoint1,dp,t,fs,beta_m2);
t=1/40;
[Agamma,Agammar1low]=ratingcon(C,endpoint1,dp,t,fs,gamma_m);

Scon2r1{1,u}=Adelta;%rows: frequency band, number=rating#)
Scon2r1{2,u}=Atheta;
Scon2r1{3,u}=Aalpha1;
Scon2r1{4,u}=Aalpha2;
Scon2r1{5,u}=Aalpha;
Scon2r1{6,u}=Abeta1;
Scon2r1{7,u}=Abeta2;
Scon2r1{8,u}=Abeta;
Scon2r1{9,u}=Agamma;

else
    for aa=1:1:9
    Scon2r1{aa,u}=[];
    end
end

end
%------------------for r2 power extraction---------------------------------

for u=1:1:11
    T1=endpointR2(:,u);
    r1s=[];
    C=[];
    endpoint1=T1(~isnan(T1));
    if isempty(endpoint1)==0
    dp_c=dialpushedstart/30-cutoff;
    dp_c_even=dp_c(2:2:end);
    dp_c_even=dp_c_even;
    t=1; o=2;
    A=dp_c_even(1,1)-5*fs;
    r_down_c=(ratingstart/30)-cutoff;
    r_c_even=r_down_c(2:2:end);
    r_c_even=r_c_even';
    r_c_even(1,1)=dialpushedstart(1,1)/30-cutoff+10;

    C=[];
    r2s(1,1)=A;
    a=2;

    for i=2:size(endpoint1,1)
        if endpoint1(i,1)==27 || endpoint1(i,1)==14
            r2s(a)=dp_c_even(1,endpoint1(i,1))-5*fs;
            a=a+1;
        else
            d(i)=endpoint1(i,1);
            r2s(a)=r_c_even(1,endpoint1(i,1));
            a=a+1;
        end
    end
    C=r2s';
    dp=dp_c_even;

t=1;
[Bdelta,Adeltar2low]=ratingcon(C,endpoint1,dp,t,fs,delta_m);
t=1/6;
[Btheta,Athetar2low]=ratingcon(C,endpoint1,dp,t,fs,theta_m);
t=1/10;
[Balpha1,Aalpha1r2low]=ratingcon(C,endpoint1,dp,t,fs,alpha_m1);
t=1/13;
[Balpha2,Aalpha2r2low]=ratingcon(C,endpoint1,dp,t,fs,alpha_m2);
t=1/12;
[Balpha,Aalphar2low]=ratingcon(C,endpoint1,dp,t,fs,alpha_m);
t=1/22;
[Bbeta,Abetar2low]=ratingcon(C,endpoint1,dp,t,fs,beta_m);
t=1/18;
[Bbeta1,Abeta1r2low]=ratingcon(C,endpoint1,dp,t,fs,beta_m1);
t=1/26;
[Bbeta2,Abeta2r2low]=ratingcon(C,endpoint1,dp,t,fs,beta_m2);
t=1/40;
[Bgamma,Agammar2low]=ratingcon(C,endpoint1,dp,t,fs,gamma_m);

Scon2r2{1,u}=Bdelta;%rows: frequency band, number=rating#)
Scon2r2{2,u}=Btheta;
Scon2r2{3,u}=Balpha1;
Scon2r2{4,u}=Balpha2;
Scon2r2{5,u}=Balpha;
Scon2r2{6,u}=Bbeta1;
Scon2r2{7,u}=Bbeta2;
Scon2r2{8,u}=Bbeta;
Scon2r2{9,u}=Bgamma;
else
    for aa=1:1:9
    Scon2r2{aa,u}=[];
    end
end
end
Scon2{1,number}=Scon2r1;
Scon2{2,number}=Scon2r2;
number=number+1;
end
save(strcat(subject,'Scon2.mat'),'Scon2','-v7.3');

%function extracts and shapes the power values within the timeframes
function [Adelta,Adelta_v5]=ratingcon(C, endpoint1, dp_c_odd, t,fs,delta_m)
Adelta=NaN(150,size(endpoint1,1));
r=[];
w=[];
a=1;
j=1;
timepoint1=[];
timepoint2=[];
l=[];

for j=1:(size(endpoint1,1))%-1) %was 1 for other, endpoint1 is to give the index

a=1;%for low1
start(j)=C(j,1);
y(j)=endpoint1(j,1);
ending(j)=dp_c_odd(1,y(j));
l(j)=round((ending(j)-start(j))/fs);
   
    if l(j)>10
        l(j)=10;
    end
    for i=1:round(l(j)/t)
        w=[];
        timepoint1(i)=round(start(j)+t*fs*i);
        timepoint2(i)=round(start(j)+t*fs*(i+1));
        w=(delta_m(timepoint1(i):timepoint2(i)));
        r(i)=mean(w);%(i,:));
    Adelta(i,j)=r(i);
    end
    
end

Adelta_v2=reshape(Adelta,[],1);
Adelta_v3=sort(Adelta_v2);
Adelta_v5=Adelta_v3(~isnan(Adelta_v3)); 
end
