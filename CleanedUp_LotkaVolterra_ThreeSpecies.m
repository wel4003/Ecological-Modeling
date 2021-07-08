% Here, we use a matricial format to describe the ecological network of three species. 
% For parameters we need:
% mu = a 3x1 vector of the specific growth rates. In this case mu = [1; 0.2; 0.5];
% M = a 3x3 matrix of species interactions. 
% In this case M = [-0.5 -0.5 1; 0 -0.4 1; 0 0 -0.6];

% Using a generalized form of Lotka Volterra predator/prey equations,
% the ecosystem dynamics of these three species can be 
% expressed as: 
% dy = (mu + M*y).*y;

% This format works for any number of species, where an n species system
% needs an nx1 mu and an nxn M.

%% Build the vector of growth rates mu and the matrix of species-species
% interaction M, with self inhibition for each species

global mu;
global M;
global perturbation;

mu = [1; 0.2; 0.5];
M = [-0.5 -0.5 1; 0 -0.4 1; 0 0 -0.6]; 

%% Simulate the ecosystem before perturbation
% t = timepoint; y = starting population
perturbation = [0; 0; 0];
[t,y] = ode23(@volterraMatrixForm, [0 30], [0.01 0.01 0.01]);

figure(1);
subplot(4, 1, 1)
plot(t, y)
title('Ecosystem before pertubation')

%% Simulate the ecosystem during pertubation
finalYBeforePertubation =  y(end, :); %population at timepoint 100

% simulate perturbation 
perturbation = [-0.4; -0.4; -0.4];
[tAfter1,yAfter1] = ode23(@volterraMatrixForm, [30 32], finalYBeforePertubation);

figure(1);
subplot(4, 1, 2)
plot(tAfter1, yAfter1)
title('Ecosystem during pertubation')

%% Simulate the ecosystem after perturbation, add another perturbation to
% return to a different steady state

perturbation = [3; 0.4; 0.3];
[tAfter2,yAfter2] = ode23(@volterraMatrixForm, [32 80], yAfter1(end, :));

figure(1);
subplot(4, 1, 3)
plot(tAfter2, yAfter2)
title('Ecosystem after pertubation')

%% Before/after perturbation
tCombined = [t; tAfter1; tAfter2];
yCombined = [y; yAfter1; yAfter2];

figure(1);
subplot(4, 1, 4)
plot(tCombined, yCombined)
title('Ecosystem before/after pertubation')
legend({'Species A', 'Species B', 'Species C'})

%% Condensed figure before/after perturbation
figure(2)
plot(tCombined, yCombined)
newcolors = {'r', 'g', 'b'};
colororder(newcolors)
xline(30,'--k'); xline(32,'--k');
axis([25 40 0 7])
%xticklabels({'0','5','10','15'})
set(gca,'yticklabel',[], 'xticklabel',[])
title('Time Series Data','fontsize',14)
legend({'Species A', 'Species B', 'Species C'})
xlabel("Time",'fontsize',13)
ylabel("Microbe Abundance",'fontsize',13)
text(31, 5, {'Antibiotic' ; 'perturbation'}, 'HorizontalAlignment','center');

%% Growth rates
figure(3)
X = categorical({'Species A','Species B','Species C'});
X = reordercats(X,{'Species C','Species B','Species A'});
barh(X,mu);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize',14);
title('Growth \mu','fontsize',18);
xlim([0 1.1]);
xticks(0:0.5:1);
xticklabels({'0','0.5','1'});
xlabel('1/day');

%% Interaction matrix
figure(4)
xvalues = {'Species A','Species B', 'Species C'};
yvalues = {'Species A','Species B', 'Species C'};
h = heatmap(xvalues, yvalues, M);

colormap default
h.Title = 'Interactions M';
h.FontSize = 17;

%% Antibiotic perturbation effects
figure(5)
Ab = categorical({'Species A','Species B','Species C'});
Ab = reordercats(Ab,{'Species C','Species B','Species A'});
barh(Ab,perturbation);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel', a, 'fontsize',14);
title('Antibiotic Perturbation Effects','fontsize',18);
xlim([0 3.2]);
xticks(0:1:3.5);
xticklabels({'0','1','2','3'});
xlabel('1/day');

%% Lotka Volterra function

function dy = volterraMatrixForm(t,y)

global mu
global M
global perturbation;

% The ecosystem dynamics is much simpler in matrix format
% and it can be expanded to any number of species
dy = (mu + M*y + perturbation).*y;

% This is mathematically equivalent to the two species system
%     dy = [a * y(1) - b * y(1) * y(2); %prey
%          -c * y(2) + d * y(1) * y(2)]; %predator

end