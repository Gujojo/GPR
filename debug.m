clear all;
close all;
clc;

numYear = 7;
methods = 5;
num = 100;

% mse = zeros(numYear, methods, 'double');
% 
% for p = 1: numYear
%     path = ['data', num2str(2009+p)];
%     load([path, '/MSE.mat']);
%     mse(p, :) = MSE;
% %     load([path, '/theta.mat']);
% %     subplot(1, 2, 1);
% %     scatter(theta(1, :), theta(2, :));
% %     subplot(1, 2, 2);
% %     scatter(theta(3, :), theta(4, :));
% end
% 
% MSE = mse;
% save('MSE.mat', 'MSE');

%% MSEÖù×´Í¼»æÖÆ
load('MSE.mat');
figure;
hold on;
year = 2010: 2016;
% for i = 1: methods
%     plot(year, MSE(:, i));
% end
bar(year, MSE(:, 1:4));
xlabel('Äê·Ý');
ylabel('MSE');
legend(["A", "B", "C", "D", "Mean"]);