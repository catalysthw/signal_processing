function [epoch_data, epoch_data_check, s_eye_left, s_eye_right, proc_new_eye,...
    fix_left, fix_right, sac_left, sac_right, blink_data_left, blink_data_right]...
    = eye_features(data_eye, eye_file_code, eye_test_on, epoch_data, fts_cond)

% Output 1: epoch_data, epoch_data_check
% Output 2: s_eye_left, s_eye_right, proc_new_eye
% Output 3: blink_data_left, sac_left, blink_data_right, sac_right

nan_ind_1 = ~isnan(table2array(data_eye(:,5)));
eye_left = data_eye(nan_ind_1, [1:2, 5:14]);

nan_ind_2 = ~isnan(table2array(data_eye(:,15)));
eye_right = data_eye(nan_ind_2,[1:2, 15:24]);

% Main gaze_xy = "Left side data" gaze_xy_left
gaze_xy_left = data_eye(nan_ind_1,[1:4, 25:26]);
gaze_xy_right = data_eye(nan_ind_2,[1:4, 25:26]);

%%%%%%%%%%%%%%%%%%%% Saccadic movement data - Left %%%%%%%%%%%%%%%%%%%%%%%%
% Saccadic binary code (0 or 1)
binaryArray = eye_left(:,10);
binaryArray{ismissing(binaryArray), :} = 0;         % Replace NaN values with 0
binaryArray = table2array(binaryArray);

% Find indices of the first '1' in each sequence
diffArray = diff([0; binaryArray]) == 1;
startIndex = find(diffArray);
if startIndex(1,1) == 1
    startIndex(1,1) = 2;
end

% Find indices of the last '1' in each sequence
diffArray = diff([binaryArray; 0]) == -1;
endIndex = find(diffArray);

% Saccadic data - Left
len = size(startIndex,1);           sac_left = zeros(len, 5);
sac_left(:,1) = startIndex;         sac_left(:,2) = endIndex;
sac_left(:,3) = table2array(eye_left(startIndex,2));
sac_left(:,3) = table2array(eye_left(startIndex-1,2));
sac_left(:,4) = table2array(eye_left(endIndex,2));
sac_left(:,5) = sac_left(:,4) - sac_left(:,3);

%%%%%%%%%%%%%%%%%%%% Saccadic movement data - Right %%%%%%%%%%%%%%%%%%%%%%%%
% Saccadic binary code (0 or 1)
binaryArray = eye_right(:,10);
binaryArray{ismissing(binaryArray), :} = 0;         % Replace NaN values with 0
binaryArray = table2array(binaryArray);

% Find indices of the first '1' in each sequence
diffArray = diff([0; binaryArray]) == 1;
startIndex = find(diffArray);

% Find indices of the last '1' in each sequence
diffArray = diff([binaryArray; 0]) == -1;
endIndex = find(diffArray);

% Saccadic data - Left
len = size(startIndex,1);           sac_right = zeros(len, 5);
sac_right(:,1) = startIndex;         sac_right(:,2) = endIndex;
sac_right(:,3) = table2array(eye_left(startIndex-1,2));
sac_right(:,4) = table2array(eye_left(endIndex,2));
sac_right(:,5) = sac_right(:,4) - sac_right(:,3);


%% New approach to process eye-tracking data
new_eye_left = [gaze_xy_left(:, [2,5:6]), eye_left(:,5)];
new_eye_left = table2array(new_eye_left);

[proc_new_eye] = new_eye_preprocessing(new_eye_left, eye_file_code);

%% Blink detection and fixing blink_data
[blink_data_left, blink_data_right]...
    = blink_processing(eye_left, eye_right);

%% Fixing blinking data (replace NaN of the end blink to 100ms blink) 
% (Left eye) Fixing blinks: Blink end ~ NaN (make the NaN blink to 100ms blink)
blink_nan = find(isnan(blink_data_left(:,2)));
if ~isempty(blink_nan)
    blink_data_left(blink_nan,4) = blink_data_left(blink_nan,3) + 6;

    % duration for nan blink
    idx_nan_st = blink_data_left(blink_nan,3);
    idx_nan_en = blink_data_left(blink_nan,4);
    dur_nan = eye_left.UTC(idx_nan_en,1) - eye_left.UTC(idx_nan_st,1);
    blink_data_left(blink_nan, 2) = dur_nan ;
end

% (Right eye) Fixing blinks: Blink end ~ NaN (make the NaN blink to 100ms blink)
blink_nan = find(isnan(blink_data_right(:,2)));
if ~isempty(blink_nan)
    blink_data_right(blink_nan,4) = blink_data_right(blink_nan,3) + 6;

    % duration for nan blink
    idx_nan_st = blink_data_right(blink_nan,3);
    idx_nan_en = blink_data_right(blink_nan,4);
    dur_nan = eye_right.UTC(idx_nan_en,1) - eye_right.UTC(idx_nan_st,1);
    blink_data_right(blink_nan, 2) = dur_nan ;
end

%% Fixing blinking data (checking overlapped blinkings) 
skip_n = 0;

for i = 1:size(blink_data_left,1)-1
    
    if skip_n + i < size(blink_data_left,1)-1
        st_pre = blink_data_left(i,3);
        en_pre = blink_data_left(i,4);

        st_adv = blink_data_left(i+1,3);
        en_adv = blink_data_left(i+1,4);

        % check whether 
        value = st_adv;     lower_bound = st_pre;       upper_bound = en_pre;
        is_between_1 = is_value_between(value, lower_bound, upper_bound);

        value = en_adv;     lower_bound = st_pre;       upper_bound = en_pre;
        is_between_2 = is_value_between(value, lower_bound, upper_bound);

        if is_between_1  == 1 && is_between_2 == 1
            blink_data_left(i+1,:) = [];

            % count the number of skipped blinks ('i')
            skip_n = skip_n + 1;

        elseif is_between_1  == 1 && is_between_2 == 0
            blink_data_left(i,4) = blink_data_left(i+1,4);
            blink_data_left(i+1,:) = [];

            % count the number of skipped blinks ('i')
            skip_n = skip_n + 1;

            % Duration update
            idx_up_st = blink_data_left(i,3);
            idx_up_en = blink_data_left(i,4);
            dur_update = eye_left.UTC(idx_up_en,1) - eye_left.UTC(idx_up_st,1);
            blink_data_left(i, 2) = dur_update ;

        elseif is_between_1  == 0 && is_between_2 == 1
            blink_data_left(i,3) = blink_data_left(i+1,3);
            blink_data_left(i+1,:) = [];

            % Duration update
            idx_up_st = blink_data_left(i,3);
            idx_up_en = blink_data_left(i,4);
            dur_update = eye_left.UTC(idx_up_en,1) - eye_left.UTC(idx_up_st,1);
            blink_data_left(i, 2) = dur_update ;
        end
    end
end



%% Blink output
% 1) blink_data_left
% 2) blink_data_right

%% Hampel filter

[eye_left, eye_right, gaze_xy_left, proc_new_eye]...
    = hampel_filter_N_testing(eye_left, eye_right, gaze_xy_left,...
    proc_new_eye, eye_test_on);


%% Check whether each epoch is overlapped with either saccade or blink

% Check whether blink & saccade is in between two values
Nzeros = zeros(size(epoch_data,1),1);
column_names = {'blink_overlapped_start', 'blink_overlapped_end', ...
    'saccade_overlapped_start', 'saccade_overlapped_end',...
    'blink_overlapped_n', 'saccade_overlapped_n', 'blink_overlapped_duration',...
    'saccade_overlapped_duration'};
epoch_data_check = table(Nzeros(:,1),Nzeros(:,1),Nzeros(:,1),Nzeros(:,1),Nzeros(:,1),...
    Nzeros(:,1),Nzeros(:,1),Nzeros(:,1), 'VariableNames', column_names);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epoch_end = epoch_data.Var10;

% Left eye
t_ = eye_left.UTC;          % UTC timing of eye-tracking data

% Duration: 2 seconds for feature extraction
% fts_cond.data_dur

epoch_data.left_index_start = zeros(size(epoch_data,1),1);
epoch_data.left_index_end = zeros(size(epoch_data,1),1);

for i = 1:size(epoch_end,1)    
    [~, c_idx] = min(abs(t_ - epoch_end(i,1)));         % epoch end
    epoch_data.left_index_end(i,1) = c_idx;
    
    % 3 seconds duration for feature extaction
    epoch_st = epoch_end(i,1) - 3;      
 
    [~, c_idx] = min(abs(t_ - epoch_st));          % epoch start
    epoch_data.left_index_start(i,1) = c_idx;
end

% Right eye
t_ = eye_right.UTC;          % UTC timing of eye-tracking data

epoch_data.right_index_start = zeros(size(epoch_data,1),1);
epoch_data.right_index_end = zeros(size(epoch_data,1),1);

for i = 1:size(epoch_end,1)    
    [~, c_idx] = min(abs(t_ - epoch_end(i,1)));         % epoch end
    epoch_data.right_index_end(i,1) = c_idx;

    % 3 seconds duration for feature extaction
    epoch_st = epoch_end(i,1) - 3;          
    
    [~, c_idx] = min(abs(t_ - epoch_st));          % epoch start
    epoch_data.right_index_start(i,1) = c_idx;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i = 1:size(epoch_data,1)
    
    % Check if blink_left falls within the range
    within_range_1 = blink_data_left(:,3) >= epoch_data.left_index_start(i,1)...
            & blink_data_left(:,3) <= epoch_data.left_index_end(i,1);
    within_range_2 = blink_data_left(:,4) >= epoch_data.left_index_start(i,1)...
            & blink_data_left(:,4) <= epoch_data.left_index_end(i,1);
     
    idx_b_1 = find(within_range_1 == 1);    idx_blink = idx_b_1;
    idx_b_2 = find(within_range_2 == 1);    blink_n = length(idx_blink);

    % Check if blink_left falls within the range
    within_range_3 = sac_left(:,1) >= epoch_data.left_index_start(i,1)...
            & sac_left(:,1) <= epoch_data.left_index_end(i,1);
    within_range_4 = sac_left(:,2) >= epoch_data.left_index_start(i,1)...
            & sac_left(:,2) <= epoch_data.left_index_end(i,1);
 
    idx_s_1 = find(within_range_3 == 1);    idx_saccade = idx_s_1;
    idx_s_2 = find(within_range_4 == 1);    saccade_n = length(idx_saccade);
    

    % result = condition ? value_if_true : value_if_false;
%     if isempty(idx_b_1), idx_b_1 = 0; else, idx_b_1 = 1; end
    if isempty(idx_b_1), idx_b_1 = 0; blink_sum = 0; else, ... 
    blink_sum = sum(blink_data_left(idx_blink,2)); idx_b_1 = 1; end        
    if isempty(idx_b_2), idx_b_2 = 0; else, idx_b_2 = 1; end
%     if isempty(idx_s_1), idx_s_1 = 0; else, idx_s_1 = 1; end
    if isempty(idx_s_1), idx_s_1 = 0; saccade_sum = 0; else, ... 
    saccade_sum = sum(sac_left(idx_saccade,5)); idx_s_1 = 1; end   
    if isempty(idx_s_2), idx_s_2 = 0; else, idx_s_2 = 1; end
    
    
    epoch_data_check.blink_overlapped_start(i,1)        = idx_b_1;
    epoch_data_check.blink_overlapped_end(i,1)          = idx_b_2;
    epoch_data_check.saccade_overlapped_start(i,1)      = idx_s_1;
    epoch_data_check.saccade_overlapped_end(i,1)        = idx_s_2;
    epoch_data_check.blink_overlapped_n(i,1)            = blink_n;
    epoch_data_check.saccade_overlapped_n(i,1)          = saccade_n;
    epoch_data_check.blink_overlapped_duration(i,1)     = blink_sum ;
    epoch_data_check.saccade_overlapped_duration(i,1)   = saccade_sum;
    
end

%% Eye - Data interpolation & smoothing
% processed_pupil_area => hampel filter applied.

% eye_left  => Column 5: Pupil area / Column 13: Hampel applied
% eye_right => 
% proc_new_eye  => Col 10: processed / Col 11: Hampel applied
% gaze_xy_left  => Col 7: gaze_x / 8: gaze_y / 9: pupil_x / 10: pupil_y

%% Interpolation in saccade and blink

selected_columns = [3:7, 13];
selected_columns_2 = [2:4];

% Savitsky golay filter parameter
sgf_cond.order = 3;
sgf_cond.framelen = 11;

[s_eye_left, s_eye_right, proc_new_eye, gaze_xy_left] = ...
    smoothing_interpolation(blink_data_left, sac_left, eye_left, ...
    blink_data_right, sac_right, eye_right, proc_new_eye, gaze_xy_left,...
    selected_columns, selected_columns_2, sgf_cond);
 

%% Fixation extraction

% Fixation Left
fix_left = zeros(size(sac_left));
for i = 1:size(sac_left,1)
    if i == 1
        fix_left(i,1) = 1;
        fix_left(i,2) = sac_left(i,1) -1;
    else
        fix_left(i,1) = sac_left(i-1,2) +1;
        fix_left(i,2) = sac_left(i,1) -1;
    end
end

% Last row from the end timing of the last saccade to the end of the file
last_row = zeros(1,size(sac_left,2));
last_row(1,1) = sac_left(end,2) +1;     last_row(1,2) = size(s_eye_left,1);
% Appending the last row to the fixation data 
fix_left = [fix_left; last_row];


% Fixation Right
fix_right = zeros(size(sac_right));
for i = 1:size(sac_right,1)
    if i == 1
        fix_right(i,1) = 1;
        fix_right(i,2) = sac_right(i,1) -1;
    else
        fix_right(i,1) = sac_right(i-1,2) +1;
        fix_right(i,2) = sac_right(i,1) -1;
    end
end

% Last row from the end timing of the last saccade to the end of the file
last_row = zeros(1,size(sac_right,2));
last_row(1,1) = sac_right(end,2) +1;     last_row(1,2) = size(s_eye_right,1);
% Appending the last row to the fixation data 
fix_right = [fix_right; last_row];


% Add timing info and duration for fixations
for i = 1:size(fix_left)
    fix_left(i,3) = s_eye_left.UTC(fix_left(i,1),1);
    fix_left(i,4) = s_eye_left.UTC(fix_left(i,2),1);    
    fix_left(i,5) = fix_left(i,4) - fix_left(i,3);
end

for i = 1:size(fix_right)
    fix_right(i,3) = s_eye_right.UTC(fix_right(i,1),1);
    fix_right(i,4) = s_eye_right.UTC(fix_right(i,2),1);    
    fix_right(i,5) = fix_right(i,4) - fix_right(i,3);
end



end