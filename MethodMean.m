function [res, YTest] = MethodMean(classNum, score, target, kFold, path)
    % 数据正则处理
    % a = size(score, 1);
    % b = size(score, 2);
    % score = reshape(score, 1, a*b);
    % score = mapminmax(score);
    % score = reshape(score, a, b);
    % score = score - mean(score);
    
    % 数据集划分
    XTrain = score(target ~= -1, :);
    XTest = score(target == -1, :);
    YTrain = target(target ~= -1, :);
    trainNum = length(YTrain);
    testNum = size(XTest, 1);
    
    YTest = mean(YTrain)*ones(testNum, 1);
    res = sum((YTrain - mean(YTrain)).^2) / length(YTrain);
    
    save([path, '/optTrain.mat'], 'XTrain', 'YTrain');
end