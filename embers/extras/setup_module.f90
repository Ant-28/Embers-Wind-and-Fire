! IMPORTANT!
! A LOT OF THIS CODE IS DERIVED FROM MY AM129 FINAL PROJECT, as well as Ian May's course website
! File: problemsetup.f90
! Purpose: Define problem specific information
! Comments: The read_initFile* subroutines were taken from Prof. Lee's
!           Newton's method example code

module setupmodule

   use utility, only : fp, maxFileLen, maxStrLen

   implicit none
   private

   integer, public :: ndim  ! n points
   real(fp), public :: p ! advection
   integer, public :: nsteps ! diffusion
   
   
   ! Number of grid points to use in the discretization
   character(len=maxStrLen), public :: runName, outFile ! Name of the run and the output file the code should write

   public :: problemsetup_Init


contains


   ! subroutine: problemsetup_Init
   ! purpose: Set module variables to values defined in an input file
   ! inputs: inFile -- String with name of input file to be read
   ! outputs: <none>
   subroutine problemsetup_Init(inFile)
      implicit none
      character(len=*), intent(in) :: inFile

      ! Fill in default values
      ndim = 100
      p = 0.4_fp
      nsteps = 10

      ! Read problem resolution
      ndim = read_initFileInt(inFile,'ndim')
      p = read_initFileReal(inFile, 'prob')
      nsteps = read_initFileInt(inFile, 'nsteps')

      ! Set the name of the run from the number of points and index
      ! write(runName,"('sol_',I0.3)") N
      ! print *, 'Running problem: ', runName

      ! ! Set the output file, note that // does string concatenation
      ! outFile = 'data/' // trim(runName) // '.dat'
   end subroutine problemsetup_Init

   ! function: read_initFileInt
   ! purpose: Pull one integer value from an input file
   ! inputs: inFile -- String holding the name of the input file
   !         varName -- String that names the variable, this must be first entry on a line
   ! outputs: varValue -- Integer value that will hold the result from the input file


   function read_initFileInt(inFile,varName) result(varValue)

      implicit none
      character(len=*),intent(IN) :: inFile,varName
      integer :: varValue

      integer :: i,openStatus,inputStatus
      integer :: simInitVars
      character(len=maxStrLen) :: simCharVars
      integer :: pos1,pos2

      open(unit = 11, file=inFile, status='old',IOSTAT=openStatus,FORM='FORMATTED',ACTION='READ')

      do i=1,maxFileLen
         read(11, FMT = 101, IOSTAT=inputStatus) simCharVars
         pos1 = index(simCharVars,varName)
         pos2 = pos1+len_trim(varName)
         if (pos2 > len_trim(varName)) then
            read(simCharVars(pos2+1:),*)simInitVars
            varValue = simInitVars
         endif
      end do

      close(11)

101   FORMAT(A, 1X, I5)

   end function read_initFileInt

   function read_initFileReal(inFile,varName) result(varValue)


      implicit none

      character(len=*),intent(IN) :: inFile,varName

      real (fp) :: varValue


      integer :: i,openStatus,inputStatus

      real :: simInitVars

      character(len=maxStrLen) :: simCharVars

      integer :: pos1,pos2
      open(unit = 10, file=inFile, status='old',IOSTAT=openStatus,FORM='FORMATTED',ACTION='READ')
      do i=1,maxFileLen
         read(10, FMT = 100, IOSTAT=inputStatus) simCharVars
         pos1 = index(simCharVars,varName)
         pos2 = pos1 + len_trim(varName)
         if (pos2 > len_trim(varName)) then
            read(simCharVars(pos2 + 1:),*) simInitVars
            varValue = simInitVars

         endif

      end do


      close(10)


100   FORMAT(A, 1X, F3.1)


   end function read_initFileReal

end module setupmodule

