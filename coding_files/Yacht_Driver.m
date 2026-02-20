clc
close all
clear

T = readtable('yacht_hydrodynamics.csv');

Long_pos = T{:,1};
Prism_coef = T{:,2};
L_D = T{:,3};
B_draught = T{:,4};
L_B = T{:,5};
F = T{:,6};

%key output
R = T{:,7};
Y = R;
Z=ones(length(R),7)
Z(:,2:7) = T{:,1:6};

[A,~, E, R2] = fit_linear(Z,Y)

%A now stores the fitted parameters of the regression, now calculate cube
%boat
x = ones(7,1);
cubeBoat = A' * x

Parameter_Values =A;
Parameter = ["Residuary Constant";"Longitudinal position";"Prismatic coefficient";"Length-displacement ratio";"Beam-draught ratio";"Length-beam ratio";"Froude number"]
R = table(Parameter, Parameter_Values)

% fprintf('Values of A\n')
% disp(A)

for i =1:7
    if A(i) < 0
        fprintf('Variable %d responsible for a decrease in resistance\n',i)
    else 
        fprintf('Variable %d responsible for an increase in resistance\n',i)
    end
end

