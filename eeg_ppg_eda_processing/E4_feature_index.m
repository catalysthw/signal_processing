function [fts_ind] = E4_feature_index(m, m_overlap, x, sf)


% Step 
step = m - m_overlap;
N = size(x,1);
N_epoch = N/(step*sf*60);

% Preparation of index 
int  = fix(N_epoch);        frac = N_epoch - int;

% Start/End indexes of E4 dataset for feature extraction 
fts_ind = zeros(int, 2);

for i = 1:int
    fts_ind(i,1) = (step*sf*60)*(i-1) + 1;
    fts_ind(i,2) = (step*sf*60)*i;
end

if frac < 0.2
    fts_ind(end,2) = N;
else
    new_ind = [(step*sf*60)*int+1, N];
    fts_ind = [fts_ind; new_ind];
end

end

