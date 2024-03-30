module errormodule
    use utility, only : fp
    implicit none


    private

    real (fp), public :: e = 1e-6

    public :: checkerror

contains
    ! checks error condition for diffusion
    subroutine checkerror(a, b, N, dt, val)
        ! val = 1 if true, 0 if false
        implicit none
        real (fp), intent(in) :: a(:)
        real (fp), intent(in) :: b(:)
        real (fp), intent(in) :: dt
        integer, intent(in) :: N
        integer, intent(out) :: val

        ! subroutine variables
        real(fp) :: norm
        integer :: i
        
        norm = 0.0_fp
        do  i = 2,N+1
            norm = norm + abs(b(i) - a(i))
        end do
        norm = norm * 1/(N*dt);
     
        
        if ( norm < 1e-6 ) then
            val = 1
        else
            val = 0
        end if

    end subroutine checkerror
    
end module errormodule