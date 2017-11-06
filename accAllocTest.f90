module my_acc_routines
public
contains
subroutine acc_alloc_test
  use my_cuda_routines
  use iso_c_binding
  implicit none
  real,pointer :: v1(:, :)
  real,allocatable :: v2(:, :)
  integer, parameter :: n=10
  integer :: i,j
  integer :: tmp
  integer :: res
  TYPE(c_ptr) :: myptr_cpu
  TYPE(c_ptr) :: myptr_gpu 
  real :: vres

  ! Without this print, it segfaults 
  print *,'Init' 
  res = my_cuda_malloc(myptr_cpu, n*n) 
  if(res .ne. 0) then
     print *, "Error: Allocation"
     stop
  endif 

  call c_f_pointer(myptr_cpu, v1, (/n,n/))
  
  allocate(v2(n,n))
 
  do j=1,n 
   do i=1,n
     v2(i,j) = j*n+i
   enddo
  enddo
   
!$acc data present(v1), copyin(v2)
 !$acc kernels
  do j=1,n
   do i=1,n
     v1(i,j) = v2(i,j)+ 42.
   enddo
  enddo
 !$acc end kernels
!$acc end data

!$acc update host(v1)

 print *, "vres  = ", v1(1,1)
  
end subroutine acc_alloc_test


end module