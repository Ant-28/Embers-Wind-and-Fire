clear; close all; clc;

maxr = 100000;
maxt = 1;
p = 0.3;
w = 20;
a = 0.01;
theta = pi/3;

% Case 1
% n = 3;
% M_init = zeros(n,n);
% M_init(2,2) = 1;

% Case 2
n = 6;
M_init = zeros(n,n);
M_init(3:4,3:4) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Using: p=' + string(p) + ', t=' + string(maxt) + ', r=' + string(maxr));
disp('       w=' + string(w) + ', theta=' + string(theta)' + ', a=' + string(a));

disp('M_init =');
disp(M_init);

M_mean = propagate_fire(p,n,maxt,maxr,w,theta,a,M_init);

disp('M_mean(:,:,end) =');
disp(M_mean(:,:,end));

w_xy = [w*cos(theta);w*sin(theta)];

% Case 1
% M_expected = ones(n,n) * p;
% M_expected(1,1) = p + cwe([-1;1],w_xy,a);
% M_expected(1,2) = p + cwe([0;1],w_xy,a);
% M_expected(1,3) = p + cwe([1;1],w_xy,a);
% M_expected(2,2) = 1;
% M_expected(2,3) = p + cwe([1;0],w_xy,a);

% Case 2
M_expected = zeros(n,n);
M_expected(2:5,2:5) = ones(n-2,n-2) * p;
M_expected(2,2) = 1 - (1-p-cwe([-1;1],w_xy,a));
M_expected(2,3) = 1 - ((1-p-cwe([0;1],w_xy,a)) * (1-p-cwe([-1;1],w_xy,a)));
M_expected(2,4) = 1 - ((1-p-cwe([0;1],w_xy,a)) * (1-p-cwe([1;1],w_xy,a)));
M_expected(2,5) = p + cwe([1;1],w_xy,a);
M_expected(3,2) = 1 - ((1-p-cwe([-1;1],w_xy,a)) * (1-p));
M_expected(3,5) = 1 - ((1-p-cwe([1;0],w_xy,a)) * (1-p-cwe([1;1],w_xy,a)));
M_expected(4,5) = 1 - ((1-p-cwe([1;0],w_xy,a)) * (1-p));
M_expected(4,2) = 2*p-p^2;
M_expected(5,3) = 2*p-p^2;
M_expected(5,4) = 2*p-p^2;
M_expected(3:4,3:4) = 1;

disp('M_expected =');
disp(M_expected);

function wind_entry = cwe(t_ij,w_xy,a)
    wind_entry = max(0,a*dot(t_ij,w_xy)/norm(t_ij));
end