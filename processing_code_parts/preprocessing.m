
%% Preprocessing

% EDA
% https://www.researchgate.net/publication/338620058_Innovations_in_Electrodermal_Activity_Data_Collection_and_Signal_Processing_A_Systematic_Review
% https://github.com/HealthSciTech/pyEDA
%https://www.researchgate.net/publication/351671723_pyEDA_An_Open-Source_Python_Toolkit_for_Pre-processing_and_Feature_Extraction_of_Electrodermal_Activity


% HR: Heart Rate (What is differences between HR and IBI??)

% BVP: raw Blood Volume Pulse

% IBI: Inter-Beat-Interval signal (the temporal spaces between heartbeats)

% ACC: Accelerometer (How this signal can be used in human phyisological responses?)

% EEG: among 32 channels


%% Read all sheet names in each excel file

% testing eye filtering: 1 = test & figure / 0 = no test & no figures
eye_test_on = 0;

% Define the source folder and its name
folderPath = 'F:\';  % Path to the folder containing the specific folder

participant = {'092923_KS_data', '092923_Pete_data', '100223_HW_data', '100323_NH_data', ...
    '100323_SU_data', '100423_SY_data', '100723_CH_data'};

file_names = {'KS_trial_info.xlsx', 'Pt_trial_info.xlsx', 'HW_trial_info.xlsx',...
    'NH_trial_info.xlsx', 'SU_trial_info.xlsx', 'SY_trial_info.xlsx', 'CH_trial_info.xlsx'};

% Dataset list
timing_file_name = 'timing_dataset_file.xlsx';
excel_file = strcat('F:\0.exp_processed_data\', timing_file_name);
data_file = readtable(excel_file, 'Sheet','Sheet1');           % Read the specified sheet

% Lists of file names for EEG, E4, Eye
eeg_list    = data_file.EEG_file;
eye_list    = data_file.Eye_file;
e4_list     = data_file.E4_file;

% Strings to be removed in the list
remove_str = ["line", "preference", "CARLA", "NaN"];
% baseline_str = ["line"];        pref_str = ["preference"];
% carla_str = ["CARLA"];          non_str = [""];

% Find indices of elements containing the specific string
indices = find(~contains(eeg_list, remove_str));

%% Fixing EEG features

% process_filePath = 'F:\0.exp_processed_data\processed_mat_file\';
% 
% for i = 1:18
%     
%     % if exist eeg file? 
%     eegFile_t = data_file.eeg_st(ind,1);
%     
%     if eegFile_t == 0 
%         eeg_exist = 0;
%     else
%         eeg_exist = 1;
%     end
%     
%     % Input: e.g.,'pete_S1' for each 'i' index 
%     ind = indices(i,1);
%     data_file_case_N = ind;
%     sheet_name = data_file.trial_sheet_name(ind,1);   % use this file name for saving processed data.
%     
%     all_process_fileName = sheet_name;
%     dt_all_processed = strcat(process_filePath, all_process_fileName{1}, '.mat');
% 
%     load(dt_all_processed)
%     
%     
% % just updaing EEG feature (for each channel due to the code was not
% % changed. 1 => i 
% % Before: [EEG_col_right] = EEG_feats_gen(eeg_CAR_right(:,1)....
% % After : [EEG_col_right] = EEG_feats_gen(eeg_CAR_right(:,i),
% 
%     if eeg_exist == 1 
%         % EEG channels (
%         % Cz, Pz, Fz, C4, C3, CP1, CP2, FC1, FC2] + Fp1, Fp2, P3, P4, CP5, CP6, FC5, FC6, PO3, PO4
%         % [3,  4, 14, 11, 15,  26,  27,  29,  23] +  17,  13,  5,  2,  28,  25,  30,  22,  32,  21 
% 
%         % Cz, Pz, Fz, C4, C3, CP1, CP2, FC1, FC2]
%         primary_channels = [3,  4, 14, 11, 15,  26,  27,  29,  23];
%         % data_eeg 
%         eeg_data = table2array(data_eeg(:, primary_channels));
% 
%         %%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%%%%%% 
%         addpath('F:\0.exp_processed_data\filtering_signals')
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         [eeg_CAR] = CAR_filter(eeg_data);       % Common Average Reference
% 
%         % fix_left / fix_right / sac_left / sac_right
%         [eeg_CAR_left, new_fix_left] = CAR_filter_eye_rev(eeg_data, eeg_blink_left, eeg_sac_left);
%         [eeg_CAR_right, new_fix_right] = CAR_filter_eye_rev(eeg_data, eeg_blink_right, eeg_sac_right);
%         % Revised ICA
%         % Skip this method.
%         %%%%%%%%%%%%%%%%% Remove feature extraction function path %%%%%%%%%%%%%%%%% 
%         rmpath('F:\0.exp_processed_data\filtering_signals')
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     
%     %% EEG feature extraction
% 
%         % % Epoch information
%         % scenario_type = epoch_data.Var5;        % Scenario type = C / D / H
%         % epoch_code    = epoch_data.Var7;        % Epoch codes 
%         % epoch_name    = epoch_data.Var4;        % Epoch names 
%         %                    Cz, Pz, Fz, C4, C3, CP1, CP2, FC1, FC2]
%         primary_channels = [   3,  4,   14, 11,   15,   26,  27,    29,   23];    
%         primary_ch_names = {'Cz','Pz','Fz','C4','C3','CP1','CP2','FC1','FC2'};
% 
%         % EEG feature - based on left / right eye
%         EEG_struct_left  = struct();
%         EEG_struct_right = struct();
% 
%         N_chs = size(primary_channels,2);
%         for aa = 1:N_chs
%             specific_ch = primary_ch_names{aa};     % Channel name
% 
%             [EEG_col_left]  = EEG_feats_gen(eeg_CAR_left(:,aa), eeg_t_left_arr, epoch_data);
%             [EEG_col_right] = EEG_feats_gen(eeg_CAR_right(:,aa), eeg_t_right_arr, epoch_data);
% 
%             var_name_left  = strcat('EEG_',  specific_ch);
%             var_name_right = strcat('EEG_', specific_ch);
% 
%             EEG_struct_left.(var_name_left)   = EEG_col_left;
%             EEG_struct_right.(var_name_right) = EEG_col_right;
% 
%         end
% 
%         EEG_struct_left.EEG_channels   = primary_ch_names;
%         EEG_struct_right.EEG_channels = primary_ch_names;   
%     end
%     
%     save(dt_all_processed)
% end



%% Iteration for feature extraction of all cases in data_file

for i = 13:numel(indices)
    %%
    % Input: e.g.,'pete_S1' for each 'i' index 
    ind = indices(i,1);
    data_file_case_N = ind;
    sheet_name = data_file.trial_sheet_name(ind,1);   % use this file name for saving processed data.
    
    eeg_file = strcat(data_file.folderPath{ind}, '\EEG\', eeg_list{ind}, '.xlsx');
    eye_file = strcat(data_file.folderPath{ind}, '\eye_tracking\', eye_list{ind});
    e4_file  = strcat('F:\1.E4_dataset\0.Mat_File\', e4_list{ind}, '.mat');
    
    data_eeg = readtable(eeg_file, 'Sheet','Sheet1');   % Read EEG
    data_eye = readtable(eye_file);                     % Read Eye
    data_eye.UTC = data_eye.UTC/1000;                   % Time / 1000
    data_e4  = load(e4_file);                           % Read E4
    
    % if exist eeg file? 
    eegFile_t = data_file.eeg_st(ind,1);
    
    if eegFile_t == 0 
        eeg_exist = 0;
    else
        eeg_exist = 1;
    end
    
    % Epoch_file
    epoch_file = strcat(data_file.folderPath{ind}, '\', data_file.epoch_file{ind});
    
    % Detect import options for the specific sheet
    opts = detectImportOptions(epoch_file, 'Sheet', data_file.trial_sheet_name{ind});
    opts.DataRange = 'A2'; % Start reading data from row 2
    
    % Setting the data type by column name
    opts = setvartype(opts, 'Var5', 'double'); % Change 'ColumnName' to your actual column name
    opts = setvartype(opts, 'Var7', 'double'); % Change 'ColumnName' to your actual column name

    epoch_data = readtable(epoch_file, opts);       % Read the specified sheet
    % Col 4: cases / Col 5: Scenario # / Col 7: Epoch codes / Col 9: start time / Col 10: end time
    epoch_data = epoch_data(:,[4,5,7,9,10]);
    
    % Add epoch codes in column 7
    [epoch_data] = classify_epoch_code(epoch_data);
    epoch_data.Var9 = epoch_data.Var9/1000;
    epoch_data.Var10 = epoch_data.Var10/1000;
    
    % Feature conditions    
    time_sub = 0;           % xxx [ms] subtract from the trial end [ms]
    data_dur = 6;           % [s] 6 seconds - epoch duration: from the end timing of each trial
    fts_dur = 0.3;          % [s] = 300 ms
    fts_step = 0.1;         % [s] = time step for feature extraction 
    epoch_end       = epoch_data.Var10;

    fts_cond = table();
    fts_cond.data_dur = data_dur;
    fts_cond.fts_dur  = fts_dur;
    fts_cond.fts_step = fts_step;
    
    % Epoch information
    scenario_type = epoch_data.Var5;        % Scenario type = C / D / H
    epoch_code    = epoch_data.Var7;        % Epoch codes 
    epoch_name    = epoch_data.Var4;        % Epoch names
    
    % Preprocessing function: 'eye_features'
    participants = {'pete', 'KS', 'HW', 'NH', 'SU', 'SY', 'New Subject'};
    eye_file_name = data_file.Eye_file(ind,1);
    eye_file_code = find(contains(eye_file_name{1}, participants));
    
    % Process eye data for left/right eye, fixation, saccade, blinks. 
    [epoch_data, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, blink_data_right]...
    = eye_features(data_eye, eye_file_code, eye_test_on, epoch_data, fts_cond);
    
    if eeg_exist == 1 
       % Process left/right eye fixation, saccade, blink on eeg timestamp
        [eeg_fix_left, eeg_fix_right, eeg_sac_left, eeg_sac_right, ...
        eeg_blink_left, eeg_blink_right] = eeg_features(data_eeg, fix_left,...
        fix_right, sac_left, sac_right, blink_data_left, blink_data_right);        
    end
 
    % Eye Timestamp for feature extraction during 6 seconds
    [eye_t_left_arr, eye_t_right_arr] = feats_timestamp(data_dur,...
        proc_new_eye, s_eye_right, epoch_end, fts_step, fts_dur);
    
    if eeg_exist == 1 
        % EEG Timestamp for feature extraction during 6 seconds
        [eeg_t_left_arr, eeg_t_right_arr] = feats_timestamp(data_dur,...
            data_eeg.Var37, data_eeg.Var37, epoch_end, fts_step, fts_dur);    
    end
    
    
    %% Feature extraction: for loop of each epoch
    % - Each epoch has 6 seconds long of feature extraction epoch 
    % In the 6 seconds, 0.1 step and 0.15 
    
    % Function: Eye feature extraction - internal function 'E_feats_gen'
    
%     % Output: 28 features
%     e_Nfeats = 28;          % Number of eye-tracking features
%     n_fts = size(new_t_arr,1);          % The number of features in each epoch (6 seconds long)
%     n_max_epoch = size(new_t_arr,3);    % The number of epochs
%     n_data = size(processed_1st_header,2);
%     feats_1st_set = zeros(n_fts, e_Nfeats, n_data, n_max_epoch);

    %% EYE feature extraction
    [feats_1st_set, feats_2nd_set, feats_3rd_set, feats_4th_set_left, ...
        processed_1st_header, processed_2nd_header, processed_3rd_header, ...
        processed_4th_header] = E_feats_gen(proc_new_eye, s_eye_left, eye_t_left_arr);
    [~, ~, ~, feats_4th_set_right, ~, ~, ~, ~] ...
        = E_feats_gen(proc_new_eye, s_eye_right, eye_t_right_arr);    
    
    [data_struct_1st] = eye_struct_data(feats_1st_set, processed_1st_header, epoch_data);
    [data_struct_2nd] = eye_struct_data(feats_2nd_set, processed_2nd_header, epoch_data);
    [data_struct_3rd] = eye_struct_data(feats_3rd_set, processed_3rd_header, epoch_data);
    [data_struct_4th_left]  = eye_struct_data(feats_4th_set_left, processed_4th_header, epoch_data);
    [data_struct_4th_right] = eye_struct_data(feats_4th_set_right, processed_4th_header, epoch_data);    
    
    %% EEG preprocessing 
    
    if eeg_exist == 1 
        % EEG channels (
        % Cz, Pz, Fz, C4, C3, CP1, CP2, FC1, FC2] + Fp1, Fp2, P3, P4, CP5, CP6, FC5, FC6, PO3, PO4
        % [3,  4, 14, 11, 15,  26,  27,  29,  23] +  17,  13,  5,  2,  28,  25,  30,  22,  32,  21 

        % Cz, Pz, Fz, C4, C3, CP1, CP2, FC1, FC2]
        primary_channels = [3,  4, 14, 11, 15,  26,  27,  29,  23];
        % data_eeg 
        eeg_data = table2array(data_eeg(:, primary_channels));

        %%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%%%%%% 
        addpath('F:\0.exp_processed_data\filtering_signals')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [eeg_CAR] = CAR_filter(eeg_data);       % Common Average Reference

        % fix_left / fix_right / sac_left / sac_right
        [eeg_CAR_left, new_fix_left] = CAR_filter_eye_rev(eeg_data, eeg_blink_left, eeg_sac_left);
        [eeg_CAR_right, new_fix_right] = CAR_filter_eye_rev(eeg_data, eeg_blink_right, eeg_sac_right);
        % Revised ICA
        % Skip this method.
        %%%%%%%%%%%%%%%%% Remove feature extraction function path %%%%%%%%%%%%%%%%% 
        rmpath('F:\0.exp_processed_data\filtering_signals')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

    
% 'C:\Users\2hyow\Dropbox\processing_code'
% 'C:\Users\2hyow\Dropbox\processing_code\111622_processing'
% 'C:\Users\2hyow\Dropbox\processing_code\feature_extraction'
% 'E:\1. data collected\pre_processing\functions\D-LAB data preprocessing'

    % Step 1) Re-reference
    % Step 2) CAR / Revised CAR / ICA / Revised ICA
    % Completed above
    
    %% EEG feature extraction
    % PSD / Ratio of power in specific band relative to the total power /
    % Entropy - Shannon entorpy / Cross_frequency Coupling / Amplitude of EEG fluctuations / 
    % Average amplitude / Hjorth Parameters / Spatial features (Topographical maps)
    % Channel correlations / Wavelet transform / Event-related Desynchro & Synchro
    % Statistical features (Mean, Variance, Skewness) / Kurtosis / 
    % Connectivity features (Coherence, Phase locking value) / 
    
        % % Epoch information
        % scenario_type = epoch_data.Var5;        % Scenario type = C / D / H
        % epoch_code    = epoch_data.Var7;        % Epoch codes 
        % epoch_name    = epoch_data.Var4;        % Epoch names 
        %                    Cz, Pz, Fz, C4, C3, CP1, CP2, FC1, FC2]
        primary_channels = [   3,  4,   14, 11,   15,   26,  27,    29,   23];    
        primary_ch_names = {'Cz','Pz','Fz','C4','C3','CP1','CP2','FC1','FC2'};

        % EEG feature - based on left / right eye
        EEG_struct_left  = struct();
        EEG_struct_right = struct();

        N_chs = size(primary_channels,2);
        for aa = 1:N_chs
            specific_ch = primary_ch_names{aa};     % Channel name

            [EEG_col_left]  = EEG_feats_gen(eeg_CAR_left(:,aa), eeg_t_left_arr, epoch_data);
            [EEG_col_right] = EEG_feats_gen(eeg_CAR_right(:,aa), eeg_t_right_arr, epoch_data);

            var_name_left  = strcat('EEG_',  specific_ch);
            var_name_right = strcat('EEG_', specific_ch);

            EEG_struct_left.(var_name_left)   = EEG_col_left;
            EEG_struct_right.(var_name_right) = EEG_col_right;

        end

        EEG_struct_left.EEG_channels   = primary_ch_names;
        EEG_struct_right.EEG_channels = primary_ch_names;   
    end
    
    %% E4 feature extraction   
%     % PPG => Chebyshev II order 4 filter (stopband attenuation of 20 dB and
%     % a passband of 0.5-5Hz)
%     ppgSignal = data_e4.BVP;        % Column 1: timestamp
%     [PPG_sig] = cheby2_order4_filter(ppgSignal(:,2));
%     PPG_sig = [ppgSignal(:,1), f_PPG];
%     
%     EDA_sig = data_e4.EDA;      % Column 1: timestamp   
%     HR_sig = data_e4.HR;        % Column 1: timestamp
%     Temp_sig = data_e4.Temp;    % Column 1: timestamp 
%     IBI_sig = data_e4.IBI;
    
    fs_list = table();
    % Sampling frequencies for physiological signals
    fs_list.fs_BVP  = 64;       fs_list.fs_EDA  = 4;                
    fs_list.fs_HR   = 1;        fs_list.fs_Temp = 4;
    
    % E4 feature generation
    [E4_fatigue_left, E4_severity_left]   = E4_feats_gen(data_e4, ...
        eeg_t_left_arr, epoch_data, fs_list);
    [E4_fatigue_right, E4_severity_right] = E4_feats_gen(data_e4, ...
        eeg_t_right_arr, epoch_data, fs_list);
    
%     % Collect fatigue feature tables into a single struct
%     E4_fatigue_struct.HR   = HR_fts_table;
%     E4_fatigue_struct.EDA  = EDA_fts_table;
%     E4_fatigue_struct.TEMP = TEMP_fts_table;
%     E4_fatigue_struct.HRV  = HRV_fts_table;
% 
%     % Collect severity feature tables into a single struct
%     E4_feats_struct.HR   = HR_fts_struct;
%     E4_feats_struct.EDA  = EDA_fts_struct;
%     E4_feats_struct.TEMP = TEMP_fts_struct;
%     E4_feats_struct.HRV  = HRV_fts_struct;

    
    %% Saving data
    process_filePath = 'F:\0.exp_processed_data\processed_mat_file\';
    all_process_fileName = sheet_name;
    dt_all_processed = strcat(process_filePath, all_process_fileName{1}, '.mat');
    
    save(dt_all_processed);
    
%     % Eye features
%     data_struct_1st
%     data_struct_2nd
%     data_struct_3rd
%     data_struct_4th_left
%     data_struct_4th_rgiht
%     
%     % EEG feature - based on left / right eye
%     EEG_struct_left
%     EEG_struct_right
%     
%     % E4 features
%     E4_fatigue_left, E4_severity_left
%     E4_fatigue_right, E4_severity_right
%
end

%%
% % % Remove single quotes from each string in the cell array
% % cleanedArray = cellfun(@(x) strrep(x, '''', ''), eye_list, 'UniformOutput', false);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for j = 1:numel(participant)
% j = 1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % for k = 1:numel(filtered_N)
% % filtered_N(k)
% k = 2;
% 
% sheet_data = readtable(excel_file{1,1}, 'Sheet', sheet_names(k));        % Read the specified sheet
% sheet_data = sheet_data(:,[4,5,9,10]);
% 
% scenario_type = sheet_data(1,2);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KS_set = {["KS_2_2", "KS_2_3", "KS_2_4", "KS_2_5"], ...
%     ["KS_2_6", "KS_2_7", "KS_2_8", "KS_2_9"],...
%     ["KS_2_10", "KS_2_11", "KS_2_12", "KS_2_13"]};
% 
% % PT_3 = h
% PT_set = {["PT_2", "PT_3", "PT_5", "PT_6"], ...
%     ["PT_8", "PT_9", "PT_10", "PT_11"],...
%     ["PT_8", "PT_9", "PT_10", "PT_12"]};
% 
% HW_set = {["HW_1", "HW_2", "HW_3"], ["HW_4", "HW_12", "HW_6"],...
%     ["HW_7", "HW_8", "HW_10"], ["HW_11", "HW_12", "HW_13"],...
%     ["HW_5", "HW_9", "HW_14"]};
% 
% % C / D / H
% NH_set = {["NH_1"], ["NH_2"]};      NH_ord = {[24,51,81], [25,49,79]};
% 
% % [SU_1] = C / D / H            [SU_2] = C / D / H 
% SU_set = {["SU_1"], ["SU_2"]};      NH_ord = {[25,49,79], [20,51,81]};
% 
% % [SY_1]= C/D/H    % [SY_2]= H/D/C    % [SY_3]= D/H/C   % [SY_4]= C/D/H 
% SU_set = {["SY_1"], ["SY_2"], ["SY_3"], ["SY_4"]};      
% SU_ord = {[24,48,78], [25,47,70], [25,49,73], [25,49,79]};
% 
% % [CH_2_4] = D/H   % [CH_2_7] = D/C/H/D/D/H
% CH_set = {["CH_2_2", "CH_2_3", "CH_2_5"], ["CH_2_4","CH_2_5"], ["CH_2_7"]};
% CH_ord = {[0], [25, 55], [25, 49, 79, 106, 130, 163]};



%%


%%

