function [eeg_CAR] = CAR_filter(eeg_data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

n_channels = size(eeg_data,2);
avg_eeg = mean(eeg_data,2);

for i = 1:n_channels
    eeg_CAR(:,i) = eeg_data(:,i) - avg_eeg;
end


end

