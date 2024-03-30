clear; close all; clc;
p0 = 0.4;
d0 = 0.1:0.2:1;
p1 = 0.5;
d = 0:0.05:5;
figure
hold on;

f = @(d, p0, p1, d0)  (d < sqrt(2)).*0.4 + p1*(d >= sqrt(2)).*exp((1-d)/d0);
for i = 1:size(d0,2)
    
    plot(d,f(d, p0, p1, d0(i)), DisplayName=sprintf("d_0=%0.1f", d0(i)), LineWidth=3);
end
xlabel("d", FontSize=24)
ylabel("f(d)", FontSize=24)
title("f(d) vs d for varying values of d0", FontSize=26);
set(gca, "FontSize", 22);
ylim([0 0.45])
legend()
hold off;
