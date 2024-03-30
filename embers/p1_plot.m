clear; close all; clc;
p0 = 0.4;
d0 = 0.5;
p1 = 0:0.2:1;
d = 0:0.05:5;
figure
hold on;

f = @(d, p0, p1, d0)  (d < sqrt(2)).*0.4 + p1*(d >= sqrt(2)).*exp((1-d)/d0);
for i = 1:size(p1,2)
    
    plot(d,f(d, p0, p1(i), d0), DisplayName=sprintf("p_1=%0.1f", p1(i)), LineWidth=3);
end
xlabel("d", FontSize=24)
ylabel("f(d)", FontSize=24)
title("f(d) vs d for varying values of p1", FontSize=26);
set(gca, "FontSize", 22);
legend()
hold off;
