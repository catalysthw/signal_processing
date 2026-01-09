function [data_struct] = EEG_feats_gen(eeg_CAR, eeg_t_left_arr, epoch_data)

% Epoch information
scenario_type = epoch_data.Var5;        % Scenario type = C / D / H
epoch_code    = epoch_data.Var7;        % Epoch codes 
epoch_name    = epoch_data.Var4;        % Epoch names 

% Empty struct variable for all information
data_struct = struct();

% Empty struct variable ~ all tables into struct
all_feats_struct = struct();

% Five frequency bands: Delta, Theta, Alpha, Beta, Low
Fs = 500;           % Sampling frequency = 500 [Hz]

% Delta band (0.5-4 Hz)
[b, a] = butter(4, [0.5 4] / (Fs / 2), 'bandpass'); % 4th order Butterworth
deltaData = filtfilt(b, a, eeg_CAR); % Zero-phase filtering to avoid phase shift

% Theta band (8-13 Hz)
[b, a] = butter(4, [4 8] / (Fs / 2), 'bandpass'); % 4th order Butterworth
thetaData = filtfilt(b, a, eeg_CAR); % Zero-phase filtering to avoid phase shift

% Alpha band (8-13 Hz)
[b, a] = butter(4, [8 13] / (Fs / 2), 'bandpass'); % 4th order Butterworth
alphaData = filtfilt(b, a, eeg_CAR); % Zero-phase filtering to avoid phase shift

% Beta band (13-30 Hz)
[b, a] = butter(4, [13 30] / (Fs / 2), 'bandpass'); % 4th order Butterworth
betaData = filtfilt(b, a, eeg_CAR); % Zero-phase filtering to avoid phase shift

% Low band (0.5-10 Hz)
[b, a] = butter(4, [0.5 10] / (Fs / 2), 'bandpass'); % 4th order Butterworth
lowData = filtfilt(b, a, eeg_CAR); % Zero-phase filtering to avoid phase shift




for j = 1:size(eeg_t_left_arr,3)
    trial_ = eeg_t_left_arr(:, 4:5, j);     % start/end epochs in each trial 
    
    
    for i = 1:size(eeg_t_left_arr,1)
        
        % start/end indexes
        st = trial_(i,1);       en = trial_(i,2);
        
%         % data in specific region
%         x_data = eeg_CAR(st:en,:);
        
        % EEG feature extraction
        [p_delta, p_theta, p_alpha, p_beta, p_low, ratio_feats] ...
        = EEG_feats_inside(st, en, eeg_CAR, deltaData, thetaData, alphaData, ...
        betaData, lowData, Fs);
        
        % all features in a table
        feats_table = horzcat(p_delta, p_theta, p_alpha, p_beta, p_low, ratio_feats);
        
        if i == 1
            all_feats_table = feats_table;
        else
            all_feats_table = vertcat(all_feats_table, feats_table);        
        end
    end
    
    % Same table names are overlapped and only one single case reamins. 
    tableName = ['case_', num2str(j)];                % epoch names  
    all_feats_struct.(tableName) = all_feats_table;     % feature tables
end

data_struct.epoch_code = epoch_code;  
data_struct.scenario_type = scenario_type(1,1);
data_struct.epoch_name = epoch_name;  
data_struct.all_features = all_feats_struct;

% % How to read features of each epoch 
% ep_list = data_struct.epoch_name;
% for i = 1:size(ep_list,1)
%     ep_name = ep_list{i}; 
%     fts_each_epoch = data_struct.all_features.(ep_name);
% end

end

