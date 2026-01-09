function closest = closest_value(value, array)
    % Compute absolute differences
    differences = abs(array - value);
    
    % Find the index of the minimum difference
    [~, idx] = min(differences);
    
    % Get the closest value
    closest = array(idx);
end