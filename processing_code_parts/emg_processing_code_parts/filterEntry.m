function [name,code] = filterEntry(Path,ID,movements,algorithm)
%examples
% filterEntry('C:\Users\aprad\Documents\MATLAB\New folder\DynMyoCtr_running\data',[],[],[])

participants=[];
% % movements=[10,6];
% % l=[{participants.movements}]
% % [a,b]=ismember(movements, cell2mat(l(2)))

load(fullfile(Path,'Database.mat'));
%movements
switch(nargin)
    case 1
        if isempty(movements) && isempty(algorithm)
        movements=[2,3,4,10];
        algorithm=[];
        end
    case 2
        movements=[];
        algorithm=[];
    case 3
        algorithm=[];
    case 4
        if isempty(movements)
            movements=[];
        end
        if isempty(algorithm)
            algorithm=[];
        end
end
if ~isempty(ID)
    if ismember(ID,[{participants.participantData}])
        [logic,ID_first]=ismember(ID,[{participants.participantData}]);
%         algorithm
        %     ID_index =strcmp({participants.participantData},ID);
        if isempty(movements)
            movements=participants(ID_first).movements;
        end
        if isempty(algorithm)
            algorithm=participants(ID_first).algorithm;
        end
    end
else
    ID={participants.participantData};
    if isempty(movements)
        movements=[2,3,4,10];
    end
    if isempty(algorithm)
        algorithm=1;
    end
end
i=1;
c=0;
for j=1:length(participants)
    for i=1:length(movements)
        index =[find(participants(j).TrainingTargets == movements(i))];
        l=[{participants(j).movements}];
%         all(ismember(movements, cell2mat(l)))
%         participants(j).algorithm
%         algorithm
%         all(ismember(participants(j).participantData,ID))
        if all(ismember(movements, cell2mat(l))) && participants(j).algorithm == algorithm && all(ismember(participants(j).participantData,ID))
            %if ~isempty(index)
            c=c+1;
            newset(:,:)=participants(j).TrainingData(:,index);
            newlabel(:,:)=participants(j).TrainingTargets(:,index);
            subject(c).TrainingData=(newset');
            subject(c).TrainingTargets=(newlabel');
            subject(c).ID=participants(j).participantData;
            subject(c).code=participants(j).code;
            subject(c).movement = movements(i);
            subject(c).Coeff = participants(j).Coeff;
            subject(c).classobj = participants(j).classobj;
% %             subject(c).meanfeat(1,:)= round(participants(j).meanfeat(movements(i),:),4);
% %             subject(c).covfeat(:,:,1)=round(participants(j).covfeat(:,:,movements(i)),4);
% %             subject(c).dist(1)=round(participants(j).dist(movements(i)),4);
            subject(c).SlNo=participants(j).SlNo;
        end
        index=[];
        newset=[];
        newlabel=[];
    end
end
code=movements;%works for verify
%code=movements;%should work for both
if length(unique([{subject.ID}],'stable'))==1
    name=unique([{subject.ID}],'stable');
else
    name='Identify Mode';
end
% 'C:\Users\aprad\Documents\MATLAB\DynMyoCtr_running\data\Database.mat'
save(fullfile(Path,'sub.mat'),'subject')
% 
% participants(elements) = [];
%  save(Path,'participants','runPath')
end


