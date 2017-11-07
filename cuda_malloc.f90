module my_cuda_routines
  implicit none
  public
  interface
    function my_cuda_malloc(ptr, n) result(istat) &
          bind(C, name="my_cuda_malloc")
      use iso_c_binding
      type(C_PTR)                          :: ptr
      integer(C_INT), intent(in), value    :: n
      integer(C_INT)                       :: istat
    end function my_cuda_malloc
  end interface
contains
end module my_cuda_routines
