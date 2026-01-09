function [outputArg1,outputArg2] = feature_extraction(data_eeg, data_eye,...
    data_e4, epoch_data, conditions, eye_file_name, eye_test_on)

%% Feature extraction condition
% Eye features
% - eye blinking noise 
% - minor noise removal
% - saccadic movement checking.

participants = {'pete', 'KS', 'HW', 'NH', 'SU', 'SY', 'New Subject'};
eye_file_code = find(contains(eye_file_name{1}, participants));

[epoch_data, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, blink_data_right]...
    = eye_features(data_eye, eye_file_code, eye_test_on, epoch_data);

epoch_dur = conditions.ep_dur;           % Duration for extracting features

epoch_end       = epoch_data.Var10;
epoch_code      = epoch_data.Var7;
epoch_scenario  = epoch_data.Var5(1,1);

%%

[epoch_data, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, blink_data_right]...
    = eye_features(data_eye, eye_file_code, eye_test_on, epoch_data);








%% eye-tracking features 
% 1) eye features 

[outputArg1,outputArg2] = E_feats_extracted(proc_new_eye, epoch_end,...
    epoch_dur, s_eye_right);








[epoch_data, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, ...
    blink_data_right];

% headers = eye_left.Properties.VariableNames(selected_columns);
% Selected data
% 1) column 12: 'final_pupil_area_smoothed'
% 2) column 13: 'final_pupil_area_smoothed'
% 3) column 14: 'final_pupil_area_smoothed'
% 4) column 15: 'final_pupil_area_smoothed'
% 5) column 16: 'final_pupil_area_smoothed'





%% fixation and saccade features
% Two categorizations: 1) during trials  / 2) during break 

for i = 1:size(processed_1st_header,2)
        
    % List all featured data in Right
    st_idx = epoch_data.right_index_start(i);
    en_idx = epoch_data.right_index_end(i);    
    
    
    
    
    
    
    
    
    
end







% sac_fts_data_: L and R
% Column 1: Average saccade duration in each trial
% Column 2: Average saccade angle in each trial 
% Column 3: Average fixation duration in each trial
% Column 4: Highest rate of pupil size change in each trial [pixel/time]
% Column 5: Highest STD of pupil size in each trial
% Column 6: Max. (mean velocity of gaze x & y)
% Column 7: Median.
% Column 8: Max. (max. velocity of gaze x & y)
% Column 9: Max. (std. of the velocity)
% Column 10: Mean (Acc.)
% Column 11: Mean (std. of Acc.)
% Column 12: Initial vel. (First sac. in each trial)
% Column 13: Initial acc. (First sac. in each trial)


% pre_sac_fts_data_: L_1, L_2, R_1, R_2
% Column 1: Number of fixation in pre-trial
% Column 2: Average fixation duration in pre-trial
% Column 3: Number of saccade in pre-trial
% Column 4: Average saccade duration in 
% Column 5: Average saccade angle in 
% Column 6: Median velocity of gaze x and y [pupil/time]
% Column 7: Mean velocity
% Column 8: std velocity
% Column 9: max velocity
% Column 10: median acc.
% Column 11: mean acc.
% Column 12: std. acc.
% Column 13: max. acc.
% Column 14: meadian filtered saccade angle
% Column 15: mean filtered saccade angle
% Column 16: std. saccade angle
% Column 17: max. saccade angle








% 2) 




% Epoch separation 먼저하기!
epoch_data;
% => find the closest value and its index.



















%%





% % Each trial epoch timing
% if ep_scenario == 0
%     
% %     % 1) End timing 
% %     t_before = conditions.time_sub;
% %     ep_dur = conditions.ep_dur;
% % 
% %     % ep_dt(:,4) = trial end timing
% %     epoch_data.Var10 = epoch_data.Var10 - t_before/1000;    % [s]
% %     epoch_data.Var9  = epoch_data.Var10 - ep_dur/1000;              % [s]
% 
% elseif ep_scenario == 1
%     

% end

%% Three Epoch Sets: epoch_data_0 / epoch_data_1 / epoch_data_2


%


%% Three Epoch Sets: epoch_data_0
[epoch_data_0, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, blink_data_right]...
    = eye_features(data_eye, eye_file_code, eye_test_on, epoch_data_0);



%% Feature extraction condition
[epoch_data_0, epoch_data_1, epoch_data_2] ...
    = epoch_index_check(epoch_data, eye_left, eye_right, ep_scenario, conditions);

    







%% Three Epoch Sets: epoch_data_1
[epoch_data, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, blink_data_right]...
    = eye_features(data_eye, eye_file_code, eye_test_on, epoch_data_1);

%% Three Epoch Sets: epoch_data_2
[epoch_data, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, blink_data_right]...
    = eye_features(data_eye, eye_file_code, eye_test_on, epoch_data_2);













% EEG features
% 1) EEG preprocessing
% - band filter
% - 
data_eeg;

[outputArg1,outputArg2] = eeg_features(data_eeg,ep_st,ep_en);












% * time stamps         = read_eye(:,2)
% * x-coordinate        = gaze_xy(:,5)
% * y-coordinate        = gaze_xy(:,6)
% * pupil size_left     = eye_left(:,7)
% * pupil size_right    = eye_right(:,7)
% * In addition, x and y velocity values may be included






% Pupil preprocessing: C:\Users\2hyow\Dropbox\processing_code\pupil_preprocessing
%  The minimum dataframe should include: time stamp, x-coordinate, y-coordinate and pupil size, _in that order_.





% E4 features
% - HR.csv
% - IBI.csv
% - BVP.csv  (Phoyoplethysmography: PPG)
% - EDA.csv  (electrodermal activity [microsiemens - μS])
data_e4;

data_e4.BVP
data_e4.EDA
data_e4.HR
data_e4.IBI
data_e4.Temp

[outputArg1,outputArg2] = e4_features(inputArg1,inputArg2);







end

%%