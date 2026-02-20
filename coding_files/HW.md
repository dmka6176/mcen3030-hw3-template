# MCEN3030 Homework 3

## Problem 1

With the imported "yacht_hydrodynamics.csv" data, a linear regression can return the best fits of the parameters such that $\hat{y}=a_0 + a_1x_1 + a_2 x_2 + ... + a_6 x_6$. Running this regression, we can see the following parameter fits:
| Parameter | Best Fit Value |
|-----------|----------------|
|Residuary Constant | -19.237 |  
| Longitudinal position | 0.19384 |     
| Prismatic coefficient | -6.4194 |    
| Length-displacement ratio | 4.233 |     
| Beam-draught ratio | -1.7657 |     
| Length-beam ratio | -4.5164 |    
| Froude number | 121.67 |


## Problem 1

I have added a data set, "yacht_hydrodynamics.csv", to Canvas. Source: [https://doi.org/10.24432/C5XG7R](https://doi.org/10.24432/C5XG7R).

The variables are:
1. Longitudinal position of the center of buoyancy, adimensional.
2. Prismatic coefficient, adimensional.
3. Length-displacement ratio, adimensional.
4. Beam-draught ratio, adimensional.
5. Length-beam ratio, adimensional.
6. Froude number, adimensional.
7. Residuary resistance per unit weight of displacement, adimensional.

The key output variable is the "residuary resistance", which is essentially the resistance related to the boat creating waves and eddies. We will predict this variable based on a simple linear-regression analysis, fitting $\hat{y}=a_0 + a_1x_1 + a_2 x_2 + ... + a_6 x_6$.

You will use your ```fit_linear(Z,Y)``` code, with outputs ```A```, a column vector of the best fits for the parameters; ```E```, a column vector of residuals from the best fit for each data point, and ```R2```, the $R^2$ value of the prediction.

You will also create a script to drive this and post-process the results. Import the csv data and call the fitting function. Once you have the fitting parameters, calculate the residuary resistance per unit weight for "the cube boat", where all inputs are 1, based on your fit. ($x_1=x_2=x_3=...=1$.)


In the markdown file you create, report the values of the fit parameters in a table. Comment on which of the parameters are associated with an increase in the resistance and which are associated with a decrease in the resistance. Report the $R^2$ value of the fit and the residuary resistance for "the cube boat".


### Problem 1: extra credit opportunity

For 20% extra credit on this assignment: read about the "Variance Inflation Factor" on the course website. It turns out that the input variables in this data set are highly correlated. Write a function ```VIF_remove``` which takes in the input data (in this case, the first 6 columns of the data set) and then computes the VIF scores for each. In the case where any of the VIFs are larger than 10, remove the one with the highest score and output the pruned data set, printing something like "variable n removed from the data set". (Just remove one, and then you can re-run to see if additional ones should be removed). Discuss which variable(s) you removed in the writeup.

## Problem 2

Use the ```rheo_data.csv``` data set. 

We will fit this data set using three models: 
- "The Bingham Model": $\hat{y}_B = \tau_y + \eta x$, with two parameters to be fit: $\tau_y$ and $\eta$.
- "The Hershel-Bulkley Model": $\hat{y}_H = \tau_y + K x^n$, with three parameters to be fit: $\tau_y$, $K$, and $n$.
- "The Hershel-Bulkley Plus Model": $\hat{y}_P
= \tau_y+K_1 x + K_2 x^n$ with four parameters to be fit: $\tau_y$, $K_1$, $K_2$, and $n$.

"The yield stress" $\tau_y$ appears in all three models, but each model will fit a different value of $\tau_y$. Similarly, the values of $n$ may be different. Notice that the first model is linear, while the second and third are nonlinear.

You should write two functions and one script for this problem: 
- ```fit_linear(Z,Y)```... it's the same as the one from Problem 1.
- ```fit_nonlinear(x,y,model,seeds)``` with ```x``` and ```y``` being the input/output data, ```model``` being an anonymous function for the model, and ```seeds``` a column vector of initial guesses for the parameters. One output, ```A```, a column vector of the best fits for the parameters. This function should be written generally such that it can apply to any model. Tips below.
- Your script should define the modeling equations above (again, see tips below) and call the two fitting functions (the nonlinear one twice) to determine the best fits. Then, you will create a plot that includes the experimental data in discrete symbols (no connecting line) and the three fits with smooth lines (no discrete symbols). Your plot should include axis labels with units (x is in \[1/s\], y is in \[Pa\]), and a legend. Likely you should increase the font size for all labels and numbers because the default is almost always too small. The plot should be a "semilogx" plot -- log-scaling on the x-axis.


Tips for ```fit_nonlinear``` and the script that precedes it:
- The models may be defined with a vector of parameters, e.g.
    - In MATLAB: ```Hmodel = @(x,p) p(1) + p(2)*x.^p(3);```
    - In Python: ```Hmodel = lambda x, p: p[0] + p[1] * x**p[2]```
    - In Julia: ```Hmodel = (x, p) -> p[1] .+ p[2] .* x .^ p[3]```
- The benefit of this approach is that it can be used for models with 2,3,4,... any number of parameters. To build your ```Z``` matrix, you can preallocate based on the size of your ```x_data``` and ```length(seeds)```. Then use ```for i=1 to length(seeds)``` and then ```Z(:,i)``` to create column ```i``` based on the numerical partial derivatives.
- As part of this, you could define an ```H``` column vector that is zeros except for element ```i```, where it is ```h```. This is a nice way to "perturb" the parameters for your partial derivative calculations.
- You do not need to use a ```for``` loop to iterate through the values in ```x```. If ```x``` is a column vector, the modeling functions will return a column vector.
- You may "hard-code" ```h=10^-6``` and a maximum number of iterations of 100. You do not need to include a convergence condition or include any error messaging for when the system does not converge.


Include the parameter values and plot in the ```README.md``` markdown file.


An example figure:
![Experiments and fits to glass bead+silicone oil system](hanoglass.png)
