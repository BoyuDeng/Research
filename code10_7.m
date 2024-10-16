close all;clear,clc;

load("fielddata624.mat");

%%
uField = cell(651, 1);
vField = cell(651, 1);
wField = cell(651, 1);

for i = 1:651
    data = variables_list{i};
    uField{i} = data(1);
    vField{i} = data(2);
    wField{i} = data(3);
end

Ufactor = 2;

[uField, vField, wField] = ChangeU(uField,vField,wField, Ufactor);


U = calculateRMS(uField,vField,wField);



%%

dt = 1e-3;
%the flow flow is a 1*1*1 box
%set tf to be 1 and 1000 time step.
t = 0:dt:650*dt;
%velocity in y is 2
W = 1; 
p =1;
Forcing = 1;


StartLoc = [0.5, 0.5];
coeze = zeros(3,1);


%%


% Define the coefficients and parameters
% Number of sets
num_sets = 1000;

% Define the magnitude coefficient
coe = 0.1;  % Adjust this to change the range of randomness


% Generate random numbers for A with range [-coe, coe]
A = (2 * coe) * rand(14, num_sets) - coe;


% Define the figure for plotting
figure;
hold on; % Hold on to plot multiple trajectories in the same figure
grid on; % Enable grid
title('3D Trajectory of x(t) for First 5 Sets');
xlabel('X Component');
ylabel('Y Component');
zlabel('Z Component');

% Loop through the first 10 trajectories
colors = lines(10); % Generate 10 distinct colors
for k = 1:5
    X(:,:,k) = X14(t, A(:,k),W);
    plot3(X(1, :, k), X(2, :, k), X(3, :, k), 'LineWidth', 2, 'Color', colors(k, :));
end



% Set specific axes limits
xlim([0 1]);  % X-axis limits
ylim([0 1]);  % Y-axis limits
zlim([0 1]);  % Z-axis limits

% Adjust the view angle for better 3D perception
view(3); % Default 3D view

hold off; % Release the hold on the current figure



%%
E = zeros(1,1000);
Forcing = 0;
for i = 1:1000
    E(i) = COT14(A(:,i),t,W,uField,vField,wField,dt,p,U,Forcing);
end
straightCOT = COT_function(coeze,t,W,StartLoc,uField,vField,wField,dt, p,U, Forcing);
histogram(E/straightCOT)
title('Histogram of 1000 trajectories');
xlabel('Normalized COT');
ylabel('Frequency');


%%

[optimized_coeffs, optimized_E] = optimization14(t, W, uField, vField, wField, dt, p, U,Forcing);




