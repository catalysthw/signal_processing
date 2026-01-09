% % xx = unique(x);       % temp vector of vals
% % x = sort(x);          % sorted input aligns with temp (lowest to highest)
% % t = zeros(size(xx)); % vector for freqs
% % % frequency for each value
% % for i = 1:length(xx)
% %     t(i) = sum(x == xx(i));
% % end
tic
data=participants(6).TrainingData';
% data=[data; data; data; data];
labels=participants(6).TrainingTargets';
% labels=[labels; labels;labels;labels];
t_data=(data(1:20,:));
k=9;
[predicted_labels,prob,nn_index] = KNN_(k,data,labels,t_data,[]);
% [predicted_labels,nn_index] = KNN(k,data,labels,t_data,[]);
toc


data=cell2mat({subject.TrainingData}');
labels=cell2mat({subject.TrainingTargets}');