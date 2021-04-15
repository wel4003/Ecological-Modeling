% A two species predator prey dynamics in matrix format
% In this version we introduce a matricial for to describe the ecological
% network. Instead of the for parameters we need:
% mu - a 2x1 vector of the specific growth rates. In this case mu = [a; -c];
% M - a 2x2 matrix of species interaction. In this case M = [-e -b; d -f];

% the ecosystem dynamics is much simpler in matrix format
% dy = (mu + M*y).*y;
% This is mathematically equivalent to the previous version
%     dy = [a * y(1) - b * y(1) * y(2) - e * y(1) * y(1); %prey
%          -c * y(2) + d * y(1) * y(2) - f * y(2) * y(2)]; %predator
% It is not only much simpler but it now works for any number of species.
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
global mu
global M

a = 1;
c = 0.5;


b = 0.2
%for b = 0:0.2:1
% build the vector of growth rates mu
% and the matrix of species-species interaction M
mu = [a; b; c];
%M = [0 -1 1; 0 0 1; 0 0 0]; %original
M = [-0.5 -0.5 1; 0 -0.4 1; 0 0 -0.6]; %add in self inhibition

% simulate the ecosystem before perturbation
[t,y] = ode23(@volterraMatrixForm, [0 100], [0.01 0.01 0.01]);

%%
figure(1)
subplot(3, 1, 1)
plot(t, y)
title('Ecosystem before pertubation')

finalYBeforePertubation =  y(end, :);
%yAfterPertubation =  finalYBeforePertubation * 0.1;
yAfterPertubation =  finalYBeforePertubation .* [1 0.1 1];

% simulate perturbation that decreases population by 90%
[tAfter,yAfter] = ode23(@volterraMatrixForm, [100 200], yAfterPertubation);

figure(1)
subplot(3, 1, 2)
plot(tAfter, yAfter)
title('Ecosystem after pertubation')

%
tCombined = [t; tAfter];
yCombined = [y; yAfter];

figure(1)
subplot(3, 1, 3)
plot(tCombined, yCombined)
title('Ecosystem before/after pertubation')
legend({'Species A', 'Species B', 'Species C'})



% Species B is growing exponentially quite fast, because it's helped by
% A. C is crashing down because it has a negative growth rate and no
% other species to help it. In this case it's better to look at the
% population numbers in log scale.

% Wendy: Once the self interaction of Species A is fixed, the greater negative
% self interaction Species B has, the sooner it reaches equilibrium. Species C
% will always be crashing down to extinction with a negative growth rate along
% with self inhibition. The greater the self inhibition, the faster it
% crashes down and goes extinct. Although once it when C's self inhibition is
% in between -0.5 and -1, it seems like C briefly makes a come back and
% then continues to crash down.

drawnow; %J added this command to make sure the figure shows

% changed the b and d formats from %d to %0.2f
% which is a floating-point number with 2 decimal places
figure_filename = sprintf('Pred_Prey_matrix_a_%d_b_%0.2f_c_%d.png',a,b,c); %J added semicolumn
saveas(figure(plot_index), figure_filename);
%J: updating the plot_index needs to come after saving the figure
% otherwise the saveas saves and empty figure.
plot_index = plot_index + 1; %J: added semicolumn


%% PREY death rate constant, change PREDATOR death rate
% I deleted this example to keep it simple.

function dy = volterraMatrixForm(t,y)

global mu
global M

% the ecosystem dynamics is much simpler in matrix format
% and it can be expanded to any number of species
dy = (mu + M*y).*y;
% This is mathematically equivalent to the two species system
%     dy = [a * y(1) - b * y(1) * y(2); %prey
%          -c * y(2) + d * y(1) * y(2)]; %predator

end
