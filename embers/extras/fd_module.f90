! IMPORTANT!
! A LOT OF THIS CODE IS DERIVED FROM MY AM129 FINAL PROJECT

module fdmodule
    use utility, only: fp, maxStrLen
    use errormodule, only: checkerror
    use outputmodule, only: write_clear, write_float, write_floatarr, write_newline
    implicit none
    
    private
    integer, allocatable :: indices(:,:)
    real(fp), allocatable :: spark_indices(:,:)
    public :: propagate_onestep, propagate_onestep_sparked
    
contains
    ! WARNING!
    ! THIS REQUIRES A data/ folder instantiated

    subroutine propagate_onestep(arr, p, ndim, outfile)

        implicit none
        real(fp), intent(inout) :: arr(:,:)
        real(fp), intent(in) :: p
        integer, intent(in) :: ndim 
        character(len=maxStrLen), intent(in) :: outfile

        ! loop vars
        integer :: i ! row index
        integer :: j ! column index

        real(fp) :: ethreshold ! error threshold

        real(fp) :: rand ! random number
        integer :: icount

        integer :: temp, ind1, ind2
         ! ndim - 2 by 2 index


        call alloc_inds(ndim)

        indices = 0 ! set everything to zero

        icount = 1
        ! print *, icount
        ! io vars
       
        ethreshold = 1.0e-8
        rand = 0_fp


        do j=4, ndim-3
            do i=4, ndim-3
                ! continue if cell is one
                if ( abs(arr(i,j) - 1.0_fp) < ethreshold) then
                    ! print *, "i " , i, "j ",j, "arr ", arr(i,j)

                    ! unrolled garbage, ignore this
                    indices(icount , 1) = i - 1
                    indices(icount , 2) = j - 1

                    indices(icount + 1 ,1) = i 
                    indices(icount + 1 ,2) = j - 1

                    indices(icount + 2 ,1) = i + 1
                    indices(icount + 2 ,2) = j - 1

                    indices(icount + 3 ,1) = i - 1
                    indices(icount + 3 ,2) = j 

                    indices(icount + 4,1) = i + 1
                    indices(icount + 4,2) = j 
                    
                    indices(icount + 5,1) = i - 1
                    indices(icount + 5,2) = j + 1
                    
                    indices(icount + 6,1) = i
                    indices(icount + 6,2) = j + 1
                    
                    indices(icount + 7,1) = i + 1
                    indices(icount + 7,2) = j + 1

                    icount = icount + 8 ! set to next value

                else 
                    continue

                end if
                

            end do
        end do
        

        

        do i = 1, icount - 1 ! icount is the current write index
            ind1 = indices(i,1)
            ind2 = indices(i,2)
            call check_cell(arr, p, ind1, ind2, rand)
        end do
        call write_floatarr(outfile, arr, ndim)

     
        call dealloc_inds()

        
    end subroutine propagate_onestep


    subroutine propagate_onestep_sparked(arr, p, ndim, outfile)

        implicit none
        real(fp), intent(inout) :: arr(:,:)
        real(fp), intent(inout) :: p
        integer, intent(in) :: ndim 
        character(len=maxStrLen), intent(in) :: outfile

        ! loop vars
        integer :: i ! row index
        integer :: j ! column index

        real(fp) :: ethreshold, dist ! error threshold

        real(fp) :: rand ! random number
        integer :: icount

        integer :: temp, temp2, ind1, ind2
         ! ndim - 2 by 2 index

        ethreshold = 1.0e-8


        call propagate_onestep(arr, p, ndim, outfile)

        call alloc_outerinds(ndim)

        spark_indices = 0.0_fp
        icount = 1
        do j=4, ndim-3
            do i=4, ndim-3
                ! continue if cell is one
                if ( abs(arr(i,j) - 1.0_fp) < ethreshold) then
                    ! print *, "i " , i, "j ",j, "arr ", arr(i,j)

                    ! unrolled garbage, ignore this
                    ! top row, distance 2
                    do temp=0,4
                        ! print*, icount
                        spark_indices(icount + temp, 1) = i - 2 + temp
                        spark_indices(icount + temp, 2) = j - 2
                        spark_indices(icount + temp, 3) = sqrt(real((i-2 + temp - i)**2 + 4, kind = fp));
                        
                    end do

                    icount = icount + temp
                    do temp2=0,2
                        
                        spark_indices(icount, 1) = i - 2 
                        spark_indices(icount, 2) = j - 1 + temp2
                        spark_indices(icount, 3) = sqrt(real(4 + (temp2 - 1)**2, fp));

                        spark_indices(icount + 1, 1) = i + 2 
                        spark_indices(icount + 1, 2) = j - 1 + temp2
                        spark_indices(icount + 1, 3) = sqrt(real(4 + (temp2 - 1)**2, fp));
                            
                            icount = icount + 2

                        
                    end do
                    
                    do temp=0,4
                        spark_indices(icount + temp, 1) = i - 2 + temp
                        spark_indices(icount + temp, 2) = j + 2
                        spark_indices(icount + temp, 3) = sqrt(real(4 + (temp - 2)**2, fp))
                    end do
                    icount = icount + temp

                    ! distance 3
                    do temp=0,6
                        spark_indices(icount + temp, 1) = i - 3 + temp
                        spark_indices(icount + temp, 2) = j - 3
                        spark_indices(icount + temp, 3) = sqrt(real(9 + (temp - 3)**2, fp))
                    end do

                    icount = icount + temp
                    do temp2=0,4
                        
                        spark_indices(icount, 1) = i - 3
                        spark_indices(icount, 2) = j - 2 + temp2
                        spark_indices(icount, 3) = sqrt(real(9 + (temp - 2)**2, fp))
                        spark_indices(icount + 1, 1) = i + 3 
                        spark_indices(icount + 1, 2) = j - 2 + temp2
                        spark_indices(icount + 1, 3) = sqrt(real(9 + (temp - 2)**2, fp))

                            
                            icount = icount + 2

                        
                    end do
                    
                    do temp=0,6
                        spark_indices(icount + temp, 1) = i - 2 + temp
                        spark_indices(icount + temp, 2) = j + 3
                        spark_indices(icount + temp, 3) = sqrt(real(9 + (temp - 2)**2, fp))
                    end do
                    icount = icount + temp
                    ! set to next value

                else 
                    continue

                end if
                

            end do
        end do

        ! add probability

        do i = 1, icount - 1 ! icount is the current write index
            ind1 = int(spark_indices(i,1))
            ind2 = int(spark_indices(i,2))
            ! print *, "ind1: ", ind1, "ind2: ", ind2
            dist = spark_indices(i,3)
            call check_cell(arr, p*exp(-dist + 1.0_fp), ind1, ind2, rand)
        end do



        call dealloc_outerinds()


        
    end subroutine propagate_onestep_sparked

    subroutine check_cell(arr, p, i, j, rand)
        real(fp), intent(inout) :: arr(:,:)
        real(fp), intent(in) :: p
        
        ! loop vars
        integer, intent(in) :: i ! row index
        integer, intent(in) :: j ! column index

        real(fp), intent(inout) :: rand ! random number

        real(fp) :: ethreshold ! error threshold

        

        ethreshold = 1.0e-8

        call random_number(rand)
        ! ignore cells that are already one
        
        if (( rand < p ) .and. abs(arr(i,j) - 1.0_fp) > ethreshold) then
            ! print *, "ding!"
            arr(i,j) = 1.0_fp
        end if

   end subroutine check_cell

   subroutine alloc_inds(ndim)
    integer, intent(in) :: ndim
    integer :: temp
    temp = ((ndim - 4) ** 2)*8
    allocate(indices(temp, 2))
    
   end subroutine alloc_inds

   subroutine alloc_outerinds(ndim)
    integer, intent(in) :: ndim
    integer :: temp
    temp = ((ndim - 4) ** 2)*40 ! 40 outer cells to worry about
    allocate(spark_indices(temp, 3))
    
   end subroutine alloc_outerinds



   subroutine dealloc_inds
    deallocate(indices) 
    
   end subroutine dealloc_inds

   subroutine dealloc_outerinds
    deallocate(spark_indices)
    
   end subroutine dealloc_outerinds


    
end module fdmodule