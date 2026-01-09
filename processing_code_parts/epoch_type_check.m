function [dur_before, extra_dur, DigitLogical] = epoch_type_check(code, epoch_type)


% Step 1 & 2: Check for four digits
% This finds all elements that are >= 1000 and <= 9999 or -1000 to -9999
DigitLogical = (code >= 1 & code <= 12) | (code >= 21 & code <= 28);


if DigitLogical == 1
    
    % if epoch_type == 1 / == 2 / == 3
    if epoch_type == 1              % Scenario C
        dur_before = 4.0;       extra_dur = 2;      % [s]
    elseif epoch_type == 2          % Scenario D
        dur_before = 3.3;       extra_dur = 1.3;      % [s]
    elseif epoch_type == 3          % Scenario H 
        dur_before = 1.2;       extra_dur = 0.7;      % [s]
    end

    
else
    % if DigitLogical ~= 1 (not main events)
    if code == 100
        dur_before = 0;       extra_dur = 1;      % [s]
    elseif code == 101
        dur_before = 1;       extra_dur = 1;      % [s]
    elseif code == 102
        dur_before = 4;       extra_dur = 2;      % [s]
    elseif code == 103
        dur_before = 2;       extra_dur = 1;      % [s]
    elseif code == 104
        dur_before = 0;       extra_dur = 1;      % [s]
    elseif code == 105
        dur_before = 2;       extra_dur = 1;      % [s]
    elseif code == 106
        dur_before = 0;       extra_dur = 1;      % [s]
    end

end

end

