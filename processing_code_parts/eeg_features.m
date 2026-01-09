function [eeg_fix_left, eeg_fix_right, eeg_sac_left, eeg_sac_right, ...
    eeg_blink_left, eeg_blink_right] = eeg_features(data_eeg, fix_left,...
    fix_right, sac_left, sac_right, blink_data_left, blink_data_right)

% fix_left(:,3)  / fix_left(:,4)
% fix_right(:,3) / fix_right(:,4)
% 
% sac_left(:,3)  / sac_left(:,4)
% sac_right(:,3) / sac_right(:,4)
% 
% blink_data_left(:,1)  / blink_data_left(:,1) + blink_data_left(:,2)
% blink_data_right(:,1) / blink_data_right(:,1) + blink_data_right(:,2)


% Timestamp EEG
t_eeg = data_eeg.Var37/1000;

eeg_fix_left    = fix_left;
eeg_fix_right   = fix_right;
eeg_sac_left    = sac_left;
eeg_sac_right   = sac_right;
eeg_blink_left  = blink_data_left;
eeg_blink_right = blink_data_right;

eeg_blink_left(:,3) = eeg_blink_left(:,1);
eeg_blink_left(:,4) = eeg_blink_left(:,1) + eeg_blink_left(:,2);

eeg_blink_right(:,3) = eeg_blink_right(:,1);
eeg_blink_right(:,4) = eeg_blink_right(:,1) + eeg_blink_right(:,2);


for i = 1:size(fix_left,1)
    [~, st_idx] = min(abs(t_eeg - eeg_fix_left(i,3)));
    [~, en_idx] = min(abs(t_eeg - eeg_fix_left(i,4)));
    
    eeg_fix_left(i,1) = st_idx;
    eeg_fix_left(i,2) = en_idx;
end

for i = 1:size(fix_right,1)
    [~, st_idx] = min(abs(t_eeg - eeg_fix_right(i,3)));
    [~, en_idx] = min(abs(t_eeg - eeg_fix_right(i,4)));
    
    eeg_fix_right(i,1) = st_idx;
    eeg_fix_right(i,2) = en_idx;
end

for i = 1:size(sac_left,1)
    [~, st_idx] = min(abs(t_eeg - eeg_sac_left(i,3)));
    [~, en_idx] = min(abs(t_eeg - eeg_sac_left(i,4)));
    
    eeg_sac_left(i,1) = st_idx;
    eeg_sac_left(i,2) = en_idx;
end

for i = 1:size(sac_right,1)
    [~, st_idx] = min(abs(t_eeg - eeg_sac_right(i,3)));
    [~, en_idx] = min(abs(t_eeg - eeg_sac_right(i,4)));
    
    eeg_sac_right(i,1) = st_idx;
    eeg_sac_right(i,2) = en_idx;
end



for i = 1:size(eeg_blink_left,1)
    t_st = eeg_blink_left(i,3);
    t_en = eeg_blink_left(i,4);
    
    [~, st_idx] = min(abs(t_eeg - t_st));
    [~, en_idx] = min(abs(t_eeg - t_en));
    
    eeg_blink_left(i,1) = st_idx;
    eeg_blink_left(i,2) = en_idx;
end

for i = 1:size(eeg_blink_right,1)
    t_st = eeg_blink_right(i,3);
    t_en = eeg_blink_right(i,4);
    
    [~, st_idx] = min(abs(t_eeg - t_st));
    [~, en_idx] = min(abs(t_eeg - t_en));
    
    eeg_blink_right(i,1) = st_idx;
    eeg_blink_right(i,2) = en_idx;
end






end

