clear; close all; clc;
p0 = 0.4;
d0 = 1;
p1 = 0.4;
d = 0:0.05:5;
figure
hold on;

f = @(d, p0, p1, d0)  (d < sqrt(2)).*0.4 + p1*(d >= sqrt(2)).*exp((1-d)/d0);

    
    plot(d,f(d, p0, p1, d0), DisplayName=sprintf("p_1=%0.1f, d_0=%0.1f", p1, d0), LineWidth=3);

xlabel("d", FontSize=24)
ylabel("f(d)", FontSize=24)
yline(0.01, DisplayName="f(d)=0.01", Color="red", LineWidth=3)
title("f(d) vs d for p1 = 0.4, d0 = 1", FontSize=26);
set(gca, "FontSize", 22);
legend()
hold off;
