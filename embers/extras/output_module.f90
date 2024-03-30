! IMPORTANT!
! A LOT OF THIS CODE IS DERIVED FROM MY AM129 FINAL PROJECT, as well as Ian May's course website

module outputmodule
    use utility, only: fp, maxFileLen, maxStrLen
    implicit none
    private
    public write_float
    public write_clear
    public write_floatarr
    public write_newline
contains
    ! write float j to outfile
    ! user responsibility to write newline
    subroutine write_float(outfile, j)
          ! Open the output file and write the columns
    character(len=*), intent(in) :: outfile
    real (fp), intent(in) :: j
    ! append to eof, access is append
    open(20,file=outFile,status="old", access="append", position="append")
    ! doing some reading gives me this
    ! 1F = 1 float
    ! 16 = 16 chars
    ! 8 = 8 digits after dp
    ! advance = no means no newline
    write(20,"(1F17.8)",advance="no") j
    
    close(20)
    end subroutine write_float

    subroutine write_clear(outfile)
        character(len=*), intent(in) :: outfile
    
        open(20,file=outFile,status="replace")
        
        write(20,*) "" ! clear the file with replace
        
        close(20)
            
        end subroutine write_clear

    subroutine write_newline(outfile)
    character(len=*), intent(in) :: outfile

    open(20,file=outFile,status="replace")
    
    write(20,*) ""
    
    close(20)
        
    end subroutine write_newline
    ! write float array to file
subroutine write_floatarr(outfile, arr, N)
        ! Open the output file and write the columns
  character(len=*), intent(in) :: outfile
  real (fp), intent(in) :: arr(:,:)
  integer :: N,i,j
  open(20,file=outFile,status="old", access="append", position="append")
  ! doing some reading gives me this
  ! 1F = 1 float
  ! 16 = 16 chars
  ! 8 = 8 digits after dp
  ! advance = no means no newline
  do j = 4, N-3
    do i = 4, N-3
        write(20,"(1F40.16)",advance="no") arr(i,j)
    end do
  end do

  
  close(20)
  end subroutine write_floatarr
end module outputmodule