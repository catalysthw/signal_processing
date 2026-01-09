function [p_delta, p_theta, p_alpha, p_beta, p_low, ratio_feats] ...
    = EEG_feats_inside(st, en, eeg_, deltaData, thetaData, alphaData, ...
    betaData, lowData, Fs)

% % EEG feature extraction
% [p_delta, p_theta, p_alpha, p_beta, p_low, ratio_feats] ...
% = EEG_feats_inside(st, en, deltaData, thetaData, alphaData, ...
% betaData, lowData);

%%%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%%%%%%% 
addpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EEG-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = struct();
opts.fs = Fs;      % Sampling frequency = 500 [Hz]

x_data = eeg_(st:en,1);

% deltaData, thetaData, alphaData, betaData
% Feature extraction => Hjorth Activity, Mobility, Complexity, etc....  
x = deltaData(st:en,1);  band_name = 'delta_';   [p_delta] = feats_collection(x, x_data, band_name, opts);
x = thetaData(st:en,1);  band_name = 'theta_';   [p_theta] = feats_collection(x, x_data, band_name, opts);
x = alphaData(st:en,1);  band_name = 'alpta_';   [p_alpha] = feats_collection(x, x_data, band_name, opts);
x = betaData(st:en,1);   band_name = 'beta_';    [p_beta]  = feats_collection(x, x_data, band_name, opts);
x = lowData(st:en,1);    band_name = 'low_';     [p_low]   = feats_collection(x, x_data, band_name, opts);

% Features for each band and relative band frequency  
f_delta = jfeeg('bpd', x_data, opts);
f_delta_r = jfeeg('bpd_r', x_data, opts);
f_theta = jfeeg('bpt', x_data, opts);
f_theta_r = jfeeg('bpt_r', x_data, opts);
f_alpha = jfeeg('bpa', x_data, opts);
f_alpha_r = jfeeg('bpa_r', x_data, opts);
f_beta = jfeeg('bpb', x_data, opts);
f_beta_r = jfeeg('bpb_r', x_data, opts);
f_low = jfeeg('bpl', x_data, opts);         % [0.5 - 10] Hz
f_low_r = jfeeg('bpl_r', x_data, opts);     

% Features for ratio of two bands 
f_rt_da = f_delta/f_alpha;
f_rt_dt = f_delta/f_theta;
f_rt_db = f_delta/f_beta;

f_rt_td = f_theta/f_delta;
f_rt_ta = f_theta/f_alpha;
f_rt_tb = f_theta/f_beta;

f_rt_ad = f_alpha/f_delta;
f_rt_at = f_alpha/f_theta;
f_rt_ab = f_alpha/f_beta;

f_rt_ld = f_low/f_delta;
f_rt_lt = f_low/f_theta;
f_rt_la = f_low/f_alpha;
f_rt_lb = f_low/f_beta;

% Features: Ratio of two band frequencies 
ratio_feats = [f_rt_da, f_rt_dt, f_rt_db, f_rt_td, f_rt_ta, f_rt_tb, f_rt_ad, f_rt_at,...
    f_rt_ab, f_rt_ld, f_rt_lt, f_rt_la, f_rt_lb];

headers_ratio = {'ratio_d_a', 'ratio_d_t', 'ratio_d_b', 'ratio_t_d', ...
    'ratio_t_a', 'ratio_t_b', 'ratio_a_d', 'ratio_a_t', 'ratio_a_b', ...
    'ratio_l_d', 'ratio_l_t', 'ratio_l_a', 'ratio_l_b'};

ratio_feats = array2table(ratio_feats, 'VariableNames', headers_ratio);


%%

%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
rmpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EEG-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

