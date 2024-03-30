function M_new = propagate_onestep(M,p,wind)
    M_dims = size(M);
    M_new = M;

    % Loop through 2d array M to find fires to propagate
    for i=1:M_dims(1)
        for j=1:M_dims(2)
            if M(i,j) == 1
                p_update = max(0,min(1,max(0,p*ones(3) + wind + (rand(3)-0.5)./25)));
                % If the element at i,j has a fire, update all neighbors
                M_new = update_element(M_new,i-1,j-1,p_update(1,1));
                M_new = update_element(M_new,i-1,j,p_update(1,2));
                M_new = update_element(M_new,i-1,j+1,p_update(1,3));
                M_new = update_element(M_new,i,j-1,p_update(2,1));
                M_new = update_element(M_new,i,j+1,p_update(2,3));
                M_new = update_element(M_new,i+1,j-1,p_update(3,1));
                M_new = update_element(M_new,i+1,j,p_update(3,2));
                M_new = update_element(M_new,i+1,j+1,p_update(3,3));
            end
        end
    end
end

function M_new = update_element(M,i,j,p)
    M_dims = size(M);
    M_new = M;
    
    % Check that the element to update is not out of bounds
    if i < 1 || j < 1 || i > M_dims(1) || j > M_dims(2)
        return
    end

    % If element has no fire yet, and if a randomly generated number in
    % (0,1) falls below p, then the element catches fire.
    if M_new(i,j) == 0 && rand() < p
        M_new(i,j) = 1;
    end
end