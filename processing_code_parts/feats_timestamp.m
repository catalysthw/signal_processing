
function [new_t_left_arr, new_t_right_arr] = feats_timestamp(epoch_dur,...
    proc_new_eye, s_eye_right, epoch_end, fts_step, fts_dur)

length_arr = size(0:fts_step:epoch_dur,2);
n_epoch = size(epoch_end,1);

% duration of 6 seconds for each epoch
new_t_left_arr = zeros(length_arr, n_epoch);

% Start/End timing of 6 seconds duration for each epoch
new_t_left_arr = zeros(length_arr, 5, n_epoch);
new_t_right_arr = zeros(length_arr, 5, n_epoch);

% UTC timing of left/right eye data
try
    t_left_orig = proc_new_eye.time_stamps;
    t_right_orig = s_eye_right.UTC;
catch
    t_left_orig = proc_new_eye/1000;
    t_right_orig = s_eye_right/1000;    
end


for i = 1:size(epoch_end,1)

    % (epoch_end(i,1)-epoch_dur):0.1:epoch_end(i,1);
    epoch_dur_arr = 0:fts_step:epoch_dur;
    dur_arr = epoch_end(i,1) - epoch_dur_arr;       dur_arr = dur_arr';
    
    % Base timstamp
    new_t_left_arr(:, 1, i) = dur_arr;
    new_t_right_arr(:, 1, i) = dur_arr;
    
    % UTC Timing 
    new_t_left_arr(:, 2, i)  = new_t_left_arr(:, 1, i) - fts_dur/2;
    new_t_left_arr(:, 3, i)  = new_t_left_arr(:, 1, i) + fts_dur/2;
    new_t_right_arr(:, 2, i) = new_t_right_arr(:, 1, i) - fts_dur/2;
    new_t_right_arr(:, 3, i) = new_t_right_arr(:, 1, i) + fts_dur/2;
    
    
    % (Left eye) Find indexes for start/end UTC timings
    for j = 1:size(new_t_left_arr, 1)
        % Find the indexes
        [~ , st_idx] = min(abs(t_left_orig - new_t_left_arr(j, 2, i) )); 
        [~ , en_idx] = min(abs(t_left_orig - new_t_left_arr(j, 3, i) ));       
        
        new_t_left_arr(j, 4, i) = st_idx;        
        new_t_left_arr(j, 5, i) = en_idx;
    end
    
    
    % (Right eye) Find indexes for start/end UTC timings
    for j = 1:size(new_t_right_arr, 1)
        % Find the indexes
        [~ , st_idx] = min(abs(t_right_orig - new_t_right_arr(j, 2, i) )); 
        [~ , en_idx] = min(abs(t_right_orig - new_t_right_arr(j, 3, i) ));       
        
        new_t_right_arr(j, 4, i) = st_idx;        
        new_t_right_arr(j, 5, i) = en_idx;
    end 
    
    new_t_left_arr(:, :, i) = flipud(new_t_left_arr(:, :, i));
    new_t_right_arr(:, :, i) = flipud(new_t_right_arr(:, :, i));

end


end

%%
