#include <stdlib.h>
#include <cuda_runtime.h>
extern "C" {
  int  my_cuda_malloc(size_t** a, int n){
     int err = cudaMalloc(a, n*sizeof(double));
     return(err);
  }
}

