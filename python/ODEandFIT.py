import numpy as np
from scipy.integrate import odeint
from scipy.optimize import curve_fit

def f(y, t, a, b):
    return a*y**2 + b

def y(t, a, b, y0):
    """
    Solution to the ODE y'(t) = f(t,y,a,b) with initial condition y(0) = y0
    """
    y = odeint(f, y0, t, args=(a, b))
    return y.ravel()

# Some random data to fit
data = np.loadtxt('Bonds_PEG_HigherOrderDefects_HepPEGConnectedGel_Hydrogel_HEP_633__PEG_633_NStar_117__NoPerXYZ128.dat', skiprows=2)

dataDefects = data[:, 1:13]
extent =data[:, 0]
data_t = np.sort(np.random.rand(200) * 10)
data_y = data_t**2 + np.random.rand(200)*10

popt, cov = curve_fit(y, data_t, data_y, [-1.2, 0.1, 0])
a_opt, b_opt, y0_opt = popt

print("a = %g" % a_opt)
print("b = %g" % b_opt)
print("y0 = %g" % y0_opt)

import matplotlib.pyplot as plt
t = np.linspace(0, 10, 2000)
plt.plot(data_t, data_y, '.',
         t, y(t, a_opt, b_opt, y0_opt), '-')
plt.gcf().set_size_inches(6, 4)
plt.savefig('out.png', dpi=96)
plt.show()
