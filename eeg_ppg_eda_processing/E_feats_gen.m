function [feats_1st_set, feats_2nd_set, feats_3rd_set, feats_4th_set, ...
    processed_1st_header, processed_2nd_header, processed_3rd_header, ...
    processed_4th_header] = E_feats_gen(proc_new_eye, s_eye_data, new_t_arr)

% %%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
% addpath('F:\0.exp_processed_data\eye_feature_processing')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% headers = {'base_timestamp', 't_start', 't_end', 'index_start', 'index_end'};

%%
% selected_columns = [12:40];
% headers = proc_new_eye.Properties.VariableNames;

% 1st processed data: final_pupil_area_smoothed / gaze_degree / gaze_magnitude ...
% / pupil_center_degree / pupil_center_magnitude / 

% 2nd processed data: vel_gaze_xy / vel_pupil_center_xy / gaze_degree_velocity ...
% / gaze_magnitude_velocity / pupil_center_degree_velocity / pupil_center_magnitude_velocity 

% 3rd processed data: acc_gaze_xy / acc_pupil_center_xy / pupil_center_degree_acceleration ...
% / pupil_center_magnitude_acceleration / gaze_degree_acceleration / gaze_magnitude_acceleration

processed_1st_header = {'final_pupil_area_smoothed', 'gaze_degree', 'gaze_magnitude', ... 
    'pupil_center_degree', 'pupil_center_magnitude'};

processed_2nd_header = {'vel_gaze_xy', 'vel_pupil_center_xy', 'gaze_degree_velocity', ...
'gaze_magnitude_velocity', 'pupil_center_degree_velocity', 'pupil_center_magnitude_velocity'};

processed_3rd_header = {'acc_gaze_xy', 'acc_pupil_center_xy', 'pupil_center_degree_acceleration', ...
'pupil_center_magnitude_acceleration', 'gaze_degree_acceleration', 'gaze_magnitude_acceleration'};

% processed_4th_header



%% Function: eye_features(X) 
% Output: 28 features
e_Nfeats = 28;          % Number of eye-tracking features

n_fts = size(new_t_arr,1);          % The number of features in each epoch (6 seconds long)
n_max_epoch = size(new_t_arr,3);    % The number of epochs

%% 1st processed data
n_data = size(processed_1st_header,2);
feats_1st_set = zeros(n_fts, e_Nfeats, n_data, n_max_epoch);

for ii = 1:n_data
    x = proc_new_eye.(processed_1st_header{ii});
    
    for kk = 1:n_fts
        for jj = 1:n_max_epoch
            % List all featured data in Left 
            st_idx = new_t_arr(kk,4,jj);
            en_idx = new_t_arr(kk,5,jj);

            x_proc = x(st_idx:en_idx,1);
            
            [feats_set_a] = processing_eye_feature(x_proc);
            feats_1st_set(kk, :, ii, jj) = feats_set_a;        
        end
    end
end


%% 2nd processed data
n_data = size(processed_2nd_header,2);
feats_2nd_set = zeros(n_fts, e_Nfeats, n_data, n_max_epoch);

for ii = 1:n_data
    x = proc_new_eye.(processed_2nd_header{ii});
    
    for kk = 1:n_fts
        for jj = 1:n_max_epoch
            % List all featured data in Left 
            st_idx = new_t_arr(kk,4,jj);
            en_idx = new_t_arr(kk,5,jj);

            x_proc = x(st_idx:en_idx,1);
            
            [feats_set_a] = processing_eye_feature(x_proc);
            feats_2nd_set(kk, :, ii, jj) = feats_set_a;        
        end
    end
end



%% 3rd processed data
n_data = size(processed_3rd_header,2);
feats_3rd_set = zeros(n_fts, e_Nfeats, n_data, n_max_epoch);

% n_fts = size(new_t_arr,1);          % The number of features in each epoch (6 seconds long)
% n_max_epoch = size(new_t_arr,3);    % The number of epochs

for ii = 1:n_data
    x = proc_new_eye.(processed_3rd_header{ii});
    
    for kk = 1:n_fts
        for jj = 1:n_max_epoch
            % List all featured data in Left 
            st_idx = new_t_arr(kk,4,jj);
            en_idx = new_t_arr(kk,5,jj);

            x_proc = x(st_idx:en_idx,1);
            
            [feats_set_a] = processing_eye_feature(x_proc);
            feats_3rd_set(kk, :, ii, jj) = feats_set_a;        
        end
    end
end


%         x_a = pup_(st:en,5);
%         [feats_set_a] = eye_features(x_proc);
%         e_feats_set(1,:,k) = feats_set_a;

%% eye data 
selected_columns = [3:4,13];
processed_4th_header = s_eye_data.Properties.VariableNames(selected_columns);

n_data = size(processed_4th_header,2);
feats_4th_set = zeros(n_fts, e_Nfeats, n_data, n_max_epoch);

for ii = 1:n_data
    x = s_eye_data.(processed_4th_header{ii});
    
    for kk = 1:n_fts
        for jj = 1:n_max_epoch
            % List all featured data in Left 
            st_idx = new_t_arr(kk,4,jj);
            en_idx = new_t_arr(kk,5,jj);

            x_proc = x(st_idx:en_idx,1);
            
            [feats_set_a] = processing_eye_feature(x_proc);
            feats_4th_set(kk, :, ii, jj) = feats_set_a;        
        end
    end
end


% %%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
% rmpath('F:\0.exp_processed_data\eye_feature_processing')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






end

