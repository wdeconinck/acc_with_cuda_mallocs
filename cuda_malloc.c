#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#ifdef __cplusplus
extern "C" {
#endif
void my_acc_map_data(void* cpu_ptr, void* gpu_ptr, unsigned long size);
#ifdef __cplusplus
}
#endif


#ifdef __cplusplus
extern "C" {
#endif

int my_cuda_malloc(void** a_cpu, int n){
 *a_cpu = (void*) malloc(n*sizeof(double));
 void* a_gpu;
 int err = cudaMalloc( (void**)&a_gpu, n*sizeof(double));
 if( err ) return err;
 my_acc_map_data(*a_cpu, a_gpu, n*sizeof(double));
 return(err);
}

#ifdef __cplusplus
}
#endif

