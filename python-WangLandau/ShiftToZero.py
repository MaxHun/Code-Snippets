import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import fmin
import sys

if len(sys.argv) != 3:
    print("USAGE: ShiftToZero fileIn.dat fileOut.dat")
    sys.exit()
    

 
LgG1=np.loadtxt(sys.argv[1])
LgG1Zero = np.array([LgG1[:,0], LgG1[:,1] - LgG1[len(LgG1)-1,1]]).T

np.savetxt(sys.argv[2],  LgG1Zero)






