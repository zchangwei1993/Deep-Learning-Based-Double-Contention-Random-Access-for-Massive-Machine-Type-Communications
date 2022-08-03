#Class the received RAPs into four categories, i.e., no MTD choose the RAP, one MTD choose the RAP, Two MTD choose the RAP and three MTDs choose the RAP.

#import tensorflow as tf
import scipy.io as scio
import h5py
import numpy as np
from keras.models import Model
from keras.optimizers import Adam
from keras.layers import  Dense,Input,Flatten,Dropout,Reshape
from keras.layers.normalization import BatchNormalization
from keras.callbacks import ReduceLROnPlateau

def vectorized_result(j):
    """Return a 10-dimensional unit vector with a 1.0 in the jth
    position and zeroes elsewhere.  This is used to convert a digit
    (0...9) into a corresponding desired output from the neural
    network."""
    e = np.zeros((4, 1))
    e[j] = 1
    return e


Total_point = 1118
data = h5py.File('D:\data_set_random_rayleigh160000.mat','r') #
Data = data['Total_Rand'][:]
Data = np.transpose(Data)
Data = Data['real'] + 1j*Data['imag']
samples=Data.shape[0]
print(samples)
trainSamples=int(samples*0.75)
Train_x = Data[:trainSamples, :1677]
Train_y = Data[:trainSamples, 1677:]
Test_x = Data[trainSamples:, :1677]
Test_y = Data[trainSamples:, 1677:]
Train_y = Train_y.real
Test_y = Test_y.real
Train_y = [int(x) for x in Train_y]
Test_y = [int(x) for x in Test_y]
Train_y = [vectorized_result(y) for y in Train_y]
Train_y = np.array(Train_y)
Train_y = np.reshape(Train_y, (trainSamples,-1))
Test_y = [vectorized_result(y) for y in Test_y]
Test_y = np.array(Test_y)
Test_y = np.reshape(Test_y, (samples-trainSamples,-1))

Train_x = np.hstack((Train_x.real, Train_x.imag))
Train_x = Train_x[:, ::3]
Train_x_mean = np.mean(Train_x, axis = 0)
Train_x_std = np.std(Train_x, axis = 0)
Train_x = [(x - Train_x_mean)/Train_x_std for x in Train_x]
Train_x = np.reshape(Train_x, (trainSamples, -1))
Test_x = np.hstack((Test_x.real, Test_x.imag))
Test_x=Test_x[:, ::3]
Test_x_mean = np.mean(Test_x, axis = 0)
Test_x_std = np.std(Test_x, axis = 0)
Test_x = [(x - Test_x_mean)/Test_x_std for x in Test_x]
Test_x = np.reshape(Test_x, (samples-trainSamples, -1))

input = Input(shape=(Total_point,))
#input11 = Dropout(0.1)(input)
Dense1 = Dense(Total_point,activation='relu',kernel_initializer='he_normal')(input)
#Dense11 = Dropout(0.3)(Dense1)
BN1 = BatchNormalization(axis=-1)(Dense1)
Dense2 = Dense(Total_point,activation='relu')(BN1)
#Dense22 = Dropout(0.3)(Dense2)
BN2 = BatchNormalization(axis=-1)(Dense2)
Dense3 = Dense(Total_point,activation='relu')(BN2)
#Dense33 = Dropout(0.3)(Dense3)
BN3 = BatchNormalization(axis=-1)(Dense3)
Dense4 = Dense(Total_point,activation='relu')(BN3)
#Dense44 = Dropout(0.3)(Dense4)
BN4 = BatchNormalization(axis=-1)(Dense4)
Dense5 = Dense(Total_point,activation='relu')(BN4)
Dense6 = Dense(Total_point,activation='relu')(Dense5)
Output = Dense(4,activation='softmax')(Dense6)
# BN3 = BatchNormalization(axis=-1)(Dense1)(Dense3)
model = Model(inputs=input, outputs=Output)

adam = Adam(lr=0.01, decay=1e-6)
model.compile(optimizer='adagrad', loss='categorical_crossentropy', metrics=['categorical_accuracy'])
#reduce_lr = ReduceLROnPlateau(monitor='val_loss', patience=10, mode='auto')
model.fit(Train_x, Train_y,
          epochs = 80, batch_size = 150,
          validation_data=(Test_x,Test_y))
#
# model.save_weights('model0.h5')
# model_json = model.to_json()
# with open('model0.json','w') as json_file:
#     json_file.write(model_json)
# json_file.close()

preds = model.evaluate(Test_x, Test_y)
print ("Loss = " + str(preds[0]))
print ("Test Accuracy = " + str(preds[1]))

# net = network4.Network([3354,2000,1000,100, 4], cost=network4.CrossEntropyCost)
# net.large_weight_initializer()
# net.SGD(training_data, 30, 10, 0.1, lmbda = 5.0,evaluation_data=validation_data,
#     monitor_evaluation_accuracy=True)
