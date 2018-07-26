import numpy as np
import sys

if len(sys.argv) != 2:
    print("USAGE: CalcThermodynamicPotentials HGLnDOS.dat")
    sys.exit()
    
FH = np.loadtxt(sys.argv[1])

maximumFH = np.max(FH[:,1])

FH[:,1] = FH[:,1]-maximumFH


T = np.linspace(0.01, 100.0, 50000)

# find maximum for extrem exponentials
maximumExpArray= np.empty(len(T))

for i in range(len(T)):
    maximumExpArray[i]=np.max(FH[:,1]-FH[:,0]/T[i])



U = np.empty(len(T))
F = np.empty(len(T))
S = np.empty(len(T))
CV = np.empty(len(T))

for i in range(len(T)):
    U[i]=np.sum(FH[:,0]*np.exp(FH[:,1]-FH[:,0]/T[i]-maximumExpArray[i]))/np.sum(np.exp(FH[:,1]-FH[:,0]/T[i]-maximumExpArray[i]))
    F[i]=-T[i]*(maximumExpArray[i]+np.log(np.sum(np.exp(FH[:,1]-FH[:,0]/T[i]-maximumExpArray[i]))))
    S[i]=(U[i]-F[i])/T[i]
    CV[i]=((np.sum(FH[:,0]*FH[:,0]*np.exp(FH[:,1]-FH[:,0]/T[i]-maximumExpArray[i]))/np.sum(np.exp(FH[:,1]-FH[:,0]/T[i]-maximumExpArray[i]))) - U[i]*U[i])/(T[i]*T[i])
    

UT=np.array([T,U]).T
FT=np.array([T,F]).T
ST=np.array([T,S]).T
CVT=np.array([T,CV]).T

# save output avoiding NaN or Inf
UTClean=UT[np.isfinite(UT).all(axis=1)]
STClean=ST[np.isfinite(ST).all(axis=1)]
FTClean=FT[np.isfinite(FT).all(axis=1)]
CVTClean=CVT[np.isfinite(CVT).all(axis=1)]

np.savetxt(sys.argv[1]+"_U_T.dat", UTClean )
np.savetxt(sys.argv[1]+"_F_T.dat", FTClean )
np.savetxt(sys.argv[1]+"_S_T.dat", STClean )
np.savetxt(sys.argv[1]+"_CV_T.dat", CVTClean )

# shift S(T->0)=0, this also shifts F(T->0)=U(T->0)
minS0=STClean[0,1]
STCleanShifted = np.array([STClean[:,0], STClean[:,1]-minS0]).T
FTCleanShifted = np.array([FTClean[:,0], FTClean[:,1]+FTClean[:,0]*minS0]).T

np.savetxt(sys.argv[1]+"_F_T_shifted.dat", FTCleanShifted )
np.savetxt(sys.argv[1]+"_S_T_shifted.dat", STCleanShifted )



