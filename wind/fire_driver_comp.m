clc; clear; close all;

% Parameters / initial condition
maxr = 1000;
maxt = 6;
p = [0.2,0.3,0.4];
n = 20;
w = [0,20,40];
a = 0.01;
theta = pi/3;
M_init = zeros(n,n);
M_init(10,10) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Initialize mean value matrix
M_mean = zeros(n,n,maxt,9);

for b=1:3
    for c=1:3
        M_mean(:,:,:,3*(b-1)+c) = propagate_fire(p(b),n,maxt,maxr,w(c),theta,a,M_init);
    end
end

fig = figure('Position',[10,10,700,900]);
set(gca,'FontSize',20)
for b=1:3
    for c=1:3
        k = 3*(b-1)+c;
        subplot(3,3,k,'Parent',fig);
        imagesc(M_mean(:,:,end,k));
        if b==1
            title('w = ' + string(w(c)));
        end
        if c==1
            yl = ylabel('p = ' + string(p(b)),'FontWeight','bold');
            yl.Position(1) = yl.Position(1) - 1;
        end
    end
end

h = axes(fig,'visible','off'); 
c = colorbar(h,'Position',[0.93 0.168 0.022 0.7]);
caxis(h,[0,1]);

saveas(fig,'paper_param_comp','png');

% fig = figure('Position',[10,10,700,900]);

% for c=1:3
%     k = 3*(c-1)+1;
%     subplot(3,3,k,'Parent',fig);
%     imagesc(M_mean(:,:,2,c+3));
%     if c==1
%         title('t = 2');
%     end
%     yl = ylabel('w = ' + string(w(c)),'FontWeight','bold');
%     xlabel('Tiles with 0.9+ value: ' + string(nnz(M_mean(:,:,2,c+3) >= 0.9)));
%     yl.Position(1) = yl.Position(1) - 1;
%     subplot(3,3,k+1,'Parent',fig);
%     imagesc(M_mean(:,:,4,c+3));
%     if c==1
%         title('t = 4');
%     end
%     xlabel('Tiles with 0.9+ value: ' + string(nnz(M_mean(:,:,4,c+3) >= 0.9)));
%     subplot(3,3,k+2,'Parent',fig);
%     imagesc(M_mean(:,:,6,c+3));
%     if c==1
%         title('t = 6');
%     end
%     xlabel('Tiles with 0.9+ value: ' + string(nnz(M_mean(:,:,6,c+3) >= 0.9)));
% end
% 
% h = axes(fig,'visible','off'); 
% c = colorbar(h,'Position',[0.93 0.168 0.022 0.7]);
% caxis(h,[0,1]);
% 
% saveas(fig,'paper_param_comp_likely','png');






fig = figure('Position',[10,10,800,550]);
colors = ["b" "r" "#9248db"];

hold on;
for c=1:3
    x = 0:6;
    y = zeros(1,7);
    y(1) = 1;
    for n=1:maxt
        y(n+1) = nnz(M_mean(:,:,n,c+3) >= 0.9);
    end
    plot(x,y,'-o','LineWidth',1.5,'Color',colors(c));
    text(x(end)-0.1,y(end)+0.8,'(' + string(x(end)) + ', ' + string(y(end)) + ')',...
        'HorizontalAlignment','right','Color',colors(c));
end
hold off;

a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',20)
set(gca,'XTickLabelMode','auto')   
set(gca,'YTickLabel',a,'fontsize',20)
set(gca,'YTickLabelMode','auto')
title('Counts of Tiles With Mean Values of 0.9+ Over Time for $p_0 = 0.3$', Interpreter='latex', FontSize=22);
xlabel('Time', FontSize=22, Interpreter='latex');
ylabel('Tiles with 0.9+ value', FontSize=22, Interpreter='latex');
legend('w = 0', 'w = 20', 'w = 40','Location','northwest','FontSize',10);

saveas(fig,'paper_param_comp_likely','svg');
