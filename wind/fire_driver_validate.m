clear; close all; clc;

% Change this variable to change the case to validate
CASE = 1;

% Common parameters
maxr = 100000;
maxt = 1;
p_0 = 0.3;
w = 20;
a = 0.01;
theta = pi/3;

% Cartesian representation of wind vector
w_xy = [w*cos(theta);w*sin(theta)];

if CASE == 1
    % Case 1 validation, 3x3
    n = 3;
    M_init = zeros(n,n);
    M_init(2,2) = 1;
    M_expected = ones(n,n) * p_0;
    M_expected(1,1) = p_0 + cwe([-1;1],w_xy,a);
    M_expected(1,2) = p_0 + cwe([0;1],w_xy,a);
    M_expected(1,3) = p_0 + cwe([1;1],w_xy,a);
    M_expected(2,2) = 1;
    M_expected(2,3) = p_0 + cwe([1;0],w_xy,a);
else
    % Case 2 validation, 6x6
    n = 6;
    M_init = zeros(n,n);
    M_init(3:4,3:4) = 1;
    M_expected = zeros(n,n);
    M_expected(2:5,2:5) = ones(n-2,n-2) * p_0;
    M_expected(2,2) = 1 - (1-p_0-cwe([-1;1],w_xy,a));
    M_expected(2,3) = 1 - ((1-p_0-cwe([0;1],w_xy,a)) * (1-p_0-cwe([-1;1],w_xy,a)));
    M_expected(2,4) = 1 - ((1-p_0-cwe([0;1],w_xy,a)) * (1-p_0-cwe([1;1],w_xy,a)));
    M_expected(2,5) = p_0 + cwe([1;1],w_xy,a);
    M_expected(3,2) = 1 - ((1-p_0-cwe([-1;1],w_xy,a)) * (1-p_0));
    M_expected(3,5) = 1 - ((1-p_0-cwe([1;0],w_xy,a)) * (1-p_0-cwe([1;1],w_xy,a)));
    M_expected(4,5) = 1 - ((1-p_0-cwe([1;0],w_xy,a)) * (1-p_0));
    M_expected(4,2) = 2*p_0-p_0^2;
    M_expected(5,3) = 2*p_0-p_0^2;
    M_expected(5,4) = 2*p_0-p_0^2;
    M_expected(3:4,3:4) = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Using: p_0=' + string(p_0) + ', t=' + string(maxt) + ', r=' + string(maxr));
disp('       w=' + string(w) + ', theta=' + string(theta)' + ', a=' + string(a));

disp('M_init =');
disp(M_init);

M_mean = propagate_fire(p_0,n,maxt,maxr,w,theta,a,M_init);

disp('M_mean(:,:,end) =');
disp(M_mean(:,:,end));

disp('M_expected =');
disp(M_expected);

% Create figure for relative error
fig = figure('Position',[10,10,630,530]);
err = abs(M_mean(:,:,end)-M_expected) ./ M_expected;
err(isnan(err)) = 0;
disp(err);
imagesc(err);
title('Error matrix, case ' + string(CASE), 'FontSize', 14);
xlabel('i', 'FontSize', 14);
ylabel('j', 'FontSize', 14);
xticks(0:1:n);
yticks(0:1:n);
ax = gca(fig);
ax.FontSize = 14;
c = colorbar('FontSize', 14);
caxis([0,0.01]);
c.Label.String = 'Relative Error';
saveas(fig,'paper_validation_' + string(CASE) + '_error','svg');

function wind_entry = cwe(t_ij,w_xy,a)
    wind_entry = max(0,a*dot(t_ij,w_xy)/norm(t_ij));
end