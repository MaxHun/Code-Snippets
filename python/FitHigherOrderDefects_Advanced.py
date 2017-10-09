import pylab as pp
import numpy as np
from scipy import integrate, interpolate
from scipy import optimize

##initialize the data
#x_data = np.linspace(0,9,10)
#y_data = np.array([0.000,0.416,0.489,0.595,0.506,0.493,0.458,0.394,0.335,0.309])

import sys

print 'USAGE: file kS kD kT kQ'
print 'Number of arguments:', len(sys.argv), 'arguments.'
print 'Argument List:', str(sys.argv)

filename = ""
kS = 0.9
kD = 0.3
kT = 0.1
kQ = 0.01
SB1 = -0.01
SB2 = 3.0
SB3 = -1.5

if len(sys.argv) == 2: 
    filename = sys.argv[1]

if len(sys.argv) > 2:
    filename = sys.argv[1]
    kS = float(sys.argv[2])
    kD = float(sys.argv[3])
    kT = float(sys.argv[4])
    kQ = float(sys.argv[5])

print 'use file:', filename, 'for evaluation'

initialguess = [kS, kD, kT, kQ, SB1, SB2, SB3]

print 'inital guess:', initialguess, 'for evaluation'

# Some random data to fit
#data = np.loadtxt('Bonds_PEG_HigherOrderDefects_HepPEGConnectedGel_Hydrogel_HEP_633__PEG_633_NStar_117__NoPerXYZ128.dat', skiprows=2)
data = np.loadtxt(filename, skiprows=2)


dataDefects = data[:, 1:13]
extent =data[:, 0]

x_data = extent
y_data0 = dataDefects[:,0]
y_data1 = dataDefects[:,1]
y_data2 = dataDefects[:,2]
y_data3 = dataDefects[:,3]
y_data4 = dataDefects[:,4]
y_data5 = dataDefects[:,5]
y_data6 = dataDefects[:,6]
y_data7 = dataDefects[:,7]
y_data8 = dataDefects[:,8]
y_data9 = dataDefects[:,9]
y_data10 = dataDefects[:,10]
y_data11 = dataDefects[:,11]

def f(y, t, k): 
    """define the ODE system in terms of 
        dependent variable y,
        independent variable t, and
        optinal parmaeters, in this case a single variable k """
    #return (-k[0]*y[0],
    #      k[0]*y[0]-k[1]*y[1],
    #      k[1]*y[1])

    return (
            # S0D0T0Q0
            (                         -(4.0*k[0]                         )*y[0])/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S1D0T0Q0
            (4.0*k[0]*y[0]              -(3.0*k[0]+3.0*k[1]                  )*y[1])/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S2D0T0Q0
            (3.0*k[0]*y[1]              -(2.0*k[0]+4.0*k[1]                  )*y[2])/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S0D1T0Q0
            (3.0*k[1]*y[1]              -(2.0*k[0]         +2.0*k[2]         )*y[3])/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S3D0T0Q0
            (2.0*k[0]*y[2]              -(1.0*k[0]+3.0*k[1]                  )*y[4])/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S1D1T0Q0
            (4.0*k[1]*y[2]+2.0*k[0]*y[3]  -(1.0*k[0]+1.0*k[1]+1.0*k[2]           )*y[5])/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S0D0T1Q0
            (2.0*k[2]*y[3]              -(1.0*k[0]+                 +1.0*k[3])*y[6])/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S4D0T0Q0
            (1.0*k[0]*y[4]	                  			      )/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S2D1T0Q0
            (1.0*k[0]*y[5]+3.0*k[1]*y[4]					    )/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S0D2T0Q0
            (1.0*k[1]*y[5]							    )/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S1D0T1Q0
            (1.0*k[0]*y[6]+1.0*k[2]*y[5]					    )/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])),
            # S0D0T0Q4
            (1.0*k[3]*y[6]							    )/(((1.0/(1.0-k[4]))*(-np.log(1-t))**k[4])*(t**k[6])*((1-t)**k[5])) )

def my_ls_func(x,teta):
    """definition of function for LS fit
        x gives evaluation points,
        teta is an array of parameters to be varied for fit"""
    # create an alias to f which passes the optional params    
    f2 = lambda y,t: f(y, t, teta)
    # calculate ode solution, retuen values for each entry of "x"
    r = integrate.odeint(f2,y0,x)
    #in this case, we only need one of the dependent variable values
    return r[:,0]

def my_ls_func1(x,teta):
    """definition of function for LS fit
        x gives evaluation points,
        teta is an array of parameters to be varied for fit"""
    # create an alias to f which passes the optional params    
    f2 = lambda y,t: f(y, t, teta)
    # calculate ode solution, retuen values for each entry of "x"
    r = integrate.odeint(f2,y0,x)
    #in this case, we only need one of the dependent variable values
    return r[:,1]

def my_ls_func2(x,teta):
    """definition of function for LS fit
        x gives evaluation points,
        teta is an array of parameters to be varied for fit"""
    # create an alias to f which passes the optional params    
    f2 = lambda y,t: f(y, t, teta)
    # calculate ode solution, retuen values for each entry of "x"
    r = integrate.odeint(f2,y0,x)
    #in this case, we only need one of the dependent variable values
    return r[:,2]

def f_resid(p):
    """ function to pass to optimize.leastsq
        The routine will square and sum the values returned by 
        this function""" 
    return y_data0-my_ls_func(x_data,p) + y_data1-my_ls_func1(x_data,p)+ y_data2-my_ls_func2(x_data,p)


def my_ls_funcAll(x,teta):
    """definition of function for LS fit
        x gives evaluation points,
        teta is an array of parameters to be varied for fit"""
    # create an alias to f which passes the optional params    
    f2 = lambda y,t: f(y, t, teta)
    # calculate ode solution, retuen values for each entry of "x"
    r = integrate.odeint(f2,y0,x)
    #in this case, we only need one of the dependent variable values
    return r

def f_resid2(p):
    """ function to pass to optimize.leastsq
        The routine will square and sum the values returned by 
        this function""" 
    return sum(dataDefects-my_ls_funcAll(x_data,p),2); 

#solve the system - the solution is in variable c
guess = initialguess #[0.9,0.3, 0.01, 0.001] #initial guess for params
y0 = [1,0,0,0,0,0,0,0,0,0,0,0] #inital conditions for ODEs
(c,kvg) = optimize.leastsq(f_resid2, guess) #get params

print "parameter values are ",c

# fit ODE results to interpolating spline just for fun
xeval=np.linspace(min(x_data), max(x_data),30) 
gls = interpolate.UnivariateSpline(xeval, my_ls_func(xeval,c), k=3, s=0)

gls1 = interpolate.UnivariateSpline(xeval, my_ls_func1(xeval,c), k=3, s=0)
gls2 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,2], k=3, s=0)
gls3 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,3], k=3, s=0)
gls4 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,4], k=3, s=0)
gls5 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,5], k=3, s=0)
gls6 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,6], k=3, s=0)
gls7 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,7], k=3, s=0)
gls8 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,8], k=3, s=0)
gls9 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,9], k=3, s=0)
gls10 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,10], k=3, s=0)
gls11 = interpolate.UnivariateSpline(xeval, my_ls_funcAll(xeval,c)[:,11], k=3, s=0)

#pick a few more points for a very smooth curve, then plot 
#   data and curve fit
xeval=np.linspace(min(x_data), max(x_data),200)
#Plot of the data as red dots and fit as blue line
#pp.plot(x_data, y_data0,'.r', label='S0D0T0Q0',xeval,gls(xeval),'-b', x_data, y_data1,'.g', label='S1D0T0Q0', xeval,gls1(xeval),'-g', x_data, y_data2,'xm', label='S2D0T0Q0', xeval,gls2(xeval),'-m')
pp.plot(x_data, y_data0, label='S0D0T0Q0', marker='o', linestyle='None', color='b')
pp.plot(xeval,gls(xeval), color='b')
pp.plot(x_data, y_data1, label='S1D0T0Q0', marker='v', linestyle='None', color='g')
pp.plot(xeval,gls1(xeval), color='g')
pp.plot(x_data, y_data2, label='S2D0T0Q0', marker='^', linestyle='None', color='r')
pp.plot(xeval,gls2(xeval), color='r')
pp.plot(x_data, y_data3, label='S0D1T0Q0', marker='<', linestyle='None', color='c')
pp.plot(xeval,gls3(xeval), color='c')
pp.plot(x_data, y_data4, label='S3D0T0Q0', marker='>', linestyle='None', color='m')
pp.plot(xeval,gls4(xeval), color='m')
pp.plot(x_data, y_data5, label='S1D1T0Q0', marker='8', linestyle='None', color='y')
pp.plot(xeval,gls5(xeval), color='y')
pp.plot(x_data, y_data6, label='S0D0T1Q0', marker='s', linestyle='None', color='k')
pp.plot(xeval,gls6(xeval), color='k')
pp.plot(x_data, y_data7, label='S4D0T0Q0', marker='p', linestyle='None', color='b')
pp.plot(xeval,gls7(xeval), color='b')
pp.plot(x_data, y_data8, label='S2D1T0Q0', marker='*', linestyle='None', color = '#eeefff')
pp.plot(xeval,gls8(xeval), color='#eeefff')
pp.plot(x_data, y_data9, label='S0D2T0Q0', marker='h', linestyle='None', color = '#00efff')
pp.plot(xeval,gls9(xeval), color='#00efff')
pp.plot(x_data, y_data10, label='S1D0T1Q0', marker='D', linestyle='None', color = '#ee3f9f')
pp.plot(xeval,gls10(xeval), color='#ee3f9f')
pp.plot(x_data, y_data11, label='S0D0T0Q4', marker='x', linestyle='None', color = '#4e7f2f')
pp.plot(xeval,gls11(xeval), color='#4e7f2f')


pp.xlabel('p',{"fontsize":16})
pp.ylabel("relative frequency",{"fontsize":16})
pp.legend(loc='best')
pp.grid()
#pp.legend(('S0D0T0Q0','fitS0D0T0Q0'),loc=0)
pp.show()
