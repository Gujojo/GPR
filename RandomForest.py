from sklearn.ensemble import RandomForestRegressor
from sklearn.linear_model import LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.svm import SVR
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn import preprocessing
from sklearn.model_selection import KFold
import h5py
import numpy as np

path = 'data2010/data.mat'

with h5py.File(path, 'r') as f:
    tmp = f.keys()  # matlabdata.mat 中的变量名
    score = np.array(f['score'].value)
    target = np.array(f['target'].value)

tmp = (target == -1)
testSize = tmp.sum()
trainSize = target.size - testSize

trainX = np.zeros([score.shape[0], trainSize])
testX = np.zeros([score.shape[0], testSize])
trainY = np.zeros(trainSize)

numTrain = 0
numTest = 0
for i in range(target.size):
    if target[0, i] == -1:
        testX[:, numTest] = score[:, i]
        numTest += 1
    else:
        trainX[:, numTrain] = score[:, i]
        trainY[numTrain] = target[0, i]
        numTrain += 1

trainX = trainX.T
testX = testX.T

# # PolynomialFeatures生成多项式特征
# poly = PolynomialFeatures(degree=3, interaction_only=True)
# trainX = poly.fit_transform(trainX)
# testX = poly.fit_transform(testX)

# 标准化向量，按列处理
scaler = preprocessing.StandardScaler().fit(trainX)
xScaled = scaler.transform(trainX)
scaler = preprocessing.StandardScaler().fit(testX)
xTestScaled = scaler.transform(testX)

rf = RandomForestRegressor(n_estimators=100, oob_score=True, random_state=0, max_features='sqrt', max_depth=6)
rf.fit(trainX, trainY)

trainPre = rf.predict(xScaled)
testPre = rf.predict(xTestScaled)

times = 3
nSplit = 5
trainMSE = 0
testMSE = 0
for t in range(times):
    kf = KFold(n_splits=nSplit)
    for train_index, test_index in kf.split(xScaled):
        x_train, x_test = xScaled[train_index], xScaled[test_index]
        y_train, y_test = trainY[train_index], trainY[test_index]

        rf = RandomForestRegressor(n_estimators=100, oob_score=True, random_state=0, max_features='sqrt', max_depth=6)
        rf.fit(x_train, y_train)

        yPredict = rf.predict(x_train)
        trainMSE += np.average((yPredict - y_train)**2)

        yPredict = rf.predict(x_test)
        testMSE += np.average((yPredict - y_test) ** 2)

trainMSE /= (times*nSplit)
testMSE /= (times*nSplit)
print('RF train MSE is {:.4f}'.format(trainMSE))  # 精度
print('RF test MSE is {:.4f}'.format(testMSE))  # 精度
