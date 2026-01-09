function [epoch_data_new_0, epoch_data_new_1, epoch_data_new_2] ...
    = epoch_index_check(epoch_data, eye_left, eye_right, ep_scenario, conditions)
%%

% New epoch data for the second feature set (the 1st set for     
epoch_data_new_0 = epoch_data;
epoch_data_new_1 = epoch_data;
epoch_data_new_2 = epoch_data;

% Epoch duration
epoch_duration = conditions.ep_dur/1000;           % [s]


if ep_scenario == 0
    % Epoch end
    epoch_data_new_0.Var10 = epoch_data_new_0.Var10 + conditions.time_sub/1000;
    % Epoch start
    epoch_data_new_0.Var9  = epoch_data_new_0.Var10 - epoch_duration;
        
    %% Left eye - Index of start/end timings
    epoch_end = epoch_data_new_0.Var10;
    epoch_st  = epoch_data_new_0.Var9;

    t_ = eye_left.UTC;

    epoch_data_new_0.left_index_start = zeros(size(epoch_data_new_0,1),1);
    epoch_data_new_0.left_index_end = zeros(size(epoch_data_new_0,1),1);

    for i = 1:size(epoch_end,1)    
        [~, c_idx] = min(abs(t_ - epoch_end(i,1)));         % epoch end
        epoch_data_new_0.left_index_end(i,1) = c_idx;
        
        [~, c_idx] = min(abs(t_ - epoch_st(i,1)));          % epoch start
        epoch_data_new_0.left_index_start(i,1) = c_idx;
    end

    
    
    
    %% Right eye - Index of start/end timings
    t_ = eye_right.UTC;
    
    epoch_data_new_0.right_index_start = zeros(size(epoch_data_new_0,1),1);
    epoch_data_new_0.right_index_end = zeros(size(epoch_data_new_0,1),1);

    for i = 1:size(epoch_end,1)
        [~, c_idx] = min(abs(t_ - epoch_end(i,1)));         % epoch end
        epoch_data_new_0.right_index_end(i,1) = c_idx;

        [~, c_idx] = min(abs(t_ - epoch_st(i,1)));          % epoch start
        epoch_data_new_0.right_index_start(i,1) = c_idx;
    end

%%


elseif ep_scenario == 1
%% Basic epoch set - no event / no stimuli range
    scenario_type = epoch_data_new_1.Var5(1,1);    % Scenario type: 1=C / 2=D / 3=H
    epoch_type = epoch_data_new_1.Var7;       % Epoch codes
    
    % Epoch start/end timestamp    
    epoch_end = epoch_data_new_1.Var10;
    epoch_st  = epoch_data_new_1.Var9;
    
    
    %% Left eye - Index of start/end timings    

    % epoch_data_new_1
    epoch_data_new_1.left_index_start = zeros(size(epoch_data_new_1,1),1);
    epoch_data_new_1.left_index_end = zeros(size(epoch_data_new_1,1),1);    
    
    % epoch_data_new_2
    epoch_data_new_2.left_index_start = zeros(size(epoch_data_new_2,1),1);
    epoch_data_new_2.left_index_end = zeros(size(epoch_data_new_2,1),1);        
   
    t_ = eye_left.UTC;                      % Timestamp

    for i = 1:size(epoch_end,1)
        
        code = epoch_type(i,1);
        [dur_before, extra_dur, logic_code] = epoch_type_check(code, scenario_type);
        
        if logic_code == 1
            
            
        else

            
            epoch_duration 
        end        
            %% epoch_data_new_1
            % new epoch end 
            % epoch_end(i,1) = epoch_end(i,1) - dur_before;     
            epoch_data_new_1.Var10(i,1) = epoch_data_new_1.Var10(i,1) - dur_before;
            [~, c_idx] = min(abs(t_ - epoch_data_new_1.Var10(i,1)));
            epoch_data_new_1.left_index_end(i,1) = c_idx;

            % new epoch start 
            % epoch_st(i,1) = epoch_end(i,1) - epoch_duration;
            epoch_data_new_1.Var9(i,1) = epoch_data_new_1.Var10(i,1) - epoch_duration;
            [~, c_idx] = min(abs(t_ - epoch_data_new_1.Var9(i,1)));      % find the index
            epoch_data_new_1.left_index_start(i,1) = c_idx;              

            %% epoch_data_new_2
            % new epoch end 
            % epoch_end(i,1) = epoch_end(i,1) - dur_before;     
            epoch_data_new_2.Var10(i,1) = epoch_data_new_2.Var10(i,1) - dur_before + extra_dur;
            [~, c_idx] = min(abs(t_ - epoch_data_new_2.Var10(i,1)));
            epoch_data_new_2.left_index_end(i,1) = c_idx;

            % new epoch start 
            % epoch_st(i,1) = epoch_end(i,1) - epoch_duration;
            epoch_data_new_2.Var9(i,1) = epoch_data_new_2.Var10(i,1) - epoch_duration;
            [~, c_idx] = min(abs(t_ - epoch_data_new_2.Var9(i,1)));      % find the index
            epoch_data_new_2.left_index_start(i,1) = c_idx;                  
        

            
    end
    

    %% Right eye - Index of start/end timings   
    
    % epoch_data_new_1    
    epoch_data_new_1.right_index_start = zeros(size(epoch_data_new_1,1),1);
    epoch_data_new_1.right_index_end = zeros(size(epoch_data_new_1,1),1);    

    % epoch_data_new_2    
    epoch_data_new_2.right_index_start = zeros(size(epoch_data_new_2,1),1);
    epoch_data_new_2.right_index_end = zeros(size(epoch_data_new_2,1),1);    
        
    t_ = eye_right.UTC;                      % Timestamp

    for i = 1:size(epoch_end,1)
        
        %% epoch_data_new_1        
        code = epoch_type(i,1);
        [dur_before, extra_dur, logic_code] = epoch_type_check(code, scenario_type);
        
        if logic_code == 1
            
            % new epoch end 
            % epoch_end(i,1) = epoch_end(i,1) - dur_before;     
            epoch_data_new_1.Var10(i,1) = epoch_data_new_1.Var10(i,1) - dur_before;
            [~, c_idx] = min(abs(t_ - epoch_data_new_1.Var10(i,1)));
            epoch_data_new_1.right_index_end(i,1) = c_idx;

            % new epoch start 
            % epoch_st(i,1) = epoch_end(i,1) - epoch_duration;
            epoch_data_new_1.Var9(i,1) = epoch_data_new_1.Var10(i,1) - epoch_duration;
            [~, c_idx] = min(abs(t_ - epoch_data_new_1.Var9(i,1)));      % find the index
            epoch_data_new_1.right_index_start(i,1) = c_idx;              

            %% epoch_data_new_2
            % new epoch end 
            % epoch_end(i,1) = epoch_end(i,1) - dur_before;     
            epoch_data_new_2.Var10(i,1) = epoch_data_new_2.Var10(i,1) - dur_before + extra_dur;
            [~, c_idx] = min(abs(t_ - epoch_data_new_2.Var10(i,1)));
            epoch_data_new_2.right_index_end(i,1) = c_idx;

            % new epoch start 
            % epoch_st(i,1) = epoch_end(i,1) - epoch_duration;
            epoch_data_new_2.Var9(i,1) = epoch_data_new_2.Var10(i,1) - epoch_duration;
            [~, c_idx] = min(abs(t_ - epoch_data_new_2.Var9(i,1)));      % find the index
            epoch_data_new_2.right_index_start(i,1) = c_idx;                  

            
            
        else
            
            
            
            
            
            
            
        end
        
    end

    %% 
    
    
    %% 
    
    end
    
end



