import numpy as np
from main import AveragedFireArray
from sparked import AveragedSpFireArray
import os
import matplotlib.pyplot as plt
import gc
def get_reference():
    myFireArray = AveragedFireArray(100, 1, 0.3)
    center  = myFireArray.total_size // 2
    myFireArray.arr[center, center] = 1
    myFireArray.run_averaged(10, os.devnull, 1000)
    return myFireArray.get_av_lit_cells()

reference = get_reference()

@np.vectorize
def get_value(p1, d0):
    gc.collect()
    print("Testing ", p1, d0)
    myFireArray = AveragedSpFireArray(100, 5, p0 = 0.3, p1 = p1, d0 = d0)
    # center  = myFireArray.total_size // 2
    # myFireArray.arr[center, center] = 1
    myFireArray.run_averaged(10, os.devnull, 20)
    return myFireArray.get_av_lit_cells()/reference

p1_vals = np.arange(0.0, 1.1, 0.1)
d0_vals = np.arange(0.1, 1.1, 0.1)

# P1, D0 = np.meshgrid(p1_vals, d0_vals)

# Z = get_value(P1, D0)

with open("data6    .txt", "w") as data:
    index_array = np.array(np.meshgrid(p1_vals, d0_vals)).reshape(2, 110).T

    for p1, d0 in index_array:
        if p1*np.exp((-1)/d0) <= 0.4:
            data.write(f"{p1} {d0} {get_value(p1, d0)}\n")




# plt.contourf(P1, D0, Z, 100)


