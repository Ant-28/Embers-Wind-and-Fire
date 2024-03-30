function M_mean = propagate_fire(p,n,maxt,maxr,w,theta,a,M_init)
    % Initialize mean value matrix
    M_mean = zeros(n,n,maxt);
    
    % Initialize wind matrix
    wind = build_wind_matrix(w,theta,a);
    
    for r=1:maxr
        % Set initial condition for the current realization
        M = M_init;
        % Generate each state based on the previous state
        for i=1:maxt
            M = propagate_onestep(M,p,wind);
            M_mean(:,:,i) = M_mean(:,:,i) + M;
        end
    end
    
    % Normalize mean
    M_mean = M_mean/maxr;
end