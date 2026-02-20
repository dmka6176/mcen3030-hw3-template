function [Y_hat,Z, D, dA] = fit_nonlinear(X,Y, model, seeds)

%ls = zeros(length(seeds));
Y_hat = zeros(size(Y));
guess = seeds;
guess_h = seeds;

h=10^-6;

Z = zeros(length(Y),length(seeds));
D = zeros(size(Y));

for j =1 : 100  %%number of total iterations
    for i = 1 : length(Y);
        Y_hat(i) = model(X(i),guess);
        D(i) = Y(i) - Y_hat(i);
    end

  %filling the Z matrix
 for i = 1: length(X)
     for k = 1:length(seeds)
         guess_h = guess;
       guess_h(k) = guess(k) + h;
       Z(i,k) = (model(X(i),guess_h) - model(X(i),guess))/h;
         %calculates the derivative
     end
 end

dA = (Z'*Z)\(Z'*D);
    guess = guess + dA;
end
Y_hat = guess;
end

