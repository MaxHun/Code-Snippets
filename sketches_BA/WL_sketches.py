import numpy as np
from matplotlib import pyplot as plt 

x = np.linspace(0,1,500)
y = np.ones(len(x))
y[100]=3
y[200]=3
plt.plot(x,y)
plt.show()
