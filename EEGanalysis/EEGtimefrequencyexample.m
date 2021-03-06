
% Script Information: This code looks at the frequency analysis around
% various timepoints to see if there is any variation between different
% conditions of the task. It can be modified to look at a variety of
% timepoints and conditions. It produces both normalized and non-normalized
% time-frequency analysis. 

%to implement: need ft_data and uft_data from EEGpreprocess.m and
%conveyor_behavior from rotary encoder data (conveyorbelt1-conveyorbelt4.m)
subject='';
sub=strcat(subject,'OBJ 1 and OBJ 2','0 to 50 Hz');
addpath("path to fieldtrip")
load(strcat('/Users/tanayapuranik/Documents/conveyor_behavior/',subject,'/',subject,'_conveyor-provocation_behavior_updated.mat'));
load('path to filtered data: ft_data');
load('path to unfiltered data: uft_data');

%This example: start of conveyor belt movement period and start of holding
%period
%Provoking versus NonProvoking frequency analysis

%1. Loading behavioral information
originalsample=30000; %original sampling rate of dataset
fs=1000; %sampling rate
ds_factor=30;
movingtime=6500;
movingtimebig=movingtime*4;
cutoff=1; %if not visualizing beginning of some data

data_behavior=[];data_info=[];
data_behavior1=movingend1'/ds_factor-movingtime-cutoff;
data_behavior1(13,1)=movingend1(1,13)/ds_factor-movingtimebig-cutoff;
data_behavior1(26,1)=movingend1(1,26)/ds_factor-movingtimebig-cutoff;
data_behavior1(39,1)=movingend1(1,39)/ds_factor-movingtimebig-cutoff;

%defining data_behavior, which is the timepoints for investigation and
%data_info, which says whether the timepoint is associated with a provoking
%or non-provoking object in this case


data_behavior=data_behavior1;
datainfo(1:13,1)=0; %provoking
datainfo(27:39,1)=0; %provoking
datainfo(14:26,1)=1; %non-provoking

pre_stim_time = 1.5*fs;
post_stim_time = 1.5*fs;
figure()
for j=1:1:9
 cfg         = [];
cfg.output  = 'pow';%returning the power spectrum
cfg.method  = 'mtmfft'; %analyzes entire spectrum
cfg.taper   = 'hanning';
cfg.foi     = 0.5:50;%interested in 0.5 Hz to 50 Hz
cfg.channel = ft_data.label(j);
Ch1=ft_data.label(j);
pre_stim_time = 1.5*fs;
post_stim_time = 2*fs;
trialinfo=[];
trial_count = 0;
for i=1:1:(size(data_behavior,1))
    if ~isnan(data_behavior(i,1)) %theres no NaN
        trial_count = trial_count+1;
        center_time = floor(data_behavior(i, 1));
        cfg.trl(trial_count, :) = [center_time-pre_stim_time, center_time+post_stim_time, -pre_stim_time];
        trialinfo(trial_count,:) = data_info(i,1);
    end
end

ft_trial_data = ft_redefinetrial(cfg, ft_data);
ft_trial_data.trialinfo = trialinfo;
cfg.trials=find(ft_trial_data.trialinfo);
R = ft_freqanalysis(cfg, ft_trial_data);

cfg.trials   = find(ft_trial_data.trialinfo(:,1)==0);
StartMove_P_frequency = ft_freqanalysis(cfg, ft_trial_data);

cfg.trials   = find(ft_trial_data.trialinfo(:,1)==1);
StartMove_NP_frequency = ft_freqanalysis(cfg, ft_trial_data);

%Testing normalized values as well
P_mean=mean(StartMove_P_frequency.powspctrm);
P_std=std(StartMove_P_frequency.powspctrm);
P_normal=(StartMove_P_frequency.powspctrm-P_mean)/P_std;
P_max=max(StartMove_P_frequency.powspctrm);
P_min=min(StartMove_P_frequency.powspctrm);
P_z=(StartMove_P_frequency.powspctrm-P_min)/(P_max-P_min);
NP_mean=mean(StartMove_NP_frequency.powspctrm);
NP_std=std(StartMove_NP_frequency.powspctrm);
NP_normal=(StartMove_NP_frequency.powspctrm-NP_mean)/NP_std;
NP_max=max(StartMove_NP_frequency.powspctrm);
NP_min=min(StartMove_NP_frequency.powspctrm);
NP_z=(StartMove_NP_frequency.powspctrm-NP_min)/(NP_max-NP_min);


subplot(4,5,j)
plot((StartMove_P_frequency.freq), (P_z), 'linewidth', 1)
hold on;
plot((StartMove_NP_frequency.freq), (NP_z), 'linewidth', 1)
hold on;
title(strcat("EEG Channel ",num2str(j), ", ",ft_data.label(j,1)))
xticks([0 10 20 30 40 50])

xlabel('Frequency (Hz)')
ylabel('Power (\mu V^2)')

end

legend('Provoking Conveyor Belt Start', 'Nonprovoking Conveyor Belt Start')
sgtitle('Start of Conveyor Belt Movement');
saveas(gcf, strcat('EEG','Start of Conveyor Belt Movement',sub));
savefig(strcat('EEG','Start of Conveyor Belt Movement',sub));

