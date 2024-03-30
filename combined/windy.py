from fireArray import *
from numpy.random import uniform as runif


def wfun(wxy: list[float], tij: list[float], a):
    dist = np.linalg.norm(tij)
    if dist > 0:
        return max(0.0, a*np.dot(wxy,tij)/dist)
    else:
        return 0

class WindyFireArray(FireArrayBase):


    def __init__(self, size: int, pad: int, p0: float, p1: float = 0, d0: float = 1, a: float = 0.01, w: float = 0, theta: float = 0):
        self.a = a
        self.w = w
        self.theta = theta
        self.wvec = np.array([w*np.cos(theta), w*np.sin(theta)])
        self.debug = True
    
        super().__init__(size, pad, p0, p1, d0)
        self.onesmat = np.ones(self.prop_kernel_mat.shape)
        self.zerosmat = np.zeros(self.prop_kernel_mat.shape)


    def default_prop_kernel(self):
        # define array for a distance 5

        kernel = np.zeros((11, 11))
        center = 11//2

        index_array = np.array(np.meshgrid(range(11), range(11))).reshape(2, 121).T
        index_array = index_array[:,[1, 0]]

        for i, j in index_array:
            txy = np.array([j - center, center - i])
            distance = np.linalg.norm(txy)
            
            kernel[i,j] = self.p1 * np.exp((1-distance)/self.d0) + wfun(self.wvec, txy, self.a)
        
        for i in range(center-1, center+2):
            for j in range(center - 1, center + 2):
                if i == center and j == center:
                    kernel[i,j] = 1
                else:
                    kernel[i,j] = self.p0 + wfun(self.wvec, txy, self.a)


        # print(kernel)

        # print(kernel)
        self.prop_kernel(kernel)
                    
    def check_cell(self, i: int, j: int) -> None:
        # i, j is the center of the kernel
        # assume kernel is odd to make calculation easier
        kernel_size = self.prop_kernel_mat.shape[0]
        corner      = kernel_size // 2
        kernel_data = np.multiply(self.prop_kernel_mat, runif(0.95, 1.05, self.prop_kernel_mat.shape))
        kernel_data = np.maximum(np.minimum(kernel_data, self.onesmat), self.zerosmat)
        if self.debug:
            print(kernel_data)
            self.debug = False
        rand_kernel = vec_rand_check(kernel_data)
        idx = np.ix_(np.arange(i-corner, i-corner+kernel_size),
                     np.arange(j-corner, j-corner+kernel_size))
        self.arr[idx] = np.bitwise_or(self.arr[idx], rand_kernel)


        