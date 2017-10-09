import numpy as np
from scipy.integrate import odeint
from scipy.optimize import curve_fit

def dc_dp(c,p,ks, kd, kt, kq):
  
  dcdp = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  # S0D0T0Q0
  dcdp[0]  = (                         -(4.0*ks                         )*c[0])/(1-p);
  # S1D0T0Q0
  dcdp[1]  = (4.0*ks*c[0]              -(3.0*ks+3.0*kd                  )*c[1])/(1-p);
  # S2D0T0Q0
  dcdp[2]  = (3.0*ks*c[1]              -(2.0*ks+4.0*kd                  )*c[2])/(1-p);
  # S0D1T0Q0
  dcdp[3]  = (3.0*kd*c[1]              -(2.0*ks         +2.0*kt         )*c[3])/(1-p);
  # S3D0T0Q0
  dcdp[4]  = (2.0*ks*c[2]              -(1.0*ks+3.0*kd                  )*c[4])/(1-p);
  # S1D1T0Q0
  dcdp[5]  = (4.0*kd*c[2]+2.0*ks*c[3]  -(1.0*ks+1.0*kd+1.0*kt           )*c[5])/(1-p);
  # S0D0T1Q0
  dcdp[6]  = (2.0*kt*c[3]              -(1.0*ks+                 +1.0*kq)*c[6])/(1-p);
  # S4D0T0Q0
  dcdp[7]  = (1.0*ks*c[4]	                  			      )/(1-p);
  # S2D1T0Q0
  dcdp[8]  = (1.0*ks*c[5]+3.0*kd*c[4]					    )/(1-p);
  # S0D2T0Q0
  dcdp[9]  = (1.0*kd*c[5]							    )/(1-p);
  # S1D0T1Q0
  dcdp[10] = (1.0*ks*c[6]+1.0*kt*c[5]					    )/(1-p);
  # S0D0T0Q4
  dcdp[11] = (1.0*kq*c[6]							    )/(1-p);
  return dcdp




def c(p, kS, kD, kT, kQ, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12):
    """
    Solution to the ODE y'(t) = f(t,y,a,b) with initial condition y(0) = y0
    """
    c0 = [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12]
    c = odeint(dc_dp, c0, p, args=(kS, kD, kT, kQ))
    return c.ravel()

# Some random data to fit
data = np.loadtxt('Bonds_PEG_HigherOrderDefects_HepPEGConnectedGel_Hydrogel_HEP_633__PEG_633_NStar_117__NoPerXYZ128.dat', skiprows=2)

dataDefects = data[:, 1:13]
extent =data[:, 0]

data_t = extent
data_y = dataDefects

#data_t = dataDefects; #np.sort(np.random.rand(200) * 10)
#data_y = data_t**2 + np.random.rand(200)*10

popt, cov = curve_fit(c, data_t, data_y, [0.9, 0.1, 0.01, 0.001, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
kS_opt, kD_opt, kT_opt, kQ_opt, y0_opt = popt

print("kS = %g" % kS_opt)
print("kD = %g" % kD_opt)
print("kT = %g" % kT_opt)
print("kQ = %g" % kQ_opt)
print("y0 = %g" % y0_opt)

import matplotlib.pyplot as plt
t = np.linspace(0, 1, 200)
plt.plot(data_t, data_y, '.',
         t, y(t, kS_opt, kD_opt, kT_opt, kQ_opt, y0_opt), '-')
plt.gcf().set_size_inches(6, 4)
plt.savefig('out.png', dpi=96)
plt.show()
