function [all_fts_table] = E4_feats_extracted(fts_ind, x, signal_type)
% E4 feature extraction

%%%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%%%%%%% 
addpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EEG-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% avg_EDA
% med_EDA
% std_EDA
% kurtosis
% skewness
% hurst
% entropy
% peak_EDA
% peak_amplitude_EDA
% max_EDA_deflection

fts_all = [];

for i = 1:size(fts_ind,1)
    
    st = fts_ind(i,1);      en = fts_ind(i,2);
    
    % signal data
    x_epoch = x(st:en,2);
    

    rms_val = rms(x_epoch);                       % Calculate the RMS value
    power_sig = rms_val^2;                        % Calculate the power

    max_def = jfeeg('max_def', x_epoch);          % Maximum deflection
    f_ha = jfeeg('ha', x_epoch);                  % Hjorth activity
    f_hm = jfeeg('hm', x_epoch);                  % Hjorth mobility
    f_hc = jfeeg('hc', x_epoch);                  % Hjorth complexity
    f_me = jfeeg('me', x_epoch);                  % Mean energy
    f_sh = jfeeg('sh', x_epoch);                  % Shannon Entropy
    f_le = jfeeg('le', x_epoch);                  % Log Energy Entropy
    f_1d = jfeeg('n1d', x_epoch);                 % Normalized 1st difference
    f_2d = jfeeg('n2d', x_epoch);                 % Normalized 2nd difference

    % Collect all features in a list
    fts_list = [mean(x_epoch), median(x_epoch), std(x_epoch), max(x_epoch),...
        max_def, skewness(x_epoch), kurtosis(x_epoch), power_sig, f_ha, f_hm,...
        f_hc, f_me, f_sh, f_le, f_1d, f_2d];
    
    % All features in a list
    fts_all = [fts_all; fts_list];
    
end
    
% Feature headers
feature_names = {'mean', 'median', 'standard derivation', 'peak_amplitude', ...
    'Maximum Deflection', 'skewness', 'kurtosis', 'power signal', ...
    'Hjorth activity', 'Hjorth mobility', 'Hjorth complexity', ...
    'mean energy', 'Shannon entropy', 'Log energy entropy',...
    'Normalized 1st diff', 'Normalized 2nd diff'};

% e.g., sig_type = 'HR'
for i = 1:numel(feature_names)
    new_ft_name = strcat(signal_type, '_', feature_names{i});
    feature_names{i} = new_ft_name;
end

% Convert header cell array to a cell array of character vectors
feature_names = cellfun(@char, feature_names, 'UniformOutput', false);

all_fts_table = array2table(fts_all, 'VariableNames', feature_names);


%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
rmpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EEG-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

