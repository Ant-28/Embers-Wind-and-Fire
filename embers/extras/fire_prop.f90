! WARNING!
! THIS REQUIRES A data/ folder instantiated
program fireprop
    
    use setupmodule, only : ndim, p, nsteps, problemsetup_Init 
    use fdmodule, only: propagate_onestep, propagate_onestep_sparked
    use utility, only: fp, maxStrLen
    use errormodule, only: checkerror ! dead code
    use outputmodule, only: write_float, write_clear, write_floatarr
    implicit none
    real (fp), allocatable :: arr(:, :)
    
    integer :: t
    character(len=maxStrLen) :: outfile, runName

    ! step 1, call the setup module
    call problemsetup_Init("setup_module.init")

    call allocate_data()

    ! print *,ndim, p, nsteps
    write(runName,"('sol_',I0.3)") ndim
    outfile = "data/" // trim(runName) // '.dat' 

    arr = 0.0_fp
    arr((ndim+1)/2, (ndim+1)/2) = 1.0_fp
    call write_clear(outfile) ! clear the file
    do t = 1, nsteps
      call propagate_onestep(arr, p, ndim+6, outfile); ! +6 for guard cells :whatthink:
    end do
    

    call deallocate_data()


    call allocate_data()

    ! print *,ndim, p, nsteps
    write(runName,"('sol_',I0.3)") ndim
    outfile = "data/" // trim(runName) // '_sparky.dat' 

    arr = 0.0_fp
    arr((ndim+1)/2, (ndim+1)/2) = 1.0_fp
    call write_clear(outfile) ! clear the file
    do t = 1, nsteps
      call propagate_onestep_sparked(arr, p, ndim+6, outfile); ! +6 for guard cells :whatthink:
    end do
    

    call deallocate_data()

contains

subroutine allocate_data()
    implicit none
    ! alloc with guard cells
    allocate(arr(ndim+6,ndim+6))
    
  end subroutine allocate_data

  subroutine deallocate_data()
    implicit none
    deallocate(arr)
  end subroutine deallocate_data


end program fireprop