function [eeg_CAR, new_fix] = CAR_filter_eye_rev(eeg_data, blink_, sac_)

% replace data from CAR filter based on fixation & saccade epoch
eeg_CAR = eeg_data;

% performed CAR based on Blink epochs 
% Blink
for k = 1:size(blink_,1)
    avg_eeg = mean(eeg_data(blink_(k,1):blink_(k,2),:),2);
    eeg_CAR(blink_(k,1):blink_(k,2),:) = eeg_data(blink_(k,1):blink_(k,2),:) - avg_eeg;
end


% performed CAR based on saccade epochs 
% Saccade
new_fix = zeros(size(sac_,1)+1,1);
for k = 1:size(sac_,1)
    avg_eeg = mean(eeg_data(sac_(k,1):sac_(k,2),:),2);
    eeg_CAR(sac_(k,1):sac_(k,2),:) = eeg_data(sac_(k,1):sac_(k,2),:) - avg_eeg;
    
    % New fixation based on saccade
    new_fix(k+1,1) = sac_(k,2) + 1;
    if k < size(sac_,1)
        new_fix(k+1,2) = sac_(k+1,1) - 1;    
    end
end

new_fix(1,1) = 1;                       new_fix(1,2)   = sac_(1,1) - 1;
new_fix(end,1) = sac_(end,2) + 1 ;      new_fix(end,2) = size(eeg_data,1);

% performed CAR based on fixation epochs 
% New fixation based on saccade
for k = 1:size(new_fix,1)
    avg_eeg = mean(eeg_data(new_fix(k,1):new_fix(k,2),:),2);
    eeg_CAR(new_fix(k,1):new_fix(k,2),:) = eeg_data(new_fix(k,1):new_fix(k,2),:) - avg_eeg;    
end

end




