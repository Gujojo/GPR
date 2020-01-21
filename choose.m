function choose(path, Theta, XTrain, YTrain)
    numTheta = size(Theta, 2);
    kFold = 5;
    num = 200;
    
    res = zeros(1, numTheta, 'double');
    for n = 1: num
        index = crossvalind('Kfold', size(XTrain, 1), kFold);
        MSE = zeros(1, numTheta, 'double');
        for f = 1 : kFold
            % 划分数据集
            trainX = XTrain(index ~= f, :);
            testX = XTrain(index == f, :);
            trainY = YTrain(index ~= f, :);
            testY = YTrain(index == f, :);
            trainNum = length(trainY);
            testNum = size(testX, 1);

            % 减少计算量
            normX = zeros(trainNum, trainNum, 'double');
            normX_star = zeros(trainNum, testNum, 'double');
            for i = 1: trainNum
                for j = 1: trainNum
                    normX(i, j) = -norm(trainX(i, :)-trainX(j, :))^2;
                end
                for k =  1: testNum
                    normX_star(i, k) = -norm(trainX(i, :)-testX(k, :))^2;
                end
            end
            % 逐个计算MSE
            for i = 1: numTheta
                K = Theta(1, i)^2 * exp(normX / (2*Theta(2, i)^2)) + Theta(3, i)^2 * ...
                    eye(trainNum) + Theta(4, i)^2 * (trainX * trainX');
                K_star = Theta(1, i)^2 * exp(normX_star / (2*Theta(2, i)^2)) + ...
                    Theta(4, i)^2 * (trainX * testX');
                tmpY = K_star' * K^-1 * trainY;
                MSE(i) = MSE(i) + sum((tmpY-testY).^2) / length(tmpY);
            end
        end
        res = res + MSE;
    end
    
    [opt, index] = min(res);
    opt = opt / (num*kFold);
    sigma_f = Theta(1, index);  % 信号方差
    l = Theta(2, index);  % 方差尺度
    sigma_y = Theta(3, index);
    sigma_n = Theta(4, index);
    save([path, '/parameters.mat'], 'sigma_f', 'l', 'sigma_y', 'sigma_n');
end