from scipy.integrate import odeint
import matplotlib.pyplot as plt
import numpy as np

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

c0 = [1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
ratecoeff = [1, 0.01]
ps = np.linspace(0, 1.0,100)
cs = odeint(dc_dp, c0, ps, args=(0.96, 0.11, 0.06, 0.08))
ys = cs[:,0]

plt.plot(ps, cs[:,0], label='S0D0T0Q0', marker='o')
plt.plot(ps, cs[:,1], label='S1D0T0Q0', marker='v')
plt.plot(ps, cs[:,2], label='S2D0T0Q0', marker='^')
plt.plot(ps, cs[:,3], label='S0D1T0Q0', marker='<')
plt.plot(ps, cs[:,4], label='S3D0T0Q0', marker='>')
plt.plot(ps, cs[:,5], label='S1D1T0Q0', marker='8')
plt.plot(ps, cs[:,6], label='S0D0T1Q0', marker='s')
plt.plot(ps, cs[:,7], label='S4D0T0Q0', marker='p')
plt.plot(ps, cs[:,8], label='S2D1T0Q0', marker='*')
plt.plot(ps, cs[:,9], label='S0D2T0Q0', marker='h')
plt.plot(ps, cs[:,10], label='S1D0T1Q0', marker='D')
plt.plot(ps, cs[:,11], label='S0D0T0Q4', marker='x')

plt.legend(loc='best')
plt.xlabel('p')
plt.grid()

plt.show()
