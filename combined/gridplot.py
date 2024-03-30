from windy import WindyFireArray
import numpy as np 
import matplotlib.pyplot as plt
import matplotlib
# np.set_printoptions(precision=2)
d0_arr = [0.5, 1, 2]
w_arr = [0, 10, 20]
fig, axs = plt.subplots(3,3, figsize=(800/96, 800/96), dpi=96)

plt.rcParams['text.usetex'] = True


def test(w, d0, i:int, j:int):
    size = 60
    testarr = WindyFireArray(size = 60, pad = 5, p0 = 0.3, p1 = 0.3, d0=d0, theta = np.pi/3, w = w, a = 0.01)
    M = np.zeros((testarr.total_size,testarr.total_size))
    trials = 100
    
    testarr.run_averaged(t=5, filename=None, runs = trials)
    M = testarr.avearr[-1,:,:]
    # testarr.reset()

    
    # center  = testarr.total_size // 2
    # center2 = 11//2
    # a = 5
    # b = a + 1

    # arr = abs(np.divide(np.subtract(M[center-a:center+b, center-a:center+b], testarr.prop_kernel_mat[center2-a:center2+b, center2-a:center2+b]), testarr.prop_kernel_mat[center2-a:center2+b, center2-a:center2+b]))
    # # print(abs(np.divide(np.subtract(M[center-a:center+b, center-a:center+b], testarr.prop_kernel_mat[center2-a:center2+b, center2-a:center2+b]), testarr.prop_kernel_mat[center2-a:center2+b, center2-a:center2+b])))
    # # print(testarr.prop_kernel_mat)

    
    
    matplotlib.rcParams.update({'font.size': 24})
    im = axs[i,j].imshow(M[5:size + 5 + 1, 5:size + 5 + 1], interpolation = 'none')
    
    if i == 0:
        axs[i,j].set_title(r"$d_0 = {0}$".format(d0), fontsize = 18)
        # axs[i,j].set_xlabel(r"$x$", fontsize = 18)
    if j == 0:
        axs[i,j].set_ylabel(r"$w = {0}$".format(w), fontsize = 18)
    axs[i,j].set_xticks(list(range(0,size+1,10)),[1, 10, 20, 30, 40, 50, 60])
    axs[i,j].set_yticks(list(range(0,size+1,10)),[1, 10, 20, 30, 40, 50, 60])
    # plt.xlabel("i", fontsize = 22), 
    # plt.ylabel("j", fontsize = 22)
    # plt.xlim([0, 10], fontsize = 22)
    # plt.ylim([0, 10], fontsize = 22)
    # plt.title("Error matrix, with indices i,j")
    # cbar = plt.colorbar(im)
    # cbar.set_label("Relative Error", rotation=90)


for i in range(3):
    for j in range(3):
            test(w = w_arr[i], d0 = d0_arr[j], i=i, j=j)
plt.tight_layout()
plt.show()

fig.savefig('qual_result_combini.svg')