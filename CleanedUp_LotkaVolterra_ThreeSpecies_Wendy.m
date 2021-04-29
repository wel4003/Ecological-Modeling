% A two species predator prey dynamics in matrix format
% In this version we introduce a matricial formula to describe the ecological
% network. For parameters we need:
% mu - a 2x1 vector of the specific growth rates. In this case mu = [a; -c];
% M - a 2x2 matrix of species interaction. In this case M = [-e -b; d -f];

% The ecosystem dynamics is much simpler in matrix format
% dy = (mu + M*y).*y;
% This is mathematically equivalent to the previous version
%     dy = [a * y(1) - b * y(1) * y(2) - e * y(1) * y(1); %prey
%          -c * y(2) + d * y(1) * y(2) - f * y(2) * y(2)]; %predator

% This format works for any number of species.
% For example: a 3 species system needs a 3x1 mu and a 3x3 M and
% a 456 species system needs a 456x1 mu and a 456x456 M, but they can all
% use the same function volterraMatrixForm defined below!

% As in the previous model these are model parameters [units between the brackets]
% a - specific growth rate of prey [1/T]
% b - predation rate [predator/T]
% c - death rate of prey [1/T]
% d - growth rate of predator by eating prey [prey/T]

%% Change PREY death rate [b]

plot_index = 1;
global mu;
global M;
global perturbation;

a = 1;
c = 0.5;
b = 0.2

% build the vector of growth rates mu
% and the matrix of species-species interaction M, with self inhibition
mu = [a; b; c];
M = [-0.5 -0.5 1; 0 -0.4 1; 0 0 -0.6]; 

%% simulate the ecosystem before perturbation
% t = timepoint; y = start population
perturbation = [0; 0; 0];
[t,y] = ode23(@volterraMatrixForm, [0 30], [0.01 0.01 0.01]);

figure(1)
subplot(4, 1, 1)
plot(t, y)
title('Ecosystem before pertubation')

%% second time period (during pertubation)
finalYBeforePertubation =  y(end, :); %population at timepoint 100

% simulate perturbation 
perturbation = [-0.4; -0.4; -0.4];
[tAfter1,yAfter1] = ode23(@volterraMatrixForm, [30 60], finalYBeforePertubation);


figure(1)
subplot(4, 1, 2)
plot(tAfter1, yAfter1)
title('Ecosystem during pertubation')

%% third time period (after perturbation,add another perturbation to return to
% a different steady state)

perturbation = [3; 0.4; 0.3];
[tAfter2,yAfter2] = ode23(@volterraMatrixForm, [60 80], yAfter1(end, :));

figure(1)
subplot(4, 1, 3)
plot(tAfter2, yAfter2)
title('Ecosystem after pertubation')

%%
tCombined = [t; tAfter1; tAfter2];
yCombined = [y; yAfter1; yAfter2];

figure(1)
subplot(4, 1, 4)
plot(tCombined, yCombined)
title('Ecosystem before/after pertubation')
legend({'Species A', 'Species B', 'Species C'})

%%
drawnow; 
figure_filename = sprintf('Pred_Prey_matrix_a_%d_b_%0.2f_c_%d.png',a,b,c); 
saveas(figure(plot_index), figure_filename);
plot_index = plot_index + 1; 

%% Lotka Volterra function

function dy = volterraMatrixForm(t,y)

global mu
global M
global perturbation;

% the ecosystem dynamics is much simpler in matrix format
% and it can be expanded to any number of species
dy = (mu + M*y + perturbation).*y;
% This is mathematically equivalent to the two species system
%     dy = [a * y(1) - b * y(1) * y(2); %prey
%          -c * y(2) + d * y(1) * y(2)]; %predator

end



