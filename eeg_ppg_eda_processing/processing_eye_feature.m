function [feats_set] = processing_eye_feature(x_a)
%   Detailed explanation goes here

    
%%%%%%%%%%%%%%%%% Add feature extraction function path %%%%%%%%%%%%%%%% 
addpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EYE-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


try
    f_mcl  = efeye('emcl', x_a);        % Mean Curve Length
    f_ha   = efeye('eha', x_a);         % Hjorth Activity
    f_hm   = efeye('ehm', x_a);         % Hjorth Mobility
    f_hc   = efeye('ehc', x_a);         % Hjorth Complexity
    f_n1d  = efeye('en1d', x_a);        % Normalized first difference
    f_n2d  = efeye('en2d', x_a);        % Normalized second difference
    f_me   = efeye('eme', x_a);         % Mean Energy
    f_te   = efeye('ete', x_a);         % Tsallis Entropy    
    f_sh   = efeye('esh', x_a);         % Shannon Entropy
    f_le   = efeye('ele', x_a);         % Log Energy Entropy
    f_am   = efeye('eam', x_a);         % Arithmetic Mean
    f_sd   = efeye('esd', x_a);         % Standard Deviation
    f_var  = efeye('evar', x_a);        % Variance
    f_md   = efeye('emd', x_a);         % Median   
    % f_ar   = efeye('ear', x_a);         % Autoregressive (default order = 4)
    f_kurt = efeye('ekurt', x_a);       % Kurtosis
    f_skew = efeye('eskew', x_a);       % Skewness
    f_bp   = efeye('ebpa', x_a);        % average band power 
    f_bpr  = efeye('erbp', x_a);        % relative band power 
    f_psd  = efeye('epsd', x_a);        % PSD
    
    %% New added features
    
    f_max_ps    = efeye('eMax', x_a);   % Max data 
    f_min_ps    = efeye('eMin', x_a);   % Min data 
    f_avg_ps    = efeye('eAvg', x_a);   % Avg data 
    f_max_ps_r  = efeye('eMaxR', x_a);   % Max data change
    f_min_ps_r  = efeye('eMinR', x_a);   % Min data change
    f_avg_ps_r  = efeye('eAvgR', x_a);   % Avg data change
    f_max_ps_rr = efeye('eMaxRR', x_a);   % Max data rate change
    f_min_ps_rr = efeye('eMinRR', x_a);   % Min data rate change
    f_avg_ps_rr = efeye('eAvgRR', x_a);   % Avg data rate change
    
    
    
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


    
    
 
    
    % f_katz = efeye('ekatz', x_a);       % Katz estimation (fractal dimension)
    % f_sef  = efeye('esef', x_a);        % Spectral Edge Frequency  
    
    
catch
    disp('if catch on, catch');
    f_mcl  = 0;         % Mean Curve Length
    f_ha   = 0;         % Hjorth Activity
    f_hm   = 0;         % Hjorth Mobility
    f_hc   = 0;         % Hjorth Complexity
    f_n1d  = 0;         % Normalized first difference
    f_n2d  = 0;         % Normalized second difference
    f_me   = 0;         % Mean Energy
    f_te   = 0;         % Tsallis Entropy    
    f_sh   = 0;         % Shannon Entropy
    f_le   = 0;         % Log Energy Entropy
    f_am   = 0;         % Arithmetic Mean
    f_sd   = 0;         % Standard Deviation
    f_var  = 0;         % Variance
    f_md   = 0;         % Median   
    % f_ar   = 0;       % Autoregressive (default order = 4)
    f_kurt = 0;         % Kurtosis
    f_skew = 0;         % Skewness
    f_bp   = 0;         % average band power 
    f_bpr  = 0;         % relative band power 
    f_psd  = 0;         % PSD
    
    f_max_ps = 0;       % Max data 
    f_min_ps = 0;       % Min data 
    f_avg_ps = 0;       % Avg data 
    f_max_ps_r = 0;     % Max data change
    f_min_ps_r = 0;     % Min data change
    f_avg_ps_r = 0;     % Avg data change
    f_max_ps_rr = 0;    % Max data rate change
    f_min_ps_rr = 0;    % Min data rate change
    f_avg_ps_rr = 0;    % Avg data rate change
        
    
    % f_katz = efeye('ekatz', x_a);       % Katz estimation (fractal dimension)
    % f_sef  = efeye('esef', x_a);        % Spectral Edge Frequency    
    
    
    
    
end

feats_set = [f_mcl f_ha f_hm f_hc f_n1d f_n2d f_me f_te f_sh f_le f_am...
    f_sd f_var f_md f_kurt f_skew f_bp f_bpr f_psd f_max_ps f_min_ps...
    f_avg_ps f_max_ps_r f_min_ps_r f_avg_ps_r f_max_ps_rr f_min_ps_rr...
    f_avg_ps_rr];

%%%%%%%%%%%%%%%%% Remove feature extraction function path %%%%%%%%%%%%%%%%% 
rmpath('C:\Users\2hyow\Dropbox\processing_code\feature_extraction\EYE-Feature-Extraction')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% headers
% feats_header = str('(e)Mean_curve_length','(e)Hjorth_activty','(e)Hjorth_mobility',...
%     '(e)Hjorth_complex','(e)Nor_1st_diff','(e)Nor_2nd_diff','(e)Mean_energy',...
%     '(e)Tsallis_entropy','(e)Shannon_entropy','(e)Log_energy_entropy','(e)Arithemtic_mean',...
%     '(e)Standard Deviation', '(e)Variance','(e)Median','(e)Kurtosis','(e)Skewness', ...
%     '(e)Band_power','(e)Rel_power', '(e)PSD', 'Max', 'Min', 'Avg', 'Max_rate', 'Min_rate',...
%     'Avg_rate', 'Max_rate_R', 'Min_rate_R', 'Avg_rate_R');




end

