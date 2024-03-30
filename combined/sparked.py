from fireArray import *


class SparkedFireArray(FireArrayBase):
    
    def default_prop_kernel(self):
        # define array for a distance 5

        kernel = np.zeros((11, 11))
        center = 11//2

        index_array = np.array(np.meshgrid(range(11), range(11))).reshape(2, 121).T
        index_array = index_array[:,[1, 0]]

        for i, j in index_array:
            distance = np.linalg.norm(np.array([i - center, j - center]))
            kernel[i,j] = self.p1 * np.exp((1-distance)/self.d0)
        
        for i in range(center-1, center+2):
            for j in range(center - 1, center + 2):
                if i == center and j == center:
                    kernel[i,j] = 1
                else:
                    kernel[i,j] = self.p0


        # print(kernel)
        # print(kernel)


        self.prop_kernel(kernel)
    
class AveragedSpFireArray(SparkedFireArray):
    pass


def main():
    myFireArray = SparkedFireArray(100, 5, p0 = 0.4, p1 = 0.2, d0 = 0.2)
    center  = myFireArray.total_size // 2
    # myFireArray.arr[center, center] = 1
    myFireArray.run(10, "testfile_ember.txt")
    

    myFireArray = AveragedSpFireArray(100, 5, p0 = 0.4, p1 = 1, d0 = 1)
    center  = myFireArray.total_size // 2
    # myFireArray.arr[center, center] = 1
    myFireArray.run_averaged(10, "testfile_ember_avg.txt", 100)
    print("Embered Cells: ", myFireArray.get_av_lit_cells())

if __name__ == "__main__":
    main()