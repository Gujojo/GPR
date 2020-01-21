function [res, YTest] = MethodD(classNum, score, target, kFold, path)
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

    load([path, '/parameters.mat']);
%     l = 21;
%     sigma_f = 2;
%     sigma_y = 1;
%     sigma_n = 0.2;
    K = zeros(trainNum, trainNum, 'double');
    K_star = zeros(trainNum, testNum, 'double');

    for i = 1: trainNum
        for j = 1: trainNum
            K(i, j) = sigma_f^2 * exp(-norm(XTrain(i, :) - XTrain(j, :))^2 ...
                / (2*l^2));
        end
        for k = 1: testNum
            K_star(i, k) = sigma_f^2 * exp(-norm(XTrain(i, :) - XTest(k, :))^2 ...
                / (2*l^2));

        end
    end
    K = K + sigma_y^2 * eye(trainNum) + sigma_n^2 * (XTrain * XTrain');
    K_star = K_star + sigma_n^2 * (XTrain * XTest');

    miu = K_star' * K^-1 * YTrain;
%     sigma = -K_star' * K^-1 * K_star + ...
%         (sigma_f^2 + sigma_y^2) * eye(testNum);
    
    YTest = miu;
    
    % k-fold交叉验证
    res = 0;

    index = crossvalind('Kfold', size(XTrain, 1), kFold);
    for f = 1 : kFold
        trainX = XTrain(index ~= f, :);
        testX = XTrain(index == f, :);
        trainY = YTrain(index ~= f, :);
        testY = YTrain(index == f, :);
        trainNum = length(trainY);
        testNum = size(testX, 1);

        K = zeros(trainNum, trainNum, 'double');
        K_star = zeros(trainNum, testNum, 'double');

        for i = 1: trainNum
            for j = 1: trainNum
                K(i, j) = sigma_f^2 * exp(-norm(trainX(i, :)-trainX(j, :))^2 ...
                    / (2*l^2));
            end
            for k = 1: testNum
                K_star(i, k) = sigma_f^2 * exp(-norm(trainX(i, :)-testX(k, :))^2 ...
                    / (2*l^2));

            end
        end
        K = K + sigma_y^2 * eye(trainNum) + sigma_n^2 * (trainX * trainX');
        K_star = K_star + sigma_n^2 * (trainX * testX');

        miu = K_star' * K^-1 * trainY;
        sigma = -K_star' * K^-1 * K_star + sigma_f^2 * eye(testNum);

        tmpY = miu;
        res = res + sum((tmpY-testY).^2) / length(tmpY);
    end

    res = res / kFold;
end