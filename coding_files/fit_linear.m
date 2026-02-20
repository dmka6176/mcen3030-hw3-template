function [A,Y_hat, E, R2] = fit_linear(Z,Y)

A = ((Z' * Z)\ Z' ) * Y
Y_hat = Z*A;
E = Y - Y_hat
Sr = 0;
St = 0;

avg = mean(Y)

for i = 1:length(Y);
Sr = Sr + (E(i))^2;
St = St + (Y(i) - avg)^2;
end

R2 = 1-Sr/St;

end
