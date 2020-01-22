function [sigma_f, l, sigma_y, sigma_n, opt] = optimize(XTrain, YTrain)
    
    %% 参数设定
    % 优化问题维度
    dim = 4;
    % 参数上下界
    xMin = [0; 1; 0; 0];
    xMax = [70; 200; 70; 2];
    maxIter = 100;  % 最大迭代次数
    % 学习因子
    C1 = 0.35;
    C2 = 0.05;
    % 速度上下界
    vMin = -0.1 * (xMax - xMin);
    vMax = 0.1 * (xMax - xMin);
    % 惯性权重
    w = 0.6;
    % 种群个数
    pNum = 1000;
    % 交叉验证组数
    kFold = 5;
    % 迭代收敛轮数
    round = 50;
    % 绘图控制
    Plot = 0;
    %% 初始化
    x = zeros(dim, pNum, 'double');
    vx = zeros(dim, pNum, 'double');
    for d = 1: dim
        x(d, :) = xMin(d) + (xMax(d) - xMin(d))*rand(pNum, 1);
        vx(d, :) = vMin(d) + (vMax(d) - vMin(d))*rand(pNum, 1);
    end
    
    % 交叉验证
    index = crossvalind('Kfold', size(XTrain, 1), kFold);
    MSE = zeros(1, pNum, 'double');
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
        for i = 1: pNum
            K = x(1, i)^2 * exp(normX / (2*x(2, i)^2)) + x(3, i)^2 * ...
                eye(trainNum) + x(4, i)^2 * (trainX * trainX');
            K_star = x(1, i)^2 * exp(normX_star / (2*x(2, i)^2)) + ...
                x(4, i)^2 * (trainX * testX');
            tmpY = K_star' * K^-1 * trainY;
            MSE(i) = MSE(i) + sum((tmpY-testY).^2) / length(tmpY);
        end
    end
    MSE = MSE / kFold;
    localOpt = MSE;

    [globalOpt, globalIndex] = min(localOpt);
    globalX = x(: , globalIndex);
    localX = x;
    
    record = zeros(1, maxIter, 'double');
    
    if Plot == 1
        figure;
        scatter(x(1, :), x(4, :));
        set(gca, 'xLim', [xMin(1), xMax(1)]);
        set(gca, 'yLim', [xMin(4), xMax(4)]);
    end
    %% 迭代更新
    n = 0;
    previous = 0;
    
    while n < maxIter && n - previous <= round && ...
            sum(var(localX, 0, 2) ./ (xMax-xMin).^2) >= 1e-2...
            && max(localOpt) / globalOpt >= 1.01
        n = n+1;
        % 学习率更新
        c1 = C1*(1 - n/maxIter);
        c2 = C1+C2-c1;
        % 速度更新
        vx = vx*w + c1*rand(dim, pNum).*(localX-x) ...
            +c2*rand(dim, pNum).*(globalX-x);
        for d = 1: dim
            vx(d, (vx(d, :) > vMax(d))) = vMax(d);
            vx(d, (vx(d, :) < vMin(d))) = vMin(d);
        end
        % 位置更新
        x = x + vx;
        for d = 1: dim
            x(d, (x(d, :) > xMax(d))) = xMax(d);
            x(d, (x(d, :) < xMin(d))) = xMin(d);
        end
        % 最优值更新
        
        % 交叉验证
        index = crossvalind('Kfold', size(XTrain, 1), kFold);
        MSE = zeros(1, pNum, 'double');
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
            for i = 1: pNum
                K = x(1, i)^2 * exp(normX / (2*x(2, i)^2)) + x(3, i)^2 * ...
                    eye(trainNum) + x(4, i)^2 * (trainX * trainX');
                K_star = x(1, i)^2 * exp(normX_star / (2*x(2, i)^2)) + ...
                    x(4, i)^2 * (trainX * testX');
                tmpY = K_star' * K^-1 * trainY;
                MSE(i) = MSE(i) + sum((tmpY-testY).^2) / length(tmpY);
            end
        end
        MSE = MSE / kFold;
        tmp = (MSE < localOpt);
        localOpt(tmp) = MSE(tmp);
        localX(: , tmp) = x(: , tmp);
        
        [tmp, globalIndex] = min(localOpt);
        if tmp < globalOpt
            globalOpt = tmp;
            globalX = x(: , globalIndex);
            previous = n;
        end
        
        record(n) = globalOpt;
        
        if Plot == 1
            scatter(x(1, :), x(4, :));
            set(gca, 'xLim', [xMin(1), xMax(1)]);
            set(gca, 'yLim', [xMin(4), xMax(4)]);
        end
    end
    
    if Plot == 2
        figure;
        scatter(x(1, :), x(2, :));
        set(gca, 'xLim', [xMin(1), xMax(1)]);
        set(gca, 'yLim', [xMin(2), xMax(2)]);
    end
    
    sigma_f = globalX(1);  % 信号方差
    l = globalX(2);  % 方差尺度
    sigma_y = globalX(3);  % 观测误差
    sigma_n = globalX(4);
    opt = globalOpt;
end