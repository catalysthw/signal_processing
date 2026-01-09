function [data_struct_1st] = eye_struct_data(feats_1st_set, ...
    processed_1st_header, epoch_data)

%% Save all features in a struct
% Empty struct variable for all information
data_struct_1st = struct();

% Assign a relevant dataset
x_all = feats_1st_set;

% headers
feats_header = {'Mean_curve_length','Hjorth_activty','Hjorth_mobility',...
    'Hjorth_complex','Nor_1st_diff','Nor_2nd_diff','Mean_energy',...
    'Tsallis_entropy','Shannon_entropy','Log_energy_entropy','Arithemtic_mean',...
    'Standard Deviation', 'Variance','Median','Kurtosis','Skewness', ...
    'Band_power','Rel_power', 'PSD', 'Max', 'Min', 'Avg', 'Max_rate', 'Min_rate',...
    'Avg_rate', 'Max_rate_R', 'Min_rate_R', 'Avg_rate_R'};

for i = 1:size(x_all, 3)
    % Empty struct
    all_feats_struct = struct();
    
    for j = 1:size(x_all, 4)
        all_fts_table = x_all(:,:,i,j);
        
        % Same table names are overlapped and only one single case reamins. 
        tableName = ['case_', num2str(j)];                % epoch names  
        all_feats_struct.(tableName) = all_fts_table;     % feature tables    
    end
    data_struct_1st.(processed_1st_header{i}) = all_feats_struct;
end

data_struct_1st.epoch_code = epoch_data.Var7;  
data_struct_1st.scenario_type = epoch_data.Var5(1,1);
data_struct_1st.epoch_name = epoch_data.Var4;  
data_struct_1st.feature_headers = feats_header;
data_struct_1st.data_headers = processed_1st_header;

end



