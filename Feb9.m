%close all;clear,clc;

% Define the file path
file_path = '/Users/boyi/Simulations/hit/output_fields2_U=4,L=0.17';


% Define the range of file numbers
start_num = 350;
end_num = 1050;

% Initialize cell arrays to store the results
dims_list = cell(end_num - start_num + 1, 1);
valnames_list = cell(end_num - start_num + 1, 1);
values_list = cell(end_num - start_num + 1, 1);
varnames_list = cell(end_num - start_num + 1, 1);
variables_list = cell(end_num - start_num + 1, 1);

% Loop through the range of file numbers
for i = start_num:end_num
    % Construct the filename with leading zeros
    filename = fullfile(file_path, sprintf('field_%05d', i));
    
    % Read the file
    [dims, valnames, values, varnames, variables] = read_field_file(filename);
    
    % Store the results
    dims_list{i - start_num + 1} = dims;
    valnames_list{i - start_num + 1} = valnames;
    values_list{i - start_num + 1} = values;
    varnames_list{i - start_num + 1} = varnames;
    variables_list{i - start_num + 1} = variables;
end




%%
numb=700;
numb1=numb+1;

dt = 1e-3;
t = 0:dt:numb*dt;
W = 8; 
p =1;
tau_p=1e-2;
Forcing = 1;


%%
uField = cell(numb, 1);
vField = cell(numb, 1);
wField = cell(numb, 1);

for i = 1:numb1
    data = variables_list{i};
    uField{i} = data(1);
    vField{i} = data(2);
    wField{i} = data(3);
end

% Ufactor = (1/6.975);
% Ufactor = 1;
% 
% 
% [uField, vField, wField] = ChangeU(uField,vField,wField, Ufactor);

U = calculateRMS(uField(1:100),vField(1:100),wField(1:100));


%%
gridSize = [64, 64, 64]; % Grid size

uField = cell(numb1,1); % Create a cell array with 101 elements
for i = 1:numb1
    uField{i} = {zeros(64, 64, 64) * 4}; % Assign a 64x64x64 matrix filled with 4 to each cell
end
wField = cell(numb1,1); % Create a cell array with 101 elements
for i = 1:numb1
    wField{i} = {zeros(64, 64, 64) * 4}; % Assign a 64x64x64 matrix filled with 4 to each cell
end
vField = cell(numb1,1); % Create a cell array with 101 elements
for i = 1:numb1
    vField{i} = {ones(64, 64, 64) * 8}; % Assign a 64x64x64 matrix filled with 4 to each cell
end
uField = cell(numb1,1);
% Generate the sine wave evolving over time
for i = 1:numb1
    uField{i} = {8 *cos(4 * pi  * i/numb1) * ones(gridSize)}; % Assign the sine wave value
end


%%

%parpool; % Start parallel pool


N = 14; % Number of parallel searches
% resultsU8ul5 = cell(1, N);
% fvalsU8ul5 = cell(1, N);
% 
% resultsTest1 = cell(1, N);
% fvalsTest1 = cell(1, N);
% 
% 
% resultsU8ul1high = cell(1, N);
% fvalsU8ul1high = cell(1, N);


G = [0.001;0.01;0.1;0.2;0.4;0.5;0.6;0.7;0.9;1.0;1.2;1.7;2;2.5];
Gold = [0.01;0.05;0.1;0.2;0.4;0.5;0.6;0.7;0.9;1.0;1.2;1.7;2;2.5];
Ghigh = [2,2.5,3,4,5,6,7,8,9,10,11,15,20,25];
lowlim = [7,3,2,3,3,3,3,3,3,3,3,3,3,3];
highlimU = [8,4,8,10,10,10,10,10,10,10,10,10,10,10];
highlim = [40,50,60,70,80,90,100,200,300,400,500,500,500,500];


W = [0,0,0,0,4,4,4,8,8,8,8,18,18,18];

% parfor i = 1:N
%     [resultsTest1{i}.coeffs, resultsTest1{i}.W, resultsTest1{i}.energy, fvalsTest1{i}] = ...
%         optimization27(t, 8, uField, vField, wField, dt, p, U, Forcing, 1000,20, G(i),0, 20,1,0.5);
% end 


%1 15000, 20 , 0,20,1,0.5
%2 ~,30,~,~,~
%3 ~,40,~,~
% parfor i = 1:N
%     [resultsU8_7{i}.coeffs, resultsU8_7{i}.W, resultsU8_7{i}.energy, fvalsU8_4{i}] = ...
%         optimization27(t, 8, uField, vField, wField, dt, p, U, Forcing, 10000,15, G(i),0, 20,1,0.5);
% end 
% parfor i = 1:N
%     [resultsU8_8{i}.coeffs, resultsU8_8{i}.W, resultsU8_8{i}.energy, fvalsU8_8{i}] = ...
%         optimization27(t, 8, uField, vField, wField, dt, p, U, Forcing, 5000,10, G(i),0, 20,1,0.5);
% end 
% parfor i = 1:N
%     [resultsU8_9{i}.coeffs, resultsU8_9{i}.W, resultsU8_9{i}.energy, fvalsU8_9{i}] = ...
%         optimization27(t, 8, uField, vField, wField, dt, p, U, Forcing, 5000,25, G(i),0, 20,1,0.5);
% end 



parfor i = 1:N
    [results1U4_5{i}.coeffs, results1U4_5{i}.W, results1U4_5{i}.energy, fvals1U4_5{i}] = ...
        optimization27(t, U, uField, vField, wField, dt, p, U, Forcing, 1000,5, G(i),0, 20,1,1,0);
end 

parfor i = 1:N
    [results1U4_10{i}.coeffs, results1U4_10{i}.W, results1U4_10{i}.energy, fvals1U4_10{i}] = ...
        optimization27(t, results1U4_5{i}.W, uField, vField, wField, dt, p, U, Forcing, 1000,10, G(i),0, 20,1,1,results1U4_5{i}.coeffs);
end

parfor i = 1:N
    [results1U4_15{i}.coeffs, results1U4_15{i}.W, results1U4_15{i}.energy, fvals1U4_15{i}] = ...
        optimization27(t, results1U4_10{i}.W, uField, vField, wField, dt, p, U, Forcing, 1000,15, G(i),0, 20,1,1,results1U4_10{i}.coeffs);
end

parfor i = 1:N
    [results1U4_20{i}.coeffs, results1U4_20{i}.W, results1U4_20{i}.energy, fvals1U4_20{i}] = ...
        optimization27(t, results1U4_15{i}.W, uField, vField, wField, dt, p, U, Forcing, 1000,20, G(i),0, 20,1,1,results1U4_15{i}.coeffs);
end

parfor i = 1:N
    [results1U4_25{i}.coeffs, results1U4_25{i}.W, results1U4_25{i}.energy, fvals1U4_25{i}] = ...
        optimization27(t, results1U4_20{i}.W, uField, vField, wField, dt, p, U, Forcing, 1000,25, G(i),0, 20,1,1,results1U4_20{i}.coeffs);
end



%%
colors = {'b', 'r', 'g', 'm', 'c', 'k'}; % Extend this if needed
markers = {'o', 's', 'd', '^', 'v', 'p'}; % Extend this if needed

hold on; % Hold the plot to overlay multiple points

for i = 1:length(G)
    % Plot each fvals dataset with a different color and marker
    plot(G(i), fvalsU4_m10{i}, markers{1}, 'MarkerSize', 6, 'MarkerFaceColor', colors{1});
    plot(G(i), fvalsU4_m15{i}, markers{2}, 'MarkerSize', 6, 'MarkerFaceColor', colors{2});
    plot(G(i), fvalsU4_m20{i}, markers{3}, 'MarkerSize', 6, 'MarkerFaceColor', colors{3});
    plot(G(i), fvalsU4_m25{i}, markers{4}, 'MarkerSize', 6, 'MarkerFaceColor', colors{4});
    plot(G(i), fvalsU4_m30{i}, markers{5}, 'MarkerSize', 6, 'MarkerFaceColor', colors{5});
end

set(gca, 'XScale', 'log'); % Set X-axis to log scale
set(gca, 'YScale', 'log'); % Set X-axis to log scale
% Adding labels and title
xlabel('G');
ylabel('COT');
title('Plot of COT vs G t = 16.5 (t_d U/L)');

grid on;

% Adding legend
legend({'mode5', 'mode10', 'mode15','mode20','mode25'}, 'Location', 'best');

hold off; % Release the plot hold




%%
alitotal = zeros(1, length(G));
Fdrag = zeros(3, length(t), length(G));
ali = zeros(1, length(G));
for i = 1:14
[COThigh1(i),~, ~, alihigh1(i)] = COT14(results1U4_25{i}.coeffs, t, results1U4_25{i}.W, uField, vField, wField, dt, p,U, 1, G(i));
%ali(i) = sum(vecnorm(Fdrag(:,:,i)))/700;
end

%%
% Given data

% % Initialize arrays for cot and G
cothigh = zeros(1, length(G)); % Preallocate cot array
am = 3;
% Use a for loop to iterate over each value of G
for i = 1:length(G)
    % Call COT14 for each value of G(i)
    then = i;
    [cothigh(then)] = COT14(results7hhigh10k{i}.coeffs,t(1:700),results7hhigh10k{i}.W, uField(1:700),vField(1:700),wField(1:700),dt,p,U,Forcing, Ghigh(then));

    % Plot each point
    plot(Ghigh(i), cothigh(i), 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
    hold on; % Hold the plot to overlay multiple points
end

% Adding labels and title
xlabel('G');
ylabel('cot');
title('Plot of cot vs G');
grid on;
hold off; % Release the plot hold







% %%
% then = 12;
% thecoeffs = results1{then}.coeffs;
% thew = results1{then}.W;
% [cot, fd, gt, ali] = COT14(results1{then}.coeffs,t(1:300),results1{then}.W, uField(1:300),vField(1:300),wField(1:300),dt,p,U,Forcing, G(then));
% % [cot, FD, G, ali1] = COT14(optimized_coeffs2,t,optW, uField,vField,wField,dt,p,U,Forcing);
% % 
% % [cot1, FD, G, ali1] = COT14(optimized_coeffs1k,t,optW1k, uField,vField,wField,dt,p,U,Forcing);
% % [cot5, FD, G, ali5] = COT14(optimized_coeffs5k,t,optW5k, uField,vField,wField,dt,p,U,Forcing);
% % [cot8, FD, G, ali8] = COT14(optimized_coeffs8k,t,optW8k, uField,vField,wField,dt,p,U,Forcing);

%%
num_results = length(results7h30knew1); % Get the number of elements in results
tail_values1 = zeros(1, num_results); % Preallocate array for tail values

% Loop through each result and compute the tail value
for i = 1:num_results
    % [cot, FD, ~, ali] = COT14(results7h30knew1{i}.coeffs, t, results7h30knew1{i}.W, ...
    %                            uField, vField, wField, ...
    %                            dt, p, U, Forcing, G(i));
    % tail_values(i) = sum(vecnorm(ali)) / length(t);
        [cot, FD, ~, ali] = COT14(results7h30k1{i}.coeffs, t, results7h30k1{i}.W, ...
                               uField, vField, wField, ...
                               dt, p, U, Forcing, G(i));
    tail_values1(i) = sum(vecnorm(ali)) / length(t);


    % plot(G(i), tail_values(i), markers{1}, 'MarkerSize', 6, 'MarkerFaceColor', colors{1});
    % plot(G(i), cot2(i), markers{2}, 'MarkerSize', 6, 'MarkerFaceColor', colors{2});
end

% Find the minimum tail value and its index
[min_tail, min_index] = min(tail_values1);

% Display results
fprintf('Minimum tail value: %f at index %d\n', min_tail, min_index);

%%
G = [0.01;0.05;0.1;0.2;0.4;0.5;0.6;0.7;0.9;1.0;1.2;1.7;2;2.5];

% Define the figure for plotting
figure;
hold on; % Hold on to plot multiple trajectories in the same figure
grid on; % Enable grid
title('3D Trajectory of x(t) for First 5 Sets');
xlabel('X Component');
ylabel('Y Component');
zlabel('Z Component');

% Loop through the first 5 trajectories
colors = lines(5); % Generate 5 distinct colors

L = 0.17; % Ensure L is defined appropriately

for i = 1:5
    X(:,:) = X14(t, resultsU8_2{i}.coeffs, resultsU8_2{i}.W);
    plot3(X(1, :)/L, X(2, :)/L, X(3, :)/L, 'LineWidth', 2, 'Color', colors(i, :));
end

% Set specific axes limits (adjusted to account for L)
xlim([0 4/L]);  % Normalized X-axis limits
ylim([0 1/L]);  % Normalized Y-axis limits
zlim([0 1/L]);  % Normalized Z-axis limits

axis equal;
% Adjust the view angle for better 3D perception
view(3); % Default 3D view

% Create legend labels using the first five values of G
legendLabels = arrayfun(@(g) sprintf('G = %.2f', g), G(1:5), 'UniformOutput', false);

% Add legend for trajectories
legend(legendLabels, 'Location', 'best');

hold off; % Release the hold on the current figure



%%
QF = QFode45(uField, vField, wField, t, dt, 64, resultsU8ul5{1}.coeffs(end-1), resultsU8ul5{1}.coeffs(end));


%%


num_time_steps = length(t);  % Number of time steps
X = zeros(3, num_time_steps);
% Preallocate trajectory coordinates
X_k = zeros(1, num_time_steps);
Y_k = zeros(1, num_time_steps);
Z_k = zeros(1, num_time_steps);

% Preallocate velocity components
U_ = zeros(1, num_time_steps);
V_ = zeros(1, num_time_steps);
W_ = zeros(1, num_time_steps);

figure;
hold on; % Hold on to plot multiple trajectories in the same figure
grid on; % Enable grid
title('Trajectory');
xlabel('X/L');
ylabel('Y/L');
zlabel('Z/L');
nub=1;
L = 0.17; % Define L for normalization

% Generate colors for the trajectories
colors = lines(5); % Generate 5 distinct colors

% Loop through the first 5 trajectories
for k = 1:1
    % Compute the trajectory for each set
    X(:,:) = X14(t, results1U4_25{14}.coeffs,results1U4_25{14}.W);
    % Extract X, Y, Z coordinates and normalize by L
    X_k = X(1, :, k) / L;
    Y_k = X(2, :, k) / L;
    Z_k = X(3, :, k) / L;
    
    % Plot the trajectory and assign legend labels
    plot3(X_k, Y_k, Z_k, 'LineWidth', 2, 'Color', colors(k, :), 'DisplayName', ['Trajectory ' num2str(k)]);
    
    % Calculate velocity vectors for the current trajectory
    V = get_vel(uField, vField, wField, 64, X(:, :, k));
    
    % Scale vectors
    V_scale = 1;
    U_ = V(1, :) * V_scale / L; % X-components of vectors
    V_ = V(2, :) * V_scale / L; % Y-components of vectors
    W_ = V(3, :) * V_scale / L; % Z-components of vectors
    
    % Plot vectors at every 10th time step (no DisplayName for vectors)
    step = 10; % Vector plotted every 10th time step
    quiver3(X_k(1:step:end), Y_k(1:step:end), Z_k(1:step:end), ...
            U_(1:step:end), V_(1:step:end), W_(1:step:end), 1, 'Color', colors(k, :), 'LineWidth', 1);
end

% Set specific axes limits (adjusted to account for L)
xlim([0 1/L]);  % Normalized X-axis limits
ylim([0 1/L]);  % Normalized Y-axis limits
zlim([0 1/L]);  % Normalized Z-axis limits

axis equal
% Adjust the view angle for better 3D perception
view(3); % Default 3D view

% Add legend for trajectories only
%legend('show', 'Location', 'best');

hold off; % Release the hold on the current figure


% 
% save('resultfeb8first650.mat', 'optimized_coeffs');
% save('Wfeb8first650', 'optW')



%%

% Define the filename
filename = 'feb17data.mat';

% Save optimized_coeffs1 to optimized_coeffs9 and optW1 to optW9
save(filename, 'results1', 'results2', 'results3', ...
               'results3h30k', 'results7h30k1', 'results7h30k2');


save('feb19data.mat', 'results7h30knew1', 'results7h30knew2', 'results7hhigh', ...
               'results7hhigh10k');





save('feb25data.mat', 'resultsU8_1','resultsU8_2','resultsU8high','results7hlimhigh');


save('feb26data.mat', 'resultsU8_2high','resultsU8new_2');

save('feb27data.mat', 'resultsU8_3high','resultsU8new_3');

save('Apr8data.mat', 'resultsU8_m20','resultsU8_m25','resultsU8_m30');

save('Apr14data.mat', 'results1U8_5', 'results1U8_10','results1U8_15','results1U8_20','results1U8_25')

save('Apr15data.mat', 'results1U4_5', 'results1U4_10', 'results1U4_15', 'results1U4_20', 'results1U4_25');
