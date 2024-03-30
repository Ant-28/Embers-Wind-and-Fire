# Fire prop algo
# Draft in python for easier impl and later fortran port
# create a fire array
import numpy as np
# template class for users to modify

def rand_check(p):
    return 1 if np.random.rand() < p else 0

vec_rand_check = np.vectorize(rand_check)
class FireArrayBase:
    def __init__(self, size: int, pad: int, p0: float, p1: float = 0, d0: float = 1):
        # make array of size size + pad 
        self.size = size
        self.pad = pad
        self.total_size = size+2*pad
        self.arr = np.zeros((size+2*pad, size+2*pad), dtype=int)
        self.p0 = p0
        self.p1 = p1
        self.d0 = d0
        self.default_prop_kernel()
        self.setArr()
        self.avearr = None
        assert(self.pad == self.prop_kernel_mat.shape[0]//2)
        
    def setArr(self):  # user-defined
        self.arr = np.zeros((self.size+2*self.pad, 
                             self.size+2*self.pad), dtype=int)
        center  = self.total_size // 2
        self.arr[center, center] = 1
        

    def prop_kernel(self,data : np.array):
        self.prop_kernel_mat = data

    def default_prop_kernel(self):
        self.prop_kernel(np.array([
        [self.p0, self.p0, self.p0],
        [self.p0, 1      , self.p0],
        [self.p0, self.p0, self.p0],
        ]))
        

    def propagate_onestep(self) -> np.ndarray:
        for i, j in zip(*self.arr.nonzero()):
                self.check_cell(i, j)

    def check_cell(self, i: int, j: int) -> None:
        # i, j is the center of the kernel
        # assume kernel is odd to make calculation easier
        kernel_size = self.prop_kernel_mat.shape[0]
        corner      = kernel_size // 2
        rand_kernel = vec_rand_check(self.prop_kernel_mat)
        idx = np.ix_(np.arange(i-corner, i-corner+kernel_size),
                     np.arange(j-corner, j-corner+kernel_size))
        self.arr[idx] = np.bitwise_or(self.arr[idx], rand_kernel)

        
        # for row in range(0, kernel_size):
        #     for col in range(0, kernel_size):
        #         # get matrix row and col
        #         matrow = i - corner + row
        #         matcol = j - corner + col
        #         prob = self.prop_kernel_mat[row][col]
        #         if np.random.rand() < prob and ((matrow, matcol) != (i,j)):
        #             self.arr[matrow][matcol] = 1

    # TODO: FILE management
    def write_to_file(self, filename: str, arr: np.ndarray):
        with open(filename, "a+") as outfile:
            idx_range = np.ix_(np.arange(self.pad, self.size + self.pad),
                               np.arange(self.pad, self.size + self.pad))
            np.savetxt(outfile, arr[idx_range].reshape(1, -1), fmt = "%0.3f")
    
    def clear_file(self, filename: str):
        with open(filename, "w") as outfile:
            outfile.write("")

    def run(self, t: int, filename: str):
        self.clear_file(filename)
        for i in range(t):
            print(f"Running timestep: {i}")
            self.propagate_onestep()
            self.write_to_file(filename, self.arr)

    def run_averaged(self, t: int, filename: str, runs: int = 100):
        self.clear_file(filename)
        data = np.zeros((t, self.total_size, self.total_size))
        # print(self.prop_kernel_mat)
        for _ in range(runs):
            if _ % 10 == 0:
                # print("Averaged Run Number: ", _)
                pass
            for i in range(t):                
                self.propagate_onestep()
            data[i] += self.arr
                
            self.reset()

        data /= runs

        self.avearr = data

        for i in range(t):
            self.write_to_file(filename, data[i,:,:])

    def get_lit_cells(self):
        

        return np.sum(self.arr)
    
    def get_av_lit_cells(self):

        return np.sum(self.avearr)


    def reset(self):
        self.setArr()


    



