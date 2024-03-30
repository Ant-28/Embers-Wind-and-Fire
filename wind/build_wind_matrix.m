function wind = build_wind_matrix(w,theta,a)
    % Get Cartesian form of wind vector
    w_xy = [w*cos(theta);w*sin(theta)];
    size = 3;
    wind = zeros(size);

    % Loop through wind matrix
    for i=1:size
        for j=1:size
            t_ij = [j-2; 2-i];
            if i == 2 && j == 2
                continue;
            end
            % Add constants to tiles roughly in the direction of wind
            wind(i,j) = compute_wind_entry(t_ij,w_xy,a);
        end
    end
end

function wind_entry = compute_wind_entry(t_ij,w_xy,a)
    wind_entry = max(0,a*dot(w_xy,t_ij)/norm(t_ij));
end