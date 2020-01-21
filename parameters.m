function parameters(path)
    tic;
    load([path, '/optTrain.mat']);

    num = 20;
    theta = zeros(5, num);

    for i = 1: num
        [theta(1, i), theta(2, i), theta(3, i), theta(4, i), theta(5, i)] = ...
            optimize(XTrain, YTrain);
    end

    save([path, '/theta.mat'], 'theta');
    
    choose(path, theta, XTrain, YTrain);
    
    time = toc;
end