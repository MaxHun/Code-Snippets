import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import fmin
import sys

if len(sys.argv) != 4:
    print("USAGE: OverlapAndAverage window1.dat window2.dat output.dat")
    sys.exit()
    
#print(sys.argv)
#print(sys.argv[1])
#print(sys.argv[2])
#print(sys.argv[3])
 
LgG1=np.loadtxt(sys.argv[1])
LgG2=np.loadtxt(sys.argv[2])

# overlap in x between LgG1 and LgG2 for LgG1
cLgG1_2=np.in1d(LgG1[:,0], LgG2[:,0])
cLgG2_1=np.in1d(LgG2[:,0], LgG1[:,0])

# plot data and overlap in x
#plt.plot(LgG1[:,0],LgG1[:,1])
#plt.plot(LgG2[:,0],LgG2[:,1])
#plt.plot(LgG1[cLgG1_2,0],LgG1[cLgG1_2,1])
#plt.plot(LgG2[cLgG2_1,0],LgG2[cLgG2_1,1])

#plt.show()


# find the offset by minimizing the variance

def error(offset):
    return sum((LgG1[cLgG1_2,1]-LgG2[cLgG2_1,1]-offset)**2.0)


err_func = lambda a : error(a)
result = fmin(err_func, 1.0)

print(result)
offset=result[0]

# plot shifted data

#plt.plot(LgG1[:,0],LgG1[:,1])
#plt.plot(LgG2[:,0],LgG2[:,1]+offset)

#plt.show()

# concatenate all data and averaging
mean = np.array( [ LgG1[cLgG1_2,0], np.mean( np.array([ LgG1[cLgG1_2,1], LgG2[cLgG2_1,1]+offset ]), axis=0 ) ]).transpose()

LgG2Shifted = np.array([LgG2[:,0], LgG2[:,1]+offset]).T

concatenate=np.concatenate((LgG2Shifted[np.invert(cLgG2_1),:], mean, LgG1[np.invert(cLgG1_2),:]))


np.savetxt(sys.argv[3],  concatenate)
#plt.plot(concatenate[:,0],concatenate[:,1])
#plt.show()





