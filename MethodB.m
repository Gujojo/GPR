function [res, YTest] = MethodB(classNum, score, target, kFold)
    % 数据集划分
    a = size(score, 1);
    b = size(score, 2);
    score = reshape(score, 1, a*b);
    score = mapminmax(score);
    score = reshape(score, a, b);
%     score = score - mean(score);
    XTrain = score(target ~= -1, :);
    XTrain = [XTrain, ones(size(XTrain, 1), 1)];
    XTest = score(target == -1, :);
    XTest = [XTest, ones(size(XTest, 1), 1)];
    YTrain = target(target ~= -1, :);
    
    sigma_n = 1;
    Sigma_p = eye(size(XTrain, 2));
    
    w = (XTrain' * XTrain + sigma_n^2 * Sigma_p^-1)^-1 * XTrain' * YTrain;
    YTest = XTest * w;
    
    % k-fold交叉验证
    res = 0;
    index = crossvalind('Kfold', size(XTrain, 1), kFold);
    for i = 1 : kFold
        trainX = XTrain(index ~= i, :);
        testX = XTrain(index == i, :);
        trainY = YTrain(index ~= i, :);
        testY = YTrain(index == i, :);
        w = (trainX' * trainX + sigma_n^2 * Sigma_p^-1)^-1 * trainX' * trainY;
        tmpY = testX * w;
        res = res + sum((tmpY-testY).^2) / length(tmpY);
    end
    
    res = res / kFold;
end

