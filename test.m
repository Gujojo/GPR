clear all;
close all;
clc;

%% 以下构造不同函数进行测试GPR效果
classNum = 0;
score = (0: 0.2: 10*pi)';
real = cos(score) + 0.3*score + cos(0.2*score.^2)+ cos(0.1*score.^3) + 2;
index = rand(length(score), 1) <= 0.5;
target = real;
target(index) = -1;
kFold = 5;

[res, YTest] = MethodD(classNum, score, target, kFold);

plot(score, target);
count = 1;
for i = 1: length(target)
    if (target(i) == -1)
        target(i) = YTest(count);
        count = count + 1;
    end
end
plot(score, target, 'b');
hold on;
plot(score, real, 'r');
