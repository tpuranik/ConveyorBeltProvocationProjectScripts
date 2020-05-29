%Plotting TFR based on events (have to use mtmconvol method

%To implement: 
%1. Update input variables depending on frequencies of interest
%2. choose event from task as timepoint to sample around (data_behavior)
%Input Variables
subject='';
method=''; %what is being tested
frequency='alpha2';
freqstart=12; %example, 12 Hz
freqend=15; %example, 15 Hz
addpath("pathway to Fieldtrip package")
load('pathway to conveyor_behavior');
load('pathway to ft_data from EEG preprocess');

fs=1000;
%%%-------1. Right Before Movement of Conveyor Belt------------------------ 
cfg         = [];
cfg.output  = 'pow';%returning the power spectrum
cfg.channel = 'all';
cfg.method  = 'mtmconvol'; %analyzes entire spectrum
cfg.taper   = 'hanning';
cfg.foi     = freqstart:freqend;
cfg.toi        = -1 : 0.10 : 12; %1 second before to 12 seconds after
cfg.t_ftimwin  = ones(size(cfg.foi)) * 0.5;

% %add trial information here depending on event to sample
data_behavior=[];data_info=[];
data_behavior=; %input data_behavior here

data_behavior=data_behavior1;
datainfo(1:13,1)=0; %provoking
datainfo(27:39,1)=0; %provoking
datainfo(14:26,1)=1; %non-provoking

% If only looking at rating 1 use this data_infos
% M=conveyor_behavior(:,3);
% M(M<=3)=2;
% M(M>=6)=7;
% data_info=M;

channel=1;
for i=1:2
Ch1(i)=ft_data.label(i);
end
for i=3:19
Ch1(i)=ft_data.label(i+1);
end

cfg.channel=Ch1;
pre_stim_time = 1.5*fs;
post_stim_time = 12*fs;
trialinfo=[];
trial_count = 0;
for i=1:1:(size(data_behavior,1))
    if ~isnan(data_behavior(i,1)) 
        trial_count = trial_count+1;
        center_time = floor(data_behavior(i, 1));
       cfg.trl(trial_count, :) = [center_time-pre_stim_time, center_time+post_stim_time, -pre_stim_time];
       trialinfo(trial_count,:) = data_info(i,1);
    end
end

ft_trial_data = ft_redefinetrial(cfg, ft_data);
ft_trial_data.trialinfo = trialinfo;
cfg.trials=find(ft_trial_data.trialinfo);
freq=ft_freqanalysis(cfg,ft_trial_data); %total data of provoking and nonprovoking

cfg.trials   = find(ft_trial_data.trialinfo(:,1)==0);
freq_P = ft_freqanalysis(cfg, ft_trial_data);

cfg.trials   = find(ft_trial_data.trialinfo(:,1)==1);
freq_NP = ft_freqanalysis(cfg, ft_trial_data);

[freq_B] = ft_freqbaseline(cfg, freq);

%Topoplot plotting
figure()
cfg = [];
%cfg.marker='on';
%cfg.channel=
%cfg.xlim = -0.2:0.1:1.5;
cfg.xlim = -1:6:12; %-1:1:12
cfg.layout = l2;
cfg.colorbar = 'yes';
cfg.marker  = 'on';
ft_topoplotER(cfg, freq_P)
title(strcat(subject,method))

figure()
cfg = [];
%cfg.marker='on';
%cfg.channel=
%cfg.xlim = -0.2:0.1:1.5;
cfg.xlim = -1:6:12;
cfg.layout = l2;
cfg.colorbar = 'yes';
ft_topoplotER(cfg, freq_NP)
title(strcat(subject,method, frequency,'high'));
saveas(gcf, strcat(subject,method));


%Plotting TFR
% Example: plotting only one channel
cfg=[];
cfg.channel='C4';
cfg.method='wavelet';
cfg.width=7;
cfg.output='pow';
cfg.foi = 0.5:50;%interested in 0.5 Hz to 50 Hz
cfg.toi        = -1 : 0.10 : 5; %-1 second to 5 seconds
freq_wavelet=ft_freqanalysis(cfg,ft_trial_data);

cfg = [];
cfg.channel='C4';
%cfg.baseline     = [-0.5 -0.1];
%cfg.baselinetype = 'absolute'; %can also choose relative
%cfg.zlim         = [-3e-25 3e-25];
cfg.showlabels   = 'yes';
cfg.layout       = 'l2';
figure
ft_singleplotTFR(cfg, freq_wavelet)
