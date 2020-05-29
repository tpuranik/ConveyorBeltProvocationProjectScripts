%This code formats the EEG and ECG data into one matrix
%Output: subjectEEG.mat and subjectECG.mat

%Make a folder to save figures if it doesn't already exist
% savedir='/Users/tanayapuranik/Documents/conveyorbeltdatafiles/';
% if ~exist(strcat(savedir,'figures/'))
%     mkdir(strcat(savedir,'figures/'))
% end
% figure_folder = strcat(savedir,'figures/');
% if ~exist(figure_folder)
%     mkdir(figure_folder)
% end
% close all;
% clear all;

subject='';
addpath("Fieldtrip package path")
addpath(genpath('open_ephys tools path'));

loaddir=strcat('conveyor_behavior and rotary encoder files folder');

%Load channel locations file
load('channel_locations.mat')

% Load data
fs = 30000;
fs_new = 1000;

%TestplottingEEG
figure()
j=2; %pick a channel to test
data1=load_open_ephys_data_faster(strcat(loaddir,'100_CH',num2str(j),'.continuous'));
plot(data1);

% % design low pass filter for stim artifact
lpf = designfilt('lowpassfir', 'PassbandFrequency', 100, 'StopbandFrequency', 130, 'PassbandRipple', 0.1, 'StopbandAttenuation', 60, 'SampleRate', fs_new);


EEG_channels = [1:10,23:32];
figure('units','normalized','outerposition',[0 0 1 1]);
for i = 1:20
    notch_true = 1;
    lpf_true = 1;
    Ch11=[];
    cutoff=1; %if removing part of signal because task had not started
    j = EEG_channels(i)
    Ch1 = load_open_ephys_data_faster(strcat(loaddir,'100_CH',num2str(j),'.continuous'));
    Ch11=Ch1;
    Ch1=Ch11(cutoff:size(Ch1,1),:);
    [Ch1, ts_new,fs_new] = Filter_downsample_notch(fs,fs_new,Ch1,notch_true,lpf_true,lpf);
    EEG{i} = Ch1;
    subplot(4,5,i)
    pspectrum(Ch1,fs_new,'FrequencyLimits',[0 200])
    title(strcat("EEG Channel ",num2str(i), ", ",c_locs(i).labels))
    hold on
end
% save the figure
% saveas(gcf, fullfile(strcat(figure_folder,'EEG_PSD.fig')));
% saveas(gcf, fullfile(strcat(figure_folder,'EEG_PSD.png')));

if length(EEG{i})/fs < 25
    figure('units','normalized','outerposition',[0 0 1 1]);
    for i = 1:20 
        Ch = EEG{i};
        subplot(4,5,i)
        pspectrum(Ch1,fs_new,'spectrogram','FrequencyLimits',[0 200],'TimeResolution',1)
        title(strcat("EEG Channel ",num2str(i), ", ",c_locs(i).labels))
    end
    % save the figure
%     saveas(gcf, fullfile(strcat(figure_folder,'EEG_spectrogram.fig')));
%     saveas(gcf, fullfile(strcat(figure_folder,'EEG_spectrogram.png')));
end
 
ECG_channels = [12,14,16];
for i = 1:3
    notch_true = 1;
    lpf_true = 1;
    j = ECG_channels(i);
    Ch1 = load_open_ephys_data_faster(strcat(loaddir,'100_CH',num2str(j),'.continuous'));
    [Ch1, ts_new,fs_new] = Filter_downsample_notch(fs,fs_new,Ch1,notch_true,lpf_true,lpf);
    ECG{i} = Ch1;
    figure;
    %can comment out
%     plot(ts_new,ECG{i})
%     plot(ts,Ch1((30*6312274):(30*6833900)))
%     title('ECG')
%     figure;
%     plot(ts,Ch1)
end

event_channels = [2:6];
for i = 1:5
    notch_true = 0;
    lpf_true = 0;
    j = event_channels(i);
    Ch1 = load_open_ephys_data_faster(strcat(loaddir,'100_ADC',num2str(j),'.continuous'));
    [Ch1, ts_new,fs_new] = Filter_downsample_notch(fs,fs_new,Ch1,notch_true,lpf_true,lpf);
    event{i} = Ch1;
    figure;
    plot(event{i})
    title('Event')
end


save('lowpassfilter','lpf')
save('subjectEEG.mat','EEG','EEG_channels','-v7.3');
save('subjectECG.mat','ECG','ECG_channels','-v7.3');