module my_cuda_routines
  implicit none
  public
  interface
     function my_cuda_malloc(ptr, n) result(istat) &
          bind(C, name="my_cuda_malloc")
     use iso_c_binding
     TYPE(C_PTR)                          :: ptr
     integer(C_INT), intent(in), value    :: n
     integer(C_INT)                       :: istat
     end function my_cuda_malloc
  end interface
end module my_cuda_routines

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
  
end program acc_alloc_test


