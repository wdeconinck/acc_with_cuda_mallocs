#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#include "openacc.h"
extern "C" {
  int  my_cuda_malloc(size_t** a_cpu, int n){
     size_t** a_gpu;
     *a_cpu = (size_t*) malloc(n*sizeof(double));
     int err = cudaMalloc(a_gpu, n*sizeof(double));
     acc_map_data(*a_cpu, *a_gpu, n*sizeof(double));

     return(err);
  }
}

