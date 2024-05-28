# pyright: basic
import numpy as np
import matplotlib.pyplot as plt

alphas = np.arange(0, 1.1, 0.1)

income_ys = []
emissions_ys = []
cost_ys = []

for alpha in alphas:
    f1 = 150 - 20 * (1-alpha)
    f2 = 30 + 5 * (1-alpha)
    f3 = 70 + 10 * (1-alpha)
    s1 = 100 + 10 * (1-alpha)
    s2 = 50 + 5 * (1-alpha)

    income_ys.append(f1)
    emissions_ys.append(f2)
    cost_ys.append(f3)

income_xs = [216.667, 214.641, 212.615, 210.59,
             208.564, 206.538, 204.513, 199, 190, 181, 172]
emissions_xs = [21.6667,  21.7778, 21.8889, 22, 22.1111,
                22.2222, 22.3333, 22.4444, 22.5556, 22.6667, 22.7778]
cost_xs = [22.2059, 22.2721, 22.3382, 22.4044, 22.4706,
           22.5368, 22.6029, 22.6691, 22.7353, 22.8015, 22.8676]

plt.subplot(3, 1, 1)
plt.title("Income")
plt.plot(income_ys, alphas, label="µ_G(x)")
plt.plot(income_xs, alphas, label="µ_f(x)")
plt.ylabel('α')
plt.grid(True)
plt.legend()

plt.subplot(3, 1, 2)
plt.title("Emissions")
plt.grid(True)
plt.plot(emissions_ys, alphas, label="µ_G(x)")
plt.plot(emissions_xs, alphas, label="µ_f(x)")
plt.ylabel('α')
plt.legend()

plt.subplot(3, 1, 3)
plt.title("Cost")
plt.grid(True)
plt.plot(cost_ys, alphas, label="µ_G(x)")
plt.plot(cost_xs, alphas, label="µ_f(x)")
plt.ylabel('α')
plt.legend()

plt.show()
