% This code looks at the raw EEG signal. It can be used to visualize
% changes in raw EEG signal, changes due to timpeoints of the task, and
% also additional artificants not removed by ICA.

subject='';
addpath('open ephys tools');
load('ft_data from EEGpreprocess.m')
load('uft_data from EEG preprocess.m')
load('conveyor_behavior')
addpath('path to ADC rotary encoder files')

% Uploading Raw data files for verification
data1 = load_open_ephys_data_faster('data1');%in conveyor
data4 = load_open_ephys_data_faster('data4');%turning
data6 = load_open_ephys_data_faster('data6'); %pushingofdial


% databrowser scrolling through data using fieldtrip
cfg = [];
cfg.viewmode = 'vertical';
ft_databrowser(cfg, ft_data)

cfg = [];
cfg.viewmode = 'vertical';
ft_databrowser(cfg, uft_data)

%Creating Plot with shaded regions of Conveyor Movement

%For Unfiltered Signal
fs=1000;x=[];offset = 10;%offset of signal
amplitudereduction=80; %this can be modified depending on amplitude of signal
for i=1:20
x(i,:)=uft_data.trial{1, 1}(i,:)/amplitudereduction;
end
offset_vector = (offset:offset:20*offset)';
uftx_offset=zeros(20,size(x,2));
uftx_offset=bsxfun(@plus,x,offset_vector);
save(strcat('subject','uft_x_offset.mat'), 'x_offset','c');

%For Filtered Signal
fs=1000;x=[];offset = 10;%offset of signal
amplitudereduction=80; %this can be modified depending on amplitude of signal
for i=1:20
x(i,:)=ft_data.trial{1, 1}(i,:)/amplitudereduction;
end
offset_vector = (offset:offset:20*offset)';
ftx_offset=zeros(20,size(x,2));
ftx_offset=bsxfun(@plus,x,offset_vector);
save(strcat('subject','ft_x_offset.mat'), 'x_offset','c');

d1_down=decimate(data1,30); %downsampling from 30kHz to 1kHz

%Plotting
figure()
for j=1:20
    plot(ftx_offset(j,:))
hold on;
end
hold on;
plot(d1_down);
set(gcf,'color','w');

%Adding Shading in 
rating_down=ratingstart/30;
rating_down_c=rating_down-c;
rating_down_c(1,1)=1;
%Conveyor Belt Movement
j=3;
u=4;
for i=1:38
startingtime=data_behavior1(i,1); %first conveyor belt movement (offset by the first two ratings)
x=startingtime;
y=0;
w=ratingstart(j,1)/30-c;
h=250;
X=[x;x;w;w];
Y=[0;210;210;0];
h = fill(X,Y,'r');
set(h,'facealpha',.1);
set(h,'EdgeColor','none');
j=j+2;
u=u+2;
end
%Holding Period
j=3;
u=4;
dp_down=dialpushedstart/30;
dp_c=dp_down-c;
for i=1:38
x2=ratingstart(j,1)/30-c;
w2=dp_c(1,j);
X2=[x2;x2;w2;w2];
Y=[0;210;210;0];
p = fill(X2,Y,'b');
set(p,'facealpha',.1)
set(p,'EdgeColor','none');
j=j+2;
u=u+2;
end
%Rating Period 1
j=3;
u=4;
for i=1:38
w3=ratingstart(u,1)/30-c;
x3=dp_c(1,j);
X3=[x3;x3;w3;w3];
Y=[0;210;210;0];
q = fill(X3,Y,'g');
set(q,'facealpha',.1)
set(q,'EdgeColor','none');
j=j+2;
u=u+2;
end
%Rating Period 2
j=4;
u=4;
for i=1:38
x2=ratingstart(j,1)/30-c;
w2=dp_c(1,j);
X2=[x2;x2;w2;w2];
Y=[0;210;210;0];
p = fill(X2,Y,'m');
set(p,'facealpha',.1)
set(p,'EdgeColor','none');
j=j+2;
u=u+2;
end

xlabel('Time (seconds)');
xticks([100000 200000 300000 400000 500000 600000 700000 800000 900000 1000000 1100000 1200000 1300000 1400000 1500000 1600000 1700000 1800000]);
xticklabels([100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800]);
yticks([0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200])
yticklabels({'conveyor1','AFz','C3','C4','CPz','Cz','F3','F4','F7','F8','FC1','FC2','FC5','FC6','Fp1','Fp2','FT9','FT10','Fz','T7','T8'});
legend('red=conveyor belt movement','blue=rating1 period', 'green=waiting period','purple=rating2 period');



%-----------Verification of individual tmepoints--------------------
%note: This can be added to previous shaded area as well. This part of the
%code creates vertical lines at the end of the timepoints
d1_down=decimate(data1,30); %downsampling from 30kHz to 1kHz
d4_down=decimate(data4,30);
d6_down=decimate(data6,30);
R=ratingstart/30;

%plotting rating start vertical lines on raw rotary encoder signal
figure()
plot(d1_down);
hold on;
plot(d4_down);
hold on;
plot(d6_down);
hold on;
for i=1:78
xline(R(i,1));
end
title('Downsampled data with rating start')
legend('d1','d4','d6','ratingstart')
hold off;

rating_down=ratingstart/30;
rating_down_c=rating_down;
rating_down_c(1,1)=1; %setting initial rating start to 1
dp_down=dialpushedstart/30;
dp_c=dp_down-cutoff;


figure()
plot(d1_down);
hold on;
plot(d4_down);
hold on;
plot(d6_down);
hold on;
for i=1:78
xline(dp_c(1,i));
end
title('Downsampled data with when the dial rating is pushed')
legend('d1','d4','d6','dialpushed')
hold off;


conveyorstart=movingend1'/30-movingtime-cutoff;
conveyorstart(13,1)=movingend1(1,13)/30-movingtimebig-cutoff;
conveyorstart(26,1)=movingend1(1,26)/30-movingtimebig-cutoff;
conveyorstart(39,1)=movingend1(1,39)/30-movingtimebig-cutoff;

figure()
plot(d1_down);
hold on;
plot(d4_down);
hold on;
plot(d6_down);
hold on;
for i=1:39
xline(conveyorstart(i,1),'r');
end
for i=1:78
xline(dp_down(1,i),'k');
end
title('downsampled data with Conveyor Start')
legend('d1','d4','d6','conveyorstart')
hold off;