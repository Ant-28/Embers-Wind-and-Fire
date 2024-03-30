clear; close all; clc;
M = readmatrix("data6.txt");


yi = 0.1:0.2:2.1;
xi = 0.0:4:20.0;
x_hell = 0.65:0.05:1.0;
y_hell = -0.4688 * x_hell + 1.3141;

X = M(:,1);
Y = M(:,2);
Z = max(M(:,3),0);
[Xi, Yi] = meshgrid(xi, yi);
Zi = griddata(X, Y, Z, Xi, Yi);

x_range = linspace(0, 20, 100);
y_range = ((sqrt(pi)*(sqrt(pi*x_range + 2))./sqrt(x_range)) - pi)/(2*pi);
y_range_2 = 0.166667*((0.000259574*sqrt(133573095*x_range + 51021164))./sqrt(x_range) - 3);
fig = figure('Position',[10,10,800,550]);

hold on;
contourf(Xi, Yi, Zi,30, HandleVisibility="off")
hcb = colorbar('eastoutside', FontSize=20);
ylabel(hcb, "$r_c$", Interpreter="latex");
ax = gca;
ax.FontSize = 20;
xlim([0 20])
ylim([0.1 2])
xlabel("$w$", FontSize=20, Interpreter="latex")
ylabel("$d_0$", FontSize=20, Interpreter="latex")

% plot(x_range, y_range,'--', Color='cyan', LineWidth = 3)
% plot(x_range, y_range_2,'--', Color='red', LineWidth = 3)
% plot(x_hell, y_hell,'--', Color='red', LineWidth = 3)
t1 = "$y^2 + y = \frac{1}{2 \pi x}$";
t2 =  "$y^2 + y = \frac{0.6}{2 \pi x}$"; 
ltxt = {t1, t2};
% legend(ltxt, Interpreter="latex", FontSize=16)
saveas(fig, 'resultat_final', 'svg')
