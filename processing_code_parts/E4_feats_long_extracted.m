function [data_struct] = E4_feats_long_extracted(x, ...
    eeg_t_left_arr, signal_type, epoch_data)

%%%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%%%%%%% 
addpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EEG-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Epoch information
epoch_end = epoch_data.Var10;           % End UTC timing
scenario_type = epoch_data.Var5;        % Scenario type = C / D / H
epoch_code    = epoch_data.Var7;        % Epoch codes 
epoch_name    = epoch_data.Var4;        % Epoch names

% Empty struct variable for all information
data_struct = struct();

% Empty struct variable ~ all tables into struct
all_feats_struct = struct();

% HR_signal based on epoch timings
N_1 = size(eeg_t_left_arr, 1);
N_3 = size(eeg_t_left_arr, 3);


for j = 1:size(eeg_t_left_arr, 3)
    
    % Timings of base epochs in each trial 
    t_trial = eeg_t_left_arr(:, 1, j);     
    
    % Empty table for feature
    all_fts_table = zeros(N_1, 1);
    
    for i = 1:size(eeg_t_left_arr, 1)

        t_base = t_trial(i,1);

        % Find positive values        
        A = (x(:,1) - t_base);
        % Find the minimum among positive values
        [~, minIndex] = min(abs(A));

        % feature table
        all_fts_table(i,1) = x(minIndex,2);
    end
      
    all_fts_table = array2table(all_fts_table, 'VariableNames', signal_type);
    
    
    
    % Same table names are overlapped and only one single case reamins. 
    tableName = ['case_', num2str(j)];                % epoch names  
    all_feats_struct.(tableName) = all_fts_table;     % feature tables    
    
    
    
end

data_struct.epoch_code = epoch_code;  
data_struct.scenario_type = scenario_type(1,1);
data_struct.epoch_name = epoch_name;  
data_struct.all_features = all_feats_struct;


%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
rmpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EEG-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

