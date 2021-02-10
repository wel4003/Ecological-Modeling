% x: prey population, y: predator population
% x and y are both functions of time
% dx/dt = ax - bxy
    % defines how the population of prey changes in relation to
    % the predator and prey populations
    % ax is positive and defines growth
    % -bxy is negative and defines death
% dy/dt = cxy - dy
    % defines the change in the predator population
    % -dy is negative and determines predator population decay
    % cxy is positive and defines growth
%% Joao's notes
% model parameters [units between the brackets]
% a - specific growth rate of prey [1/T]
% b - predation rate [predator/T]
% c - death rate of prey [1/T]
% d - growth rate of predator by eating prey [prey/T]



%% Change PREY death rate [b]

plot_index = 1;
global a
global b
global c
global d

a = 1;
%b = 0.05;
c = 1;
d = 0.02;

for b = 0:0.2:1
        [t,y] = ode23(@volterra, [0 20], [10 10]);

        figure(plot_index)

        plot(t,y);
        title('Predator/Prey Populations Over Time');
        xlabel('t');
        ylabel('Population');
        legend('Prey-Rabbit','Predators-Fox','Location','North');
        drawnow; %J added this command to make sure the figure shows
        
        % changed the b and d formats from %d to %0.2f 
        % which is a floating-point number with 2 decimal places
        figure_filename = sprintf('Pred_Prey_a_%d_b_%0.2f_c_%d_d_%0.2f.png',a,b,c,d); %J added semicolumn
        saveas(figure(plot_index), figure_filename);
        %J: updating the plot_index needs to come after saving the figure
        % otherwise the saveas saves and empty figure.
        plot_index = plot_index + 1; %J: added semicolumn
end

%% PREY death rate constant, change PREDATOR death rate

%plot_index = 1 omitted this to keep the previous figures open
    global a
    global b
    global c
    global d
    
    a = 1;
    b = 0.05;
    c = 1;
    %d = 0.02;

for d = 0:0.2:1
        [t,y] = ode23(@volterra, [0 20], [10 10]);

        figure(plot_index)

        plot(t,y);
        title('Predator/Prey Populations Over Time');
        xlabel('t');
        ylabel('Population');
        legend('Prey-Rabbit','Predators-Fox','Location','North');
        
        % changed the b and d formats from %d to %0.2f 
        % which is a floating-point number with 2 decimal places
        figure_filename = sprintf('Pred_Prey_a_%d_b_%0.2f_c_%d_d_%0.2f.png',a,b,c,d); %J added semicolumn
        saveas(figure(plot_index), figure_filename)
        plot_index = plot_index + 1; %J must come after saveas command
end


function dy = volterra(t,y)  

    global a
    global b
    global c
    global d

   % Joao's note: added semicolumn to suppress output
   % during simulation
    dy = [a * y(1) - b * y(1) * y(2); %prey
         -c * y(2) + d * y(1) * y(2)]; %predator
 
end
