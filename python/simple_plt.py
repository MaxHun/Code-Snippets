import matplotlib.pyplot as plt
plt.style.use('ggplot')
print(plt.style.available)
fig, ax = plt.subplots()
ax.plot([1,2,3])
plt.show()
