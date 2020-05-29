%This script performs the morlet wavelet analysis using Fieldtrip function.

addpath("path to fieldtrip package")

subject='';
folder='';
filename='filtered data file name';
load('folder')
BandsTxt = {'1_4';'4_8';'8_15';'15_30';'30_55'};
%frequency bands of interest and the interval of sampling
freqinc_all = [1:0.5:4,4:0.5:8,8:0.5:15,15:1:30,30:1:55]; 
fs = 1000;
numElectrodes=20;

band_temp = freqinc_all;
spectrum_band_mean_all_elec = zeros(numElectrodes,size(ft_data.trial{1},2));
for e=1:numElectrodes
    % for loop builds a cell array of continuous power values for each
    % frequency
    spectrum_band_temp = zeros(1,size(ft_data.trial{1},2));
    for g = 1:size(freqinc_all,2)
        freqoi = freqinc_all(g);
        single_channel = ft_data.trial{1}(e,:);
        [spectrumtemp,freqoi,timeoi] =ft_specest_wavelet(single_channel,...
            (1:size(single_channel,2))/fs,'freqoi',freqoi,'gwidth',7,'width',3);
        spectrum_band_temp(g,:) = spectrumtemp.^2;
    end
    spectrum_band_mean_all_elec(e,:) = mean(spectrum_band_temp,1);
    freqanalysis_allelec = {spectrum_band_temp};
    save(strcat(subject,'_', num2str(e),'_','elec.mat'),'freqanalysis_allelec','-v7.3');

end
save(strcat(subject,'_full_spec_analysis'),'spectrum_band_temp','spectrum_band_mean_all_elec');
