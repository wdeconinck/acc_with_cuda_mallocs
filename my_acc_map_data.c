#include <openacc.h>
//#include <stdlib.h>
//#include <stdio.h>
void my_acc_map_data(void* cpu_ptr, void* gpu_ptr, unsigned long size)
{
    //printf("+ my_acc_map_data\n"); fflush(stdout);
    acc_map_data(cpu_ptr, gpu_ptr, size);
    //printf("- my_acc_map_data\n"); fflush(stdout);
}
