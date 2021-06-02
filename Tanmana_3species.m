plot_index = 1;
global Mu
global M
global perturbation

% Mu = [a; b; c]; %specific growth rates
% M = [aa ab ac; ba bb bc; ca cb cc]; %species interaction
% perturbation = [p1; p2; p3];

Mu = [0.6; 0.2; 0.4];
M = [-0.4 -0.3 0.6; 0 -0.4 0.6; 0 0 -0.4];

%% Before perturbation
perturbation = [0; 0; 0];
[t_0,y_0] = ode23(@lotkavolterra,[0 30],[0.4 0.5 0.3]);
figure(plot_index);
subplot(3,1,1);
newcolors = {'r', 'g', 'b'};
colororder(newcolors)
plot(t_0,y_0)
    title('Microbial interaction in an ecosytem');
    legend('Species A', 'Species B', 'Species C');
    xlabel('Time');
    ylabel('Microbe abundance'); 

%% Antibiotic perturbation
y1 = y_0(end,:);
perturbation = [-0.8 ; -0.3; -0.9];
[t_1,y_1] = ode23(@lotkavolterra, [30 50], y1);
figure(plot_index); subplot(3,1,2);
plot(t_1,y_1)
    title('Microbial interaction after antibiotic perturbation');
    legend('Species A', 'Species B', 'Species C');
    xlabel('Time');
    ylabel('Microbe abundance');
    text(5 ,1, 'Antibiotic perturbation');
        
%% New equilibrium
y2 = y_1(end,:);
perturbation = [0; -0.2; 0];
[t_2,y_2] = ode23(@lotkavolterra, [50 120], y2);
figure(plot_index); subplot(3,1,3);
plot(t_2,y_2)
    title('Microbial interaction after antibiotic is gone');
    legend('Species A', 'Species B', 'Species C');
    xlabel('Time');
    ylabel('Microbe abundance');
 
%% 
plot_index = plot_index+1;

%% Concatenation
tcombined = [t_0; t_1; t_2];
ycombined = [y_0; y_1; y_2];
figure(plot_index);
plot(tcombined,ycombined)
newcolors = {'r', 'g', 'b'};
colororder(newcolors)
xline(30,'--k'); xline(50,'--k');
    title('Microbial interaction in an ecosystem over time');
    legend('Species A', 'Species B', 'Species C');
    xlabel('Time');
    ylabel('Microbe abundance');    
 text(30, 1.5, 'Antibiotic perturbation');

%% 
function dy = lotkavolterra(t,y)
global Mu
global M
global perturbation
dy = (Mu+M*y+perturbation).*y;
end