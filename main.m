clear all;
close all;
clc;

tic;

numYear = 7;
preprocess();

for p = 1: numYear
    path = ['data', num2str(2009+p)];
    load([path, '/data.mat']);
    kFold = 5;
    num = 1000;
    Res = zeros(num, 5);

    %% Method Mean
    res = MethodMean(classNum, score, target, kFold, path);
    Res(: , 5) = res;

    parameters(path);

    for i = 1: num
        %% Method A
        res = MethodA(classNum, score, target, kFold);
        Res(i, 1) = res;

        %% Method B
        res = MethodB(classNum, score, target, kFold);
        Res(i, 2) = res;

        %% Method C
        res = MethodC(classNum, score, target, kFold, 2);
        Res(i, 3) = res;

        %% Method D
        res = MethodD(classNum, score, target, kFold, path);
        Res(i, 4) = res;
    end

    MSE = mean(Res)
    save([path, '/MSE.mat']);
end

time = toc;

% % Ä£Äâ²âÊÔÓÃ´úÂë
% classNum = 0;
% score = (0: 0.2: 10*pi)';
% real = cos(score) + 0.3*score + cos(0.2*score.^2)+ cos(0.1*score.^3) + 2;
% index = rand(length(score), 1) <= 0.5;
% target = real;
% target(index) = -1;
% kFold = 10;
% num = 100;
% Res = zeros(num, 4);