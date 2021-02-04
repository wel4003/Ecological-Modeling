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


%% Keep PREDATOR death rate constant, change PREY death rate
% this is just an example comment

plot_index = 1
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
        
        %plot_index = plot_index + 1
        %figure_filename = sprintf('Pred_Prey_a_%d_b_%d_c_%d_d_%d.png',a,b,c,d)
        %saveas(figure(plot_index), figure_filename)
end

%% Keep PREY death rate constant, change PREDATOR death rate

plot_index = 1
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
        
        plot_index = plot_index + 1
        figure_filename = sprintf('Pred_Prey_a_%d_b_%d_c_%d_d_%d.png',a,b,c,d)
        saveas(figure(plot_index), figure_filename)
end


function dy = volterra(t,y)  

    global a
    global b
    global c
    global d

   
    dy = [a * y(1) - b * y(1) * y(2); %prey
         -c * y(2) + d * y(1) * y(2)] %predator
 
end
