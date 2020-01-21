function preprocess()
    clear all;
    path = 'data2010.mat';
    load(path);
    classNum = size(data2010.ClassName, 2);  % 课程数目
    score = data2010.Score;
    target = data2010.TargetScore1;
    if ~exist('data2010/')
        mkdir('data2010/');
    end
    save('data2010/data.mat', 'classNum', 'score', 'target');
    
    clear all;
    path = 'data2011.mat';
    load(path);
    classNum = size(data2011.ClassName, 2);  % 课程数目
    score = data2011.Score;
    target = data2011.TargetScore1;
    if ~exist('data2011/')
        mkdir('data2011/');
    end
    save('data2011/data.mat', 'classNum', 'score', 'target');
    
    clear all;
    path = 'data2012.mat';
    load(path);
    classNum = size(data2012.ClassName, 2);  % 课程数目
    score = data2012.Score;
    target = data2012.TargetScore1;
    if ~exist('data2012/')
        mkdir('data2012/');
    end
    save('data2012/data.mat', 'classNum', 'score', 'target');
    
    clear all;
    path = 'data2013.mat';
    load(path);
    classNum = size(data2013.ClassName, 2);  % 课程数目
    score = data2013.Score;
    target = data2013.TargetScore1;
    if ~exist('data2013/')
        mkdir('data2013/');
    end
    save('data2013/data.mat', 'classNum', 'score', 'target');
    
    clear all;
    path = 'data2014.mat';
    load(path);
    classNum = size(data2014.ClassName, 2);  % 课程数目
    score = data2014.Score;
    target = data2014.TargetScore1;
    if ~exist('data2014/')
        mkdir('data2014/');
    end
    save('data2014/data.mat', 'classNum', 'score', 'target');
    
    clear all;
    path = 'data2015.mat';
    load(path);
    classNum = size(data2015.ClassName, 2);  % 课程数目
    score = data2015.Score;
    target = data2015.TargetScore1;
    if ~exist('data2015/')
        mkdir('data2015/');
    end
    save('data2015/data.mat', 'classNum', 'score', 'target');
    
    clear all;
    path = 'data2016.mat';
    load(path);
    classNum = size(data2016.ClassName, 2);  % 课程数目
    score = data2016.Score;
    target = data2016.TargetScore1;
    if ~exist('data2016/')
        mkdir('data2016/');
    end
    save('data2016/data.mat', 'classNum', 'score', 'target');
    
end