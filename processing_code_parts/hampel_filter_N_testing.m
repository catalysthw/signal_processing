function [eye_left, eye_right, gaze_xy_left, proc_new_eye]...
    = hampel_filter_N_testing(eye_left, eye_right, gaze_xy_left, proc_new_eye, test_on)
% Input
% eye_left / eye_right / proc_new_eye / gaze_xy_left

% Hampel filter testing
if test_on ==1
    figure;
end




%% 1) Original data

%% Left pupil area
pupil_area = table2array(eye_left(:,5));
pupil_time = table2array(eye_left(:,2));

% pupil area
X = 1:length(pupil_time);        Y = pupil_area;
DX  = 3*median(X(2:end)-X(1:end-1))+3; 
DX  = 5*median(X(2:end)-X(1:end-1))+5; 
T   = 3;
% DX          = 1;                                % Window Half size
% T           = 3;                                % Threshold
Threshold   = 0.1;                              % AdaptiveThreshold
%hampel => self hampel function 'hampel_self'
[YY,I,Y0,LB,UB] = hampel_self(X,Y,DX,T,'Adaptive',Threshold);

rel_pupil_time = pupil_time - pupil_time(1,1);

% Add the column of the processed pupil area
eye_left = addvars(eye_left, YY, 'After', size(eye_left,2),...
    'NewVariableNames', 'Processed_pupil_area');


if test_on == 1
    subplot(1, 3, 1);
    plot(rel_pupil_time, Y, 'b.', 'MarkerSize', 6); hold on; % Original Data
    plot(rel_pupil_time, YY, 'r');                           % Hampel Filtered Data
    grid on
    ax=gca; grid(gca,'minor');
    ax.XTick = round(pupil_time(1,1)):5:round(pupil_time(end,1));
    xlabel('Time [s]')
    ylabel('Pupil area in pixels')
    legend('Original data','Filtered data')    
    title('Left eye data', 'Fontsize', 12);
end





%% Right pupil area
pupil_area = table2array(eye_right(:,5));
pupil_time = table2array(eye_right(:,2));

% pupil area
X = 1:length(pupil_time);        Y = pupil_area;
DX  = 3*median(X(2:end)-X(1:end-1))+3; 
DX  = 5*median(X(2:end)-X(1:end-1))+5; 
T   = 3;
% DX          = 1;                                % Window Half size
% T           = 3;                                % Threshold
Threshold   = 0.1;                              % AdaptiveThreshold
%hampel => self hampel function 'hampel_self'
[YY,I,Y0,LB,UB] = hampel_self(X,Y,DX,T,'Adaptive',Threshold);

rel_pupil_time = pupil_time - pupil_time(1,1);

% Add the column of the processed pupil area
eye_right = addvars(eye_right, YY, 'After', size(eye_right,2),...
    'NewVariableNames', 'Processed_pupil_area');


if test_on == 1
    subplot(1, 3, 2);
    plot(rel_pupil_time, Y, 'b.', 'MarkerSize', 6); hold on; % Original Data
    plot(rel_pupil_time, YY, 'r');                           % Hampel Filtered Data
    grid on
    ax=gca; grid(gca,'minor');
    ax.XTick = round(pupil_time(1,1)):5:round(pupil_time(end,1));
    xlabel('Time [s]')
    ylabel('Pupil area in pixels')
    legend('Original data','Filtered data')    
    title('Right eye data', 'Fontsize', 12);
end

%% 2) Filtered data - new eye preprocessing

pupil_area = table2array(proc_new_eye(:, 10));
pupil_time = table2array(proc_new_eye(:, 1));

% pupil area
X = 1:length(pupil_time);        Y = pupil_area;
DX  = 3*median(X(2:end)-X(1:end-1))+3; 
DX  = 5*median(X(2:end)-X(1:end-1))+5; 
T   = 3;
% DX          = 1;                                % Window Half size
% T           = 3;                                % Threshold
Threshold   = 0.1;                              % AdaptiveThreshold
%hampel => self hampel function 'hampel_self'
[YY,I,Y0,LB,UB] = hampel_self(X,Y,DX,T,'Adaptive',Threshold);

rel_pupil_time = pupil_time - pupil_time(1,1);

% Add the column of the processed pupil area
proc_new_eye = addvars(proc_new_eye, YY, 'After', size(proc_new_eye,2),...
    'NewVariableNames', 'Processed_pupil_area');

if test_on == 1
    subplot(1, 3, 3);
    plot(rel_pupil_time, Y, 'b.', 'MarkerSize', 6); hold on; % Original Data
    plot(rel_pupil_time, YY, 'r');                           % Hampel Filtered Data
    grid on
    ax=gca; grid(gca,'minor');
    ax.XTick = round(pupil_time(1,1)):5:round(pupil_time(end,1));
    xlabel('Time [s]')
    ylabel('Pupil area in pixels')
    legend('Original data','Filtered data')    
    title('Processed eye data', 'Fontsize', 12);
end


%% 3) Gaze_xy_data

%% Gaze X
pupil_area = table2array(gaze_xy_left(:, 5));
pupil_time = table2array(gaze_xy_left(:, 2));

% pupil area
X = 1:length(pupil_time);        Y = pupil_area;
DX  = 3*median(X(2:end)-X(1:end-1))+3; 
DX  = 5*median(X(2:end)-X(1:end-1))+5; 
T   = 3;
% DX          = 1;                                % Window Half size
% T           = 3;                                % Threshold
Threshold   = 0.1;                              % AdaptiveThreshold
%hampel => self hampel function 'hampel_self'
[YY,I,Y0,LB,UB] = hampel_self(X,Y,DX,T,'Adaptive',Threshold);

rel_pupil_time = pupil_time - pupil_time(1,1);

% Add the column of the processed gaze X
gaze_xy_left = addvars(gaze_xy_left, YY, 'After', size(gaze_xy_left,2),...
    'NewVariableNames', 'Processed_gaze_x');

if test_on == 1
    figure;
    subplot(1, 2, 1);
    plot(rel_pupil_time, Y, 'b.', 'MarkerSize', 6); hold on; % Original Data
    plot(rel_pupil_time, YY, 'r');                           % Hampel Filtered Data
    grid on
    ax=gca; grid(gca,'minor');
    ax.XTick = round(pupil_time(1,1)):5:round(pupil_time(end,1));
    xlabel('Time [s]')
    ylabel('Gaze X location in pixels')
    legend('Original data','Filtered data')    
    title('Gaze X', 'Fontsize', 12);
end

%% Gaze Y
pupil_area = table2array(gaze_xy_left(:, 6));
pupil_time = table2array(gaze_xy_left(:, 2));

% Gaze 
X = 1:length(pupil_time);        Y = pupil_area;
DX  = 3*median(X(2:end)-X(1:end-1))+3; 
DX  = 5*median(X(2:end)-X(1:end-1))+5; 
T   = 3;
% DX          = 1;                                % Window Half size
% T           = 3;                                % Threshold
Threshold   = 0.1;                              % AdaptiveThreshold
%hampel => self hampel function 'hampel_self'
[YY,I,Y0,LB,UB] = hampel_self(X,Y,DX,T,'Adaptive',Threshold);

rel_pupil_time = pupil_time - pupil_time(1,1);

% Add the column of the processed gaze Y
gaze_xy_left = addvars(gaze_xy_left, YY, 'After', size(gaze_xy_left,2),...
    'NewVariableNames', 'Processed_gaze_y');


if test_on == 1
    subplot(1, 2, 2);
    plot(rel_pupil_time, Y, 'b.', 'MarkerSize', 6); hold on; % Original Data
    plot(rel_pupil_time, YY, 'r');                           % Hampel Filtered Data
    grid on
    ax=gca; grid(gca,'minor');
    ax.XTick = round(pupil_time(1,1)):5:round(pupil_time(end,1));
    xlabel('Time [s]')
    ylabel('Gaze Y location in pixels')
    legend('Original data','Filtered data')    
    title('Gaze Y', 'Fontsize', 12);
end


%% Pupil original X and Y

%% Pupil X
pupil_area = table2array(gaze_xy_left(:, 3));
pupil_time = table2array(gaze_xy_left(:, 2));

% pupil area
X = 1:length(pupil_time);        Y = pupil_area;
DX  = 3*median(X(2:end)-X(1:end-1))+3; 
DX  = 5*median(X(2:end)-X(1:end-1))+5; 
T   = 3;
% DX          = 1;                                % Window Half size
% T           = 3;                                % Threshold
Threshold   = 0.1;                              % AdaptiveThreshold
%hampel => self hampel function 'hampel_self'
[YY,I,Y0,LB,UB] = hampel_self(X,Y,DX,T,'Adaptive',Threshold);

rel_pupil_time = pupil_time - pupil_time(1,1);

% Add the column of the processed Pupil X
gaze_xy_left = addvars(gaze_xy_left, YY, 'After', size(gaze_xy_left,2),...
    'NewVariableNames', 'Processed_pupil_x');

if test_on == 1
    figure;
    subplot(1, 2, 1);
    plot(rel_pupil_time, Y, 'b.', 'MarkerSize', 6); hold on; % Original Data
    plot(rel_pupil_time, YY, 'r');                           % Hampel Filtered Data
    grid on
    ax=gca; grid(gca,'minor');
    ax.XTick = round(pupil_time(1,1)):5:round(pupil_time(end,1));
    xlabel('Time [s]')
    ylabel('Pupil center X in pixels')
    legend('Original data','Filtered data')    
    title('Pupil center X', 'Fontsize', 12);
end

%% Pupil Y
pupil_area = table2array(gaze_xy_left(:, 4));
pupil_time = table2array(gaze_xy_left(:, 2));

% Pupil Y
X = 1:length(pupil_time);        Y = pupil_area;
DX  = 3*median(X(2:end)-X(1:end-1))+3; 
DX  = 5*median(X(2:end)-X(1:end-1))+5; 
T   = 3;
% DX          = 1;                                % Window Half size
% T           = 3;                                % Threshold
Threshold   = 0.1;                              % AdaptiveThreshold
%hampel => self hampel function 'hampel_self'
[YY,I,Y0,LB,UB] = hampel_self(X,Y,DX,T,'Adaptive',Threshold);

rel_pupil_time = pupil_time - pupil_time(1,1);

% Add the column of the processed Pupil Y
gaze_xy_left = addvars(gaze_xy_left, YY, 'After', size(gaze_xy_left,2),...
    'NewVariableNames', 'Processed_pupil_y');

if test_on == 1
    subplot(1, 2, 2);
    plot(rel_pupil_time, Y, 'b.', 'MarkerSize', 6); hold on; % Original Data
    plot(rel_pupil_time, YY, 'r');                           % Hampel Filtered Data
    grid on
    ax=gca; grid(gca,'minor');
    ax.XTick = round(pupil_time(1,1)):5:round(pupil_time(end,1));
    xlabel('Time [s]')
    ylabel('Pupil center Y in pixels')
    legend('Original data','Filtered data')    
    title('Pupil center Y', 'Fontsize', 12);
end






end

