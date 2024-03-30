from fireArray import *


class OriginalFireArray(FireArrayBase):

    def prop_kernel(self, data=np.ndarray):

        return super().prop_kernel(data)
    
class AveragedFireArray(FireArrayBase):

    def prop_kernel(self, data=np.ndarray):

        return super().prop_kernel(data)

def main():
    myFireArray = OriginalFireArray(100, 1, 0.4)
    center  = myFireArray.total_size // 2
    myFireArray.arr[center, center] = 1
    myFireArray.run(10, "testfile.txt")
    # print("Lit Cells: ", myFireArray.get_lit_cells())

    myFireArray = AveragedFireArray(100, 1, 0.4)
    center  = myFireArray.total_size // 2
    myFireArray.arr[center, center] = 1
    myFireArray.run_averaged(10, "testfile_avg.txt", 100)
    print("Lit Cells: ", myFireArray.get_av_lit_cells())

if __name__ == "__main__":
    main()
    