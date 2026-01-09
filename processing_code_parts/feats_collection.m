function [p_delta] = feats_collection(x, x_data, band_name, opts)


f_ha = jfeeg('ha', x);                  % Hjorth activity
f_hm = jfeeg('hm', x);                  % Hjorth mobility
f_hc = jfeeg('hc', x);                  % Hjorth complexity
f_me = jfeeg('me', x);                  % Mean energy
f_sh = jfeeg('sh', x);                  % Shannon Entropy
f_le = jfeeg('le', x);                  % Log Energy Entropy
f_1d = jfeeg('n1d', x);                 % Normalized 1st difference
f_2d = jfeeg('n2d', x);                 % Normalized 2nd difference
f_delta = jfeeg('bpd', x_data, opts);        % Band power
f_delta_r = jfeeg('bpd_r', x_data, opts);    % Relative band power

p_delta = [mean(x), var(x), skewness(x), kurtosis(x), f_ha, f_hm, f_hc, f_me,...
    f_sh, f_le, f_1d, f_2d, f_delta, f_delta_r];

feature_names = {'mean', 'variance', 'skewness', 'kurtosis', 'Hjorth activity', 'Hjorth mobility',...
    'Hjorth complexity', 'mean energy', 'Shannon entropy', 'Log energy entropy',...
    'Normalized 1st diff', 'Normalized 2nd diff', 'Band power', 'Relative band power'};

headers = {};
for i = 1:length(p_delta)
    header_i = strcat(band_name, feature_names{i});
    headers = [headers, header_i];
end

p_delta = array2table(p_delta, 'VariableNames', headers);


end

