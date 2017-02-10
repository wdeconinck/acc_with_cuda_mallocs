module my_cuda_routines
  implicit none
  public
  interface
     function cuda_malloc(ptr, n) result(istat) &
          bind(C, name="cuda_malloc")
     use iso_c_binding
     TYPE(C_PTR)                          :: ptr
     integer(C_INT), intent(in), value    :: n
     integer(C_INT)                       :: istat
     end function cuda_malloc
  end interface
end module my_cuda_routines

subroutine test_fill(n, v1, v2) 
  implicit none
  integer :: n
  real, intent(out) :: v1(n, n)
  real, intent(in) :: v2(n, n)
  integer :: i,j

 !$acc kernels deviceptr(v1) copyin(v2)
  do j=1,n
   do i=1,n
     v1(i,j) = v2(i,j)+ 42.
   enddo
  enddo
 !$acc end kernels

end subroutine test_fill

subroutine test_res(n, v1, vres) 
  implicit none
  integer :: n
  real, intent(in) :: v1(n, n)
  real, intent(out) :: vres
  integer :: i,j

 !$acc kernels deviceptr(v1) copyout(vres)
     vres = v1(1,1)
 !$acc end kernels

end subroutine test_res



program acc_alloc_test
  use my_cuda_routines
  use iso_c_binding
  implicit none
  real,pointer :: v1(:, :)
  real,allocatable :: v2(:, :)
  integer, parameter :: n=10
  integer :: i,j
  integer :: tmp
  integer :: res
  TYPE(c_ptr) :: myptr 
  real :: vres
  
  
  res = cuda_malloc(myptr, n*n) 
  if(res .ne. 0) then
     print *, "Error: Allocation"
     stop
  endif 
  call c_f_pointer(myptr, v1, (/n,n/))
  
  allocate(v2(n,n))
 
  do j=1,n 
   do i=1,n
     v2(i,j) = j*n+i
   enddo
  enddo
   
  call test_fill(n, v1, v2)
  call test_res(n, v1, vres)

  print *, "vres  = ", vres
  
end program acc_alloc_test


