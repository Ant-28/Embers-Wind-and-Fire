import numpy as np
from main import AveragedFireArray
from windy import WindyFireArray
import os
import matplotlib.pyplot as plt
import gc
def get_reference():
    myFireArray = AveragedFireArray(60, 1, 0.3)
    center  = myFireArray.total_size // 2
    myFireArray.arr[center, center] = 1
    myFireArray.run_averaged(5, None, 1000)
    return myFireArray.get_av_lit_cells()

reference = get_reference()

@np.vectorize
def get_value(w, d0):
    gc.collect()
    print("Testing ", w, d0)
    myFireArray = WindyFireArray(60, 5, p0 = 0.3, p1 = 0.3, d0 = d0, w = w, theta = np.pi/3, a=0.01)
    # center  = myFireArray.total_size // 2
    # myFireArray.arr[center, center] = 1
    myFireArray.run_averaged(5, None, 100)
    return myFireArray.get_av_lit_cells()/reference

w_vals = np.arange(0, 21, 4)
d0_vals = np.arange(0.1, 2.2, 0.2)

# P1, D0 = np.meshgrid(p1_vals, d0_vals)

# Z = get_value(P1, D0)


with open("data6.txt", "w") as data:
    index_array = np.array(np.meshgrid(w_vals, d0_vals)).reshape(2, 66).T

    for w, d0 in index_array:
        # if p1*np.exp((-1)/d0) <= 0.4:
        data.write(f"{w} {d0} {get_value(w, d0)}\n")




# plt.contourf(P1, D0, Z, 100)


