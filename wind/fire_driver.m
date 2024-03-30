clear; close all; clc;

DISPLAY_LOGS = false;

maxr = 1000;
maxt = 6;
p = 0.3;
n = 20;
w = 0;
a = 0.01;
theta = pi/3;
M_init = zeros(n,n);
M_init(10,10) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M_mean = propagate_fire(p,n,maxt,maxr,w,theta,a,M_init);
M_mean_2 = propagate_fire(p,n,maxt,maxr,40,pi/3,a,M_init);
M_mean_3 = propagate_fire(p,n,maxt,maxr,20,-pi/2,a,M_init);

if DISPLAY_LOGS
    disp('M_mean(:,:,end) =');
    disp(M_mean(:,:,end));
    w_xy = [w*cos(theta);w*sin(theta)];
end

% make_movie(M_mean, ...
% 'Fire propagation for p = 0.3, w = 40, theta = pi/3, a = 0.01', ...
% 'testmovie.mp4')
set(groot,'DefaultAxesFontSize',22)
fig = figure('Position',[10,10,900,250]);
subplot(1,3,1);
imagesc(M_mean(:,:,end));
title('$w = 0$', FontSize=24, Interpreter='latex');
xlabel('$x$', Interpreter='latex', FontSize=24);
ylabel('$y$', Interpreter='latex', FontSize=24);
subplot(1,3,2);
imagesc(M_mean_2(:,:,end));
title('$w = 40, \theta = \pi/3$', FontSize=24, Interpreter='latex');
xlabel('$x$', Interpreter='latex', FontSize=24);
ylabel('$y$', Interpreter='latex', FontSize=24);
subplot(1,3,3);
imagesc(M_mean_3(:,:,end));
title('$w = 20, \theta = -\pi/2$', FontSize=24,Interpreter='latex');
xlabel('$x$', Interpreter='latex', FontSize=24);
ylabel('$y$', Interpreter='latex', FontSize=24);
h = axes(fig,'visible','off');
c = colorbar(h,'Position',[0.93 0.168 0.022 0.7]);
caxis(h,[0,1]);
saveas(fig,'paper_basic_qual','svg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function make_movie(M_mean,title,filename)
    % Create movie showing fire evolution
    vidfile = VideoWriter(filename,'MPEG-4');
    open(vidfile);
    for k=1:maxt
        imagesc(M_mean(:,:,k));
        title(title);
        xlabel('$x$', Interpreter='latex');
        ylabel('$y$', Interpreter='latex');
        F(k) = getframe(gcf);
        writeVideo(vidfile,F(k));
    end
    close(vidfile);
end
