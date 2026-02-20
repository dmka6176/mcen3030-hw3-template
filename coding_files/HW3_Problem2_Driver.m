clc
close all
clear


T = readtable('rheo_data.csv');
x = T{:,1};
y = T{:,2}; 

Z = ones(length(x),2);
Z(:,2) = x;
[linear_param,Y_B, ~, R2] = fit_linear(Z,y)


%%calculating Y_H
model_H = @(x,P) P(1) + P(2)*x.^(P(3));

seeds = [100; 10; 0.5]
[Y_H, Z, D,da] = fit_nonlinear(x,y,model_H,seeds)

X_smooth =linspace(0,20,100);
Y_smooth = zeros(size(X_smooth));
for i = 1:100
    Y_smooth(i) = model_H(X_smooth(i),Y_H);
end

%Calculating R2
Sr = 0;
St = 0;

avg = mean(y);
for i = 1:length(y);
Sr = Sr + (y(i)-model_H(i,Y_H)).^2;
St = St + (y(i) - avg).^2;
end

R2_H = 1-Sr/St;


%%HB_plus model

model_P = @(x,H) H(1) + H(2).*x + H(3).*x.^(H(4))
seeds_P = [10; 10; 100; 0.5;]

[Y_P,Z_P, D_P, dA_P] = fit_nonlinear(x,y,model_P,seeds_P);

YP_smooth = zeros(size(X_smooth));
for i = 1:100
    YP_smooth(i) = model_P(X_smooth(i),Y_P);
end


%%YB_Smooth
Y_B_Smooth = zeros(size(X_smooth));
for i = 1:length(Y_B_Smooth)
    Y_B_Smooth(i) = linear_param(1)+X_smooth(i)*linear_param(2);
end

% fprintf("Value of Ty")
% disp(Y_B(1))
% 
% fprintf("Value of n")
% disp(Y_B(4)-Y_B(3))


disp(Y_H)

fprintf("Linear_param\n")
disp(linear_param)

fprintf("Y_h\n")
disp(Y_H)

fprintf("Y_P\n")
disp(Y_P)


figure(1)
%%formatting the axis:

% --- Axis appearance ---
tick_direction = 'in';         % 'in' or 'out'
tick_length    = [0.02 0.02];   % [x y]
axis_width     = 3;           % axis thickness
font_size      = 50;

ax = gca;

ax.TickDir   = tick_direction;
ax.TickLength = tick_length;
ax.LineWidth = axis_width;
ax.FontSize  = font_size;
set(ax, 'TickLabelInterpreter','latex')



semilogx(x,y,'o','MarkerEdgeColor','k','MarkerFaceColor','k')
hold on
plot (X_smooth,Y_B_Smooth,'LineWidth',1.3);
plot(X_smooth,Y_smooth,'LineWidth',1.3);
plot(X_smooth,YP_smooth,'LineWidth',1.3);
theme light

% Display the R-squared value on the plot

xlabel('Shear Rate [$s^{-1}$]','Interpreter','latex','FontSize',18);
ylabel('Shear Stress [Pa]','Interpreter','latex','FontSize',18);
legend('Experimental Data', 'Bingham Model $\hat{y}_B$','Hershel-Bulkley $\hat{y}_H$','Hershel-Bulkley Plus $\hat{y}_P$','Interpreter','latex',Location='best', Fontsize=15)
saveas(figure(1),"Shear_Stress_vs_Shear_Rate.png")
