clear all;
close all;
clc;

numYear = 7;
preprocess();
num = 100;

tic;
for p = 1: numYear
    path = ['data', num2str(2009+p)];
    load([path, '/theta.mat']);
    subplot(1, 2, 1);
    scatter(theta(1, :), theta(2, :));
    subplot(1, 2, 2);
    scatter(theta(3, :), theta(4, :));
end

t = toc;