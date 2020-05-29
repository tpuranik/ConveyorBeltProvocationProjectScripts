%Goal: Visualize differences in signal based on behaviorial aspects of task
%Testing Behaviorial aspects and plotting difference in median

%To implement this code: 
%1. First run timepoint.m and scon1updated.m or scon2updated.m
%2. Next change subject, condition, and Scon


%output: saves difference in slopes between R1 and R1 and slopes of both

%Loading EEG values extracted from timepoints (Scon1 or Scon2)
subject='';
condition=3; 
electrodenumber=20; %20 total electrodes in this study, can change to 3, 4
%if only looking at the first few channels

%load Scon values
load('pathway to Scon value');
statisticalmetric='median';
Scon=[]; Scon= ;%Scon1 or Scon2

%1. Testing R1 and R2
method='rating1and2';
r=1;
t=[1,5,10,13,11,18,26,23,42]; %this is the middle frequency for all frequency ranges
num=1;number=1;
ff=({'Delta','Theta','Alpha1','Alpha2','Alpha','Beta1','Beta2','Beta','Gamma'});

for channel=1:electrodenumber
figure()
num=1;
sgtitle(strcat(subject,method, ' Condition:',num2str(condition),' Channel:',num2str(channel)))

for freq=1:9 %looping through each frequency
%initializing variables   
n=20; gamma=NaN(n,11);gammaplot1=[];xvalues=[];r1=[];r2=[];r11=[];r22=[];
multiplier=t(1,freq);%multiplier number for the frequency

for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];r1=[];r2=[];r11=[];r22=[];
    r11=endpointR1(:,i);
    r1=r11(~isnan(r11));
    r22=endpointR2(:,i);
    r2=r22(~isnan(r22));
    if isempty(Scon{1,channel}{freq,i})==0
        g1=1;
        g2=2*multiplier;
    M1=Scon{1,channel}{freq,i}(g1:end,:);
    M3=Scon{1,channel}{freq,i}(g2+1:end,:);
    else
        M1=NaN(10,1);
         M3=NaN(10,1);
    end
    
    if isempty(Scon{2,channel}{freq,i})==0
        g1=1;
        g2=2*multiplier;
    M2=Scon{2,channel}{freq,i}(g1:end,:); %for all of the things for that ratings
    M4=Scon{2,channel}{freq,i}(g2:end,:);
    else
        M2=NaN(10,1);
        M4=NaN(10,1);
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
    if isempty(gammam1)==0 %accounting for empty ones because of no ratings at certain values
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
x_t=x(~mask);
gamma_t=gammaplot(~mask);
gammar=gamma_t;
fitobject(number,:)=polyfit(x_t,gammar,1);%gamma_t,1);

mask2=isnan(gammaplotT);
x_t2=x(~mask2);
gamma_t2=gammaplotT(~mask2);
fitobject2(number,:)=polyfit(x_t2,gamma_t2,1);

xx=1:11;
y=fitobject(number,1)*xx+fitobject(number,2);
y2=fitobject2(number,1)*xx+fitobject2(number,2);
xvalues=[zeros(20,1);ones(20,1);ones(20,1)*2;ones(20,1)*3;ones(20,1)*4;ones(20,1)*5;ones(20,1)*6;ones(20,1)*7;ones(20,1)*8;ones(20,1)*9;ones(20,1)*10];

subplot(3,3,num)
scatter(x_t,gammar,[],'b');
hold on;
plot(xx,y,'Color','b');
hold on;
scatter(x_t2,gamma_t2,[],'r');
hold on;
plot(xx,y2,'Color','r');
set(gcf,'color','w');
xticks([1 2 3 4 5 6 7 8 9 10])
xlabel('Rating')
ylabel('Power (uV^2/Hz)')
[YY,KK]=ttest2(gammar,gamma_t2);
r1fitobject(freq,channel)=fitobject(number,1);
r2fitobject(freq,channel)=fitobject2(number,1);
difR1(freq,channel)=abs(fitobject(number,1)-fitobject2(number,1)); %difference between slopes

num=num+1;
text(8,mean(gamma_t),strcat(num2str(fitobject(number,1)),'x+',num2str(fitobject(number,2))),'FontSize',7)
text(5,mean(gamma_t2),strcat(num2str(fitobject2(number,1)),'x+',num2str(fitobject2(number,2))),'FontSize',7)

title(ff{freq});
number=number+1;
end
end
save('R1vsR2data.mat','r1fitobject','r2fitobject','difR1','-v7.3');

%plotting difference between slopes of R1 and R2
figure()
imagesc(difR1,[0 0.02]);
title(strcat(subject,' ',num2str(condition)));
xlabel('channel')
ylabel('frequency band')
xticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20])
xticklabels({'AFZ','C3','C4','CPZ','CZ','F3','F4','F7','F8','FC1','FC2','FC5','FC6','FP1','FP2','FT9','FT10','FZ','T7','T8'})
yticklabels({'Delta','Theta','Alpha1','Alpha2','Alpha','Beta1','Beta2','Beta','Gamma'})
set(gca,'linewidth',1)
set(gca,'FontWeight','bold')
set(gcf,'color','w');

%2. Visualizing as a whole
method='combined';
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

%3. Non-provoking versus provoking testing
method='NP vs P';
r=1;
t=[1,5,10,13,11,18,26,23,42];num=1;number=1;
for channel=1:electrodenumber
figure()
num=1;
sgtitle(strcat(subject,method, ' Condition:',num2str(condition),' Channel:',num2str(channel)))
for freq=1:9
n=20; gamma=NaN(n,11);gammaplot1=[];xvalues=[];r1=[];r2=[];r11=[];r22=[];
multiplier=t(1,freq);%multiplier number for the frequency
for i=1:11
    gammam3=[];gammam4=[];
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];r1=[];r2=[];r11=[];r22=[];
    r11=endpointR1(:,i);
    r1=r11(~isnan(r11));
    r22=endpointR2(:,i);
    r2=r22(~isnan(r22));
    if isempty(Scon{1,channel}{freq,i})==0
        g1=1;
        g2=1;
    M1=Scon{1,channel}{freq,i}(g1:end,:);
    M3=Scon{1,channel}{freq,i}(g2:end,:);
    else
        M1=NaN(10,1);
        M3=NaN(10,1);
    end
    if isempty(Scon{2,channel}{freq,i})==0
        g1=1;
        g2=1;
    M2=Scon{2,channel}{freq,i}(g1:end,:); %for all of the things for that ratings
    M4=Scon{2,channel}{freq,i}(g2:end,:);
    else
        M2=NaN(10,1);
        M4=NaN(10,1);
    end
    coun1=1;coun2=1;
  
     for h=1:1:size(r1,1) %1 and 2 will be rating 1, 3 and 4 are rating2
         if r1(h,1)<14 || r1(h,1)>26
         gammam1(coun1)=nanmedian(M1(:,h),1);
         coun1=coun1+1;
         else
         gammam2(coun2)=nanmedian(M1(:,h),1);
         coun2=coun2+1;
         end
         
     end
     coun1=1;coun2=1;
     for h=1:1:size(r2,1) %1 and 2 will be rating 1, 3 and 4 are rating2
        
         if r2(h,1)<14 || r2(h,1)>26
          gammam3(coun1)=nanmedian(M2(:,h),1);
         coun1=coun1+1;
         else
         gammam4(coun2)=nanmedian(M2(:,h),1);
         coun2=coun2+1;
         end
        
     end  
    gammam1(gammam1==0)=[];gammam2(gammam2==0)=[];
    gammam3(gammam3==0)=[];gammam4(gammam4==0)=[];
    if isempty(gammam1)==0 %accounting for empty ones
    gammam1(end+1:n)=NaN;
    gamma(:,i)=gammam1;
    gammam3(end+1:n)=NaN;
    gamma3(:,i)=gammam3;
    else
        gammam1=NaN(n,1);
        gamma(:,i)=gammam1;
        gammam3=NaN(n,1);
        gamma3(:,i)=gammam3;
        
    end
    if isempty(gammam2)==0 %for rating2
    gammam2(end+1:n)=NaN;
    gamma2(:,i)=gammam2;
    gammam4(end+1:n)=NaN;
    gamma4(:,i)=gammam4;
    else
        gammam2=NaN(n,1);
        gamma2(:,i)=gammam2;
        gammam4=NaN(n,1);
        gamma4(:,i)=gammam4;
    end
end
gammaplot1=reshape(gamma,[],1);
gammaplot2=reshape(gamma2,[],1);
gammaplot3=reshape(gamma3,[],1);
gammaplot4=reshape(gamma4,[],1);
gammaplot=[gammaplot1;gammaplot3];
gammaplotT=[gammaplot2;gammaplot4];
xvalues=[zeros(n,1);ones(n,1);ones(n,1)*2;ones(n,1)*3;ones(n,1)*4;ones(n,1)*5;ones(n,1)*6;ones(n,1)*7;ones(n,1)*8;ones(n,1)*9;ones(n,1)*10];
x=[xvalues;xvalues];

mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
gammar=gamma_t;
fitobject(number,:)=polyfit(x_t,gammar,1);

mask2=isnan(gammaplotT);
x_t2=x(~mask2);
gamma_t2=gammaplotT(~mask2);
fitobject2(number,:)=polyfit(x_t2,gamma_t2,1);

xx=1:11;
y=fitobject(number,1)*xx+fitobject(number,2);

y2=fitobject2(number,1)*xx+fitobject2(number,2);
subplot(3,3,num)
scatter(x_t,gammar,'MarkerEdgeColor',[0.4940 0.1840 0.5560]);
hold on;
scatter(x_t2,gamma_t2,'MarkerEdgeColor',[0.4660 0.6740 0.1880]);
hold on;
plot(xx,y,'Color',[0.4940 0.1840 0.5560]);
hold on;
plot(xx,y2,'Color',[0.4660 0.6740 0.1880]);
num=num+1;
set(gcf,'color','w');
xticks([1 2 3 4 5 6 7 8 9 10])
xlabel('Rating')
ylabel('Power (uV^2/Hz)')
[NPP,PP]=ttest2(gammar,gamma_t2);
title(ff{freq});
number=number+1;
end
%saveas(gcf,strcat(subject,method,channel,'.png'),'.png');
end


%4. Testing Close Versus Far
method='close versus far'; r=1;
t=[1,5,10,13,11,18,26,23,42];num=1;number=1;
for channel=1:electrodenumber
figure()
num=1;
sgtitle(strcat(subject,method, ' Condition:',num2str(condition),' Channel:',num2str(channel)))
for freq=1:9
n=20; gamma=NaN(n,11);gammaplot1=[];xvalues=[];r1=[];r2=[];r11=[];r22=[];
multiplier=t(1,freq);%multiplier number for the frequency
for i=1:11
    gammam1=[];gamp=[];gam=[]; gammam2=[];gammaplot2=[];r1=[];r2=[];r11=[];r22=[];
    r11=endpointR1(:,i);
    r1=r11(~isnan(r11));
    r22=endpointR2(:,i);
    r2=r22(~isnan(r22));
    if isempty(Scon{1,channel}{freq,i})==0
 
    M1=Scon{1,channel}{freq,i}(1:end,:);
    M3=Scon{1,channel}{freq,i}(1:end,:);
    else
        M1=NaN(10,1);
         M3=NaN(10,1);
    end
    
    if isempty(Scon{2,channel}{freq,i})==0
    M2=Scon{2,channel}{freq,i}(1:end,:); %for all of the things for that ratings
    M4=Scon{2,channel}{freq,i}(1:end,:);
    else
        M2=NaN(10,1);
        M4=NaN(10,1);
    end
    coun1=1;coun2=2;
     for h=1:1:size(r1,1) %1 and 2 will be rating 1, 3 and 4 are rating2
        if (r1(h,1)<7) || (r1(h,1)>13 && r1(h,1)<20) ||  (r1(h,1)>26 && r1(h,1)<33)  %(0<r1(h,1)<7) || (13<r1(h,1)<20) || (26<r1(h,1)<33) %far
         gammam1(coun1)=nanmedian(M1(:,h),1);
          coun1=coun1+1;
         else
         gammam2(coun2)=nanmedian(M1(:,h),1);
          coun2=coun2+1;
         end
         
     end
     coun1=1;coun2=1;
     for h=1:1:size(r2,1) %1 and 2 will be rating 1, 3 and 4 are rating2
        
         if (r2(h,1)<7) || (r2(h,1)>13 && r2(h,1)<20) ||  (r2(h,1)>26 && r2(h,1)<33) %(0<r2(h,1)<7) || (13<r2(h,1)<20) || (26<r2(h,1)<32) %far
          gammam3(coun1)=nanmedian(M2(:,h),1);
          coun1=coun1+1;
         else %close
         gammam4(coun2)=nanmedian(M2(:,h),1);
         coun2=coun2+1;
         end
         
     end

    gammam1(gammam1==0)=[];gammam2(gammam2==0)=[];
    gammam3(gammam3==0)=[];gammam4(gammam4==0)=[];
    if isempty(gammam1)==0 %accounting for empty ones
    gammam1(end+1:n)=NaN;
    gamma(:,i)=gammam1;
    gammam3(end+1:n)=NaN;
    gamma3(:,i)=gammam3;
    else
        gammam1=NaN(n,1);
        gamma(:,i)=gammam1;
        gammam3=NaN(n,1);
        gamma3(:,i)=gammam3;
        
    end
    if isempty(gammam2)==0 %for rating2
    gammam2(end+1:n)=NaN;
    gamma2(:,i)=gammam2;
    gammam4(end+1:n)=NaN;
    gamma4(:,i)=gammam4;
    else
        gammam2=NaN(n,1);
        gamma2(:,i)=gammam2;
        gammam4=NaN(n,1);
        gamma4(:,i)=gammam4;
    end
end
gammaplot1=reshape(gamma,[],1);
gammaplot2=reshape(gamma2,[],1);
gammaplot3=reshape(gamma3,[],1);
gammaplot4=reshape(gamma4,[],1);
gammaplot=[gammaplot1;gammaplot3];
gammaplotT=[gammaplot2;gammaplot4];

xvalues=[zeros(n,1);ones(n,1);ones(n,1)*2;ones(n,1)*3;ones(n,1)*4;ones(n,1)*5;ones(n,1)*6;ones(n,1)*7;ones(n,1)*8;ones(n,1)*9;ones(n,1)*10];
x=[xvalues;xvalues];

mask=isnan(gammaplot);
x_t=x(~mask);
gamma_t=gammaplot(~mask);
gammar=gamma_t;
fitobject(number,:)=polyfit(x_t,gammar,1);

mask2=isnan(gammaplotT);
x_t2=x(~mask2);
gamma_t2=gammaplotT(~mask2);
fitobject2(number,:)=polyfit(x_t2,gamma_t2,1);

xx=1:11;
y=fitobject(number,1)*xx+fitobject(number,2);
y2=fitobject2(number,1)*xx+fitobject2(number,2);

subplot(3,3,num)
scatter(x_t,gammar,'MarkerEdgeColor',[0.8500 0.3250 0.0980]);
hold on;
scatter(x_t2,gamma_t2,'MarkerEdgeColor',[0.3010 0.7450 0.9330]);
hold on;
plot(xx,y,'Color',[0.8500 0.3250 0.0980]);
hold on;
plot(xx,y2,'Color',[0.3010 0.7450 0.9330])
 num=num+1;
set(gcf,'color','w');
xticks([1 2 3 4 5 6 7 8 9 10])
xlabel('Rating')
ylabel('Power (uV^2/Hz)')
[Close,Far]=ttest2(gammar,gamma_t2);
title(ff{freq});

number=number+1;
end

end 
set(gcf,'color','w');
