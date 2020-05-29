%Preprocessing script: includes filtering, ICA, and initial visualization
%Script saves unprocessed EEG post filtering, processed EEG, and details from ICA
%in .mat format

%to implement:
%1. Add subject
%2. Add pathways specified 
%3. Establish an event in task for initial visualization of data
subject = '';
addpath("pathway to fieldtrip")
fs= 1000; %sample rate

%saving figures from preprocessing to folder of choice
savedir=strcat('/Users/tanayapuranik/Documents/conveyorbeltEEG/preprocess',subject);
if ~exist(strcat(savedir,'conveyorbelt_EEGpreprocess'))
    mkdir(strcat(savedir,'conveyorbelt_EEGpreprocess'))
end
figure_folder = strcat(savedir,'figures/');
if ~exist(figure_folder)
    mkdir(figure_folder)
end

% Load subject data
% the file is saved as subjectEEG.mat--> like subjectEEG.mat and subject
% ECG.mat
% File is cells with data from each electrode

% loading raw formatted EEG data downsampled to 1kHz
path = strcat("","EEG.mat"); %path to EEG.mat
files = dir(path);
files= string({files.name});
load((path));

% loading conveyor_behavior tables conveyorbelt processing
path2=strcat("path to conveyor_behavior");
load(path2);

% loading channel locations
load("channel_locations.mat") %This is a .mat file containing the spherical coordinates of data

% loading custom layout made for fieldtrip use for project
load("loading layout");

% 0.5Hz Highpass FIR Filter 
load('adding high pass filter');
% 40Hz Lowpass FIR Filter
load('adding low pass filter');

%%% Filter raw EEG
x=size(EEG,2);%number of electrodes
y=size(EEG{1},1); %size of EEG data for each electrode

filtered_EEG = zeros(x,y);
for i=1:x
	filtered_EEG(i,:) =filtfilt("high pass filter",filtfilt("low pass filter", EEG{i}));
end
save(strcat(subject,"-filtered.mat"), 'filtered_EEG');

%Saving unprocessed data (uft_data) and initializing ft_data for prcessing
ft_data=[];uft_data=[];
ft_data.trial{1} = filtered_EEG;
ft_data.time{1} = (1:length(EEG{1}))./fs;
ft_data.label = {c_locs.labels}';
uft_data.trial{1} = filtered_EEG;
uft_data.time{1} = (1:length(EEG{1}))./fs;
uft_data.label = {c_locs.labels}';
save(strcat(subject,"-uft_data.mat"), 'uft_data','subject');


% Apply ICA to remove oculur and muscular artifacts
cfg = [];
cfg.method = 'runica'; %method of choice
comp =ft_componentanalysis(cfg, ft_data);
save(strcat(subject,"-icacomp.mat"), 'comp');

%Just for visualizing components of data 
cfg = [];
cfg.layout = 'l2'; %custom layout
cfg.viewmode = 'component';
cfg.compscale     = 'local';
ft_databrowser(cfg, comp)

%ICA browser popout
cfg = [];
cfg.layout = 'l2'; %custom layout
[rej_comp] = ft_icabrowser(cfg,comp);

cfg = [];
cfg.component = 1:20;
cfg.component = cfg.component(rej_comp);
ft_data = ft_rejectcomponent(cfg, comp);
 save(strcat(subject,"-ica-rm-ftdata.mat"), 'ft_data','subject');

%end of preprocessing
%-------------------------------------------------------------------------
%Initial  Frequency analysis 
downsampledfactor=30; %30kHz to 1kHz


cfg = []; data_behavior=[];data_info=[];
%add data_behavior= and data_info here

%1.5 seconds before to 2 seconds after
pre_stim_time = 1.5*fs;
post_stim_time = 2*fs;
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

cfg = [];
cfg.trials = find(ft_trial_data.trialinfo(:,1)==1);
rating1_trials = ft_timelockanalysis(cfg, ft_trial_data);

cfg = [];
cfg.trials = find(ft_trial_data.trialinfo(:,1)==2);
rating2_trials = ft_timelockanalysis(cfg, ft_trial_data);

figure()
for i=1:20
cfg = [];
cfg.fontsize = 12;
cfg.channel=c_locs(i).labels
cfg.layout = 'l2';
cfg.baseline = [-0.2,0];
subplot(4,5,i)
ft_singleplotER(cfg, rating1_trials, rating2_trials);
xlabel('time')
ylabel('power spectrum')
end
sgtitle('5 seconds before rating');
legend('Rating1','Rating2')


figure()
cfg = [];
cfg.showlabels = 'yes';
cfg.fontsize = 6;
cfg.layout = 'l2';
cfg.xlim = -0.2:0.1:1.5; %timings
ft_multiplotER(cfg, rating1_trials);

