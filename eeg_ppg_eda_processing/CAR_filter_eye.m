function [eeg_CAR] = CAR_filter_eye(eeg_data, sac_, fix_)

% replace data from CAR filter based on fixation & saccade epoch

eeg_CAR = eeg_data;

% % performed CAR based on fixation epochs 
% for k = 1:length(find(fix_(:,1) > 0))
%     avg_eeg = mean(eeg_data(fix_(k,1):fix_(k,2)),2);
%     eeg_CAR(fix_(k,1):fix_(k,2),:) = eeg_data(fix_(k,1):fix_(k,2),:) - avg_eeg; 
% end
% 
% % performed CAR based on saccade epochs 
% for k = 1:length(find(sac_(:,1) > 0)) 
%     avg_eeg = mean(eeg_data(sac_(k,1):sac_(k,2)),2);
%     eeg_CAR(sac_(k,1):sac_(k,2),:) = eeg_data(sac_(k,1):sac_(k,2),:) - avg_eeg;        
% end


% performed CAR based on fixation epochs 
for k = 1:length(find(fix_(:,1) > 0))
    avg_eeg = mean(eeg_data(fix_(k,1):fix_(k,2)),2);
    eeg_CAR(fix_(k,1):fix_(k,2),:) = eeg_data(fix_(k,1):fix_(k,2),:) - avg_eeg; 
end

% performed CAR based on saccade epochs 
for k = 1:length(find(sac_(:,1) > 0)) 
    if sac_(k,1)+50 < size(eeg_data,1)
        avg_eeg = mean(eeg_data(sac_(k,1):sac_(k,1)+50),2);
        eeg_CAR(sac_(k,1):sac_(k,1)+50,:) = eeg_data(sac_(k,1):sac_(k,1)+50,:) - avg_eeg;
    else
        avg_eeg = mean(eeg_data(sac_(k,1):sac_(k,2)),2);
        eeg_CAR(sac_(k,1):sac_(k,2),:) = eeg_data(sac_(k,1):sac_(k,2),:) - avg_eeg;        
    end
end



end




