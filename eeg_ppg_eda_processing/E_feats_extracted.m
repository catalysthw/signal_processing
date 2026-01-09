function [new_t,outputArg2] = E_feats_extracted(proc_new_eye,...
    epoch_end, epoch_dur, s_eye_right)


%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
addpath('F:\0.exp_processed_data\eye_feature_processing')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[feats_1st_set, feats_2nd_set, feats_3rd_set, feats_4th_set_left, ...
    processed_1st_header, processed_2nd_header, processed_3rd_header, ...
    processed_4th_header] = E_feats_gen(proc_new_eye, s_eye_left, new_t_arr);

[~, ~, ~, feats_4th_set_right, ~, ~, ~, ~] ...
    = E_feats_gen(proc_new_eye, s_eye_right, new_t_arr);




% Step: every 100ms (new timestamp)
new_t_left_arr = zeros(size(epoch_end,1),5);
new_t_left_arr(i,1) = epoch_end(i,1) - epoch_dur:0.1:epoch_end(i,1);

new_t_right_arr = zeros(size(epoch_end,1),5);
new_t_right_arr(i,1) = epoch_end(i,1) - epoch_dur:0.1:epoch_end(i,1);

t_left_orig = proc_new_eye.time_stamps;
t_right_orig = s_eye_right.time_stamps;



for i = 1:size(epoch_end,1)
    %%
    % Step 100 ms
    new_t_left_arr(i,2) = new_t_left_arr(i,1)-0.15;       % before 150ms 
    new_t_left_arr(i,3) = new_t_left_arr(i,1)+0.15;       % after  150ms
    
    % Start / End timings
    [~ , st_idx] = min(abs(t_left_orig - new_t_left_arr(i,2))); 
    [~ , en_idx] = min(abs(t_left_orig - new_t_left_arr(i,3)));   
    
    % Start / End indexes
    new_t_left_arr(i,4) = st_idx;    new_t_left_arr(i,5) = en_idx;

    %%
    % Step 100 ms
    new_t_right_arr(i,2) = new_t_right_arr(i,1)-0.15;       % before 150ms 
    new_t_right_arr(i,3) = new_t_right_arr(i,1)+0.15;       % after  150ms
    
    % Start / End timings
    [~ , st_idx] = min(abs(t_right_orig - new_t_right_arr(i,2))); 
    [~ , en_idx] = min(abs(t_right_orig - new_t_right_arr(i,3)));   
    
    % Start / End indexes
    new_t_right_arr(i,4) = st_idx;    new_t_right_arr(i,5) = en_idx; 
    
end

% Convert array to table with headers
headers = {'base_timestamp', 't_start', 't_end', 'index_start', 'index_end'};
new_t_left_arr = array2table(new_t_left_arr, 'VariableNames', headers);
new_t_right_arr = array2table(new_t_right_arr, 'VariableNames', headers);

%%
% Eye feature extraction
[feats_1st_set, feats_2nd_set, feats_3rd_set, feats_4th_set_left, ...
    processed_1st_header, processed_2nd_header, processed_3rd_header, ...
    processed_4th_header] = E_feats_gen(proc_new_eye, s_eye_left, new_t_left_arr)

[~, ~, ~, feats_4th_set_right, ~, ~, ~, ~] ...
    = E_feats_gen(proc_new_eye, s_eye_right, new_t_right_arr);

%%


%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
rmpath('F:\0.exp_processed_data\eye_feature_processing')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
%%
