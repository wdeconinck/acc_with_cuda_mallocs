#include <stdlib.h>
#include <cuda_runtime.h>
extern "C" {
  int  cuda_malloc(size_t** a, int n){
     int err = cuda_malloc(a, n*sizeof(double));
     return(err);
  }
}

