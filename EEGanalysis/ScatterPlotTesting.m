%Testing differences in median, mean, and stdev

% %Scon top row: rating 1 (number of rows: channels)
% %Scon bottom row: rating 2

delta=[];alpha=[];theta=[];alpha1=[];alpha2=[];beta1=[];beta2=[];beta=[];
subject='';
load('pathway to Scon');
method='median actual';Scon=[];
condition=3;Scon=Scon3;
numelec=20;

%1. Median
method='median';
r=1;
t=[1,5,10,13,11,18,26,23,42];num=1;number=1;
for channel=1:electrodenumber
figure()
num=1;
sgtitle(strcat(subject,method, ' Condition:',num2str(condition),' Channel:',num2str(channel)))
for freq=1:9
n=20; gamma=NaN(20,11);gammaplot1=[];xvalues=[];r1=[];r2=[];r11=[];r22=[];
multiplier=t(1,freq);%multiplier number for the frequency
for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];r1=[];r2=[];r11=[];r22=[];
    
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
    gammam1=nanmedian(M1,1);
    coun1=coun1+1;
    coun1=1;coun2=1;
    gammam2=nanmedian(M2,1);
    coun1=coun1+1;
        
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
gammaplot=[gammaplot1;gammaplot2]; %combining rating 1 and rating 2

xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
x=[xvalues;xvalues];

mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
gammar=gamma_t;
fitobject(number,:)=polyfit(x_t,gammar,1);%gamma_t,1);
xx=1:11;
y=fitobject(number,1)*xx+fitobject(number,2);
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
subplot(3,3,num)
scatter(x_t,gammar,'MarkerEdgeColor','m');
hold on;
plot(xx,y,'Color','b','LineWidth',1);
xticks([1 2 3 4 5 6 7 8 9 10])
xlabel('Rating')
ylabel('Power (uV^2/Hz)')
set(gcf,'color','w');
set(gca,'linewidth',2)
num=num+1;

title(ff{freq});

number=number+1;
end
end

%2. Mean 
method=' mean';
for channel=1:numelec
figure()
sgtitle(strcat(subject, method,'Rating1,2', ' Condition:',num2str(condition),' Channel:',num2str(channel)))
for freq=1:9
n=20; gamma=NaN(20,11);gammaplot1=[];xvalues=[];
for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];
    gammam1=nanmean(Scon{1,channel}{freq,i},1);
    gammam2=nanmean(Scon{2,channel}{freq,i},1);
    gammam1(gammam1==0)=[];
    gammam2(gammam2==0)=[];
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
gammaplot=[gammaplot1;gammaplot2];
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
x=[xvalues;xvalues];
mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
fitobject(number,:)=polyfit(x_t,gamma_t,1);

xx=1:11;
y=fitobject(number,1)*xx+fitobject(number,2);
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
subplot(3,3,freq)
scatter(x,gammaplot);
hold on;
plot(xx,y);
text(8,mean(gamma_t),strcat(num2str(fitobject(number,1)),'x+',num2str(fitobject(number,2))),'FontSize',7)
title(freq);
number=number+1;
end
end

 
%3.Stddev
method='stddev';
for channel=1:numelec
figure()
sgtitle(strcat(method,'Rating1,2', ' Condition:',num2str(condition),' Channel:',num2str(channel)))
for freq=1:9
n=20; gamma=NaN(20,11);gammaplot1=[];xvalues=[];
for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];
    gammam1=std(Scon{1,channel}{freq,i},'omitnan');
    gammam2=std(Scon{2,channel}{freq,i},'omitnan');
    gammam1(gammam1==0)=[];
    gammam2(gammam2==0)=[];
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
gammaplot=[gammaplot1;gammaplot2];
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
x=[xvalues;xvalues];
mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
fitobject(number,:)=polyfit(x_t,gamma_t,1);

xx=1:11;
y=fitobject(number,1)*xx+fitobject(number,2);
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];
subplot(3,3,freq)
scatter(x,gammaplot);
hold on;
plot(xx,y);
text(8,mean(gamma_t),strcat(num2str(fitobject(number,1)),'x+',num2str(fitobject(number,2))),'FontSize',7)
title(freq);
number=number+1;
end
end




