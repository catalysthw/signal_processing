function decisionTemp = processing_trial(subject,feat,TimeDecision,useIMU,freestyleFlag,participantNumber)
%this function doesnt do subject comparisions as it will take a long time
%inreal time. Only with subject movement comparision is performed.
%freestyle is not using threshold values
if nargin==4
    freestyleFlag=1;
    participantNumber=[];%currently not used
elseif nargin==5
    participantNumber=[];%currently not used
end
if isempty(participantNumber)
    participantNumber=1;
end
%name=subject(1).ID;
movement=unique(cell2mat({subject.movement}));%also can use cell2mat({subject.movement})
% % subjectID=unique({subject.ID});
meanSet={subject.meanfeat};
deviationSet={subject.covfeat};
threshAll=num2cell(cell2mat({subject.dist}));

% decide the decision of the sample
% compare with other motions
% with the distance smaller than the threshold, pick the minimum
decisionTemp = 100000*ones(1,2); % store one decision, the three is distance, motion, subject
disMatrix=zeros(length(movement),TimeDecision);
for mm = 1:length(movement)  % moiton type
    %         for ss = 1:size(subjectID,1)  % subject
    ss=1;
    if ~useIMU
        disMatrix(mm,TimeDecision) = abs((meanSet{mm} - feat)*...
            (inv(deviationSet{mm}))*(meanSet{mm} - feat)')
    else
        disMatrix(mm,TimeDecision) = abs((meanSet{mm} - feat)*...
            (pinv(deviationSet{mm}))*(meanSet{mm} - feat)')
    end
    
%     disp(disMatrix(mm,TimeDecision));
     if ~freestyleFlag
        if (disMatrix(mm,TimeDecision) < (threshAll{mm}*9))
            if decisionTemp(1,1) > disMatrix(mm,TimeDecision)
                decisionTemp(1,1) = disMatrix(mm,TimeDecision);
                decisionTemp(1,2) = movement(mm);
                %                 decisionTemp(1,3) = participantNumber;
                %             else
                %                 decisionTemp(1,1) = 10000;
                %                 decisionTemp(1,2) = 0;
                %                 decisionTemp(1,3) = participantNumber;
            end
        else
            decisionTemp(1,2) = 0;
            %             decisionTemp(1,3) = participantNumber;
        end
     else
            if decisionTemp(1,1) > disMatrix(mm,TimeDecision)
                decisionTemp(1,1) = disMatrix(mm,TimeDecision);
                decisionTemp(1,2) = movement(mm);
                %                 decisionTemp(1,3) = participantNumber;
                %             else
                %                 decisionTemp(1,1) = 10000;
                %                 decisionTemp(1,2) = 0;
                %                 decisionTemp(1,3) = participantNumber;
            end
    end
    
end

end