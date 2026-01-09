function [E4_fatigue_struct, E4_feats_struct] = E4_feats_gen(data_e4, ...
    eeg_t_left_arr, epoch_data, fs_list)

fs_BVP = fs_list.fs_BVP;       fs_EDA  = fs_list.fs_EDA;                
fs_HR  = fs_list.fs_HR;        fs_Temp = fs_list.fs_Temp;

% Epoch information
epoch_end = epoch_data.Var10;           % End UTC timing
scenario_type = epoch_data.Var5;        % Scenario type = C / D / H
epoch_code    = epoch_data.Var7;        % Epoch codes 
epoch_name    = epoch_data.Var4;        % Epoch names

% Physiological Signals 
BVP_sig  = data_e4.BVP;
EDA_sig  = data_e4.EDA;
HR_sig   = data_e4.HR;
IBI_sig  = data_e4.IBI;
TEMP_sig = data_e4.Temp;

% Heart rate variability 
HRV_sig = HR_sig(2:end,2)- HR_sig(1:end-1,2); 
HRV_sig = [HR_sig(2:end,1), HRV_sig];


%% Fatigue/Mental workload/stress

% after a few seconds of waiting / start collecting data 
skip_sec = 10;
N_skip_bvp = fs_BVP*skip_sec;         N_skip_eda  = fs_EDA*skip_sec;
N_skip_hr  = fs_HR*skip_sec;          N_skip_temp = fs_Temp*skip_sec;
N_skip_hrv = N_skip_hr -1;

% data starting after waiting time
bvp_f  =  BVP_sig(N_skip_bvp:end,:);
hr_f   =   HR_sig(N_skip_hr:end,:);
eda_f  =  EDA_sig(N_skip_eda:end,:); 
temp_f = TEMP_sig(N_skip_temp:end,:); 
hrv_f  = HRV_sig(N_skip_hrv:end,:);

%% Function 1

% 1 minutes epoch and 0.5 seconds overlap for feature extractions
m = 1;                  % a few minutes
m_overlap = 0.5;        % minutes

% % BVP signal / sampling freq of the signal
% x = bvp_f;          sf = fs_BVP;        signal_type = 'BVP';
% [fts_BVP_ind] = E4_feature_index(m, m_overlap, x, sf);
% % plot(BVP_sig(:,2));
% 
% % Peak detection was performed using the 'findpeak' function, with a
% % threshold set to a minimum peak distance of 0.4s and a minimum peak height of 0. 
% BVP_feats_extracted(fts_BVP_ind, x, signal_type);

% Empty structs for fatigue features and severity features
E4_fatigue_struct = struct();
E4_feats_struct   = struct();


% HR signal / sampling freq of the signal
x = hr_f;          sf = fs_HR;          signal_type = {'HR'};
[fts_HR_ind] = E4_feature_index(m, m_overlap, x, sf);
[HR_fts_table] = E4_feats_extracted(fts_HR_ind, x, signal_type);
[HR_fts_struct] = E4_feats_long_extracted(x, eeg_t_left_arr, signal_type, epoch_data);

% EDA signal / sampling freq of the signal
x = eda_f;          sf = fs_EDA;        signal_type = {'EDA'};
[fts_EDA_ind] = E4_feature_index(m, m_overlap, x, sf);
[EDA_fts_table] = E4_feats_extracted(fts_EDA_ind, x, signal_type);
[EDA_fts_struct] = E4_feats_long_extracted(x, eeg_t_left_arr, signal_type, epoch_data);

% temp signal / sampling freq of the signal
x = temp_f;          sf = fs_Temp;      signal_type = {'TEMP'};
[fts_TEMP_ind] = E4_feature_index(m, m_overlap, x, sf);
[TEMP_fts_table] = E4_feats_extracted(fts_TEMP_ind, x, signal_type);
[TEMP_fts_struct] = E4_feats_long_extracted(x, eeg_t_left_arr, signal_type, epoch_data);

% temp signal / sampling freq of the signal
x = hrv_f;          sf = fs_HR;         signal_type = {'HRV'};
[fts_HRV_ind] = E4_feature_index(m, m_overlap, x, sf);
[HRV_fts_table] = E4_feats_extracted(fts_HRV_ind, x, signal_type);
[HRV_fts_struct] = E4_feats_long_extracted(x, eeg_t_left_arr, signal_type, epoch_data);


% Collect fatigue feature tables into a single struct
E4_fatigue_struct.HR   = HR_fts_table;
E4_fatigue_struct.EDA  = EDA_fts_table;
E4_fatigue_struct.TEMP = TEMP_fts_table;
E4_fatigue_struct.HRV  = HRV_fts_table;

% Collect severity feature tables into a single struct
E4_feats_struct.HR   = HR_fts_struct;
E4_feats_struct.EDA  = EDA_fts_struct;
E4_feats_struct.TEMP = TEMP_fts_struct;
E4_feats_struct.HRV  = HRV_fts_struct;



end

