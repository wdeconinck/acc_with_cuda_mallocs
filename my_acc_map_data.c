#include <openacc.h>
void my_acc_map_data(void* cpu_ptr, void* gpu_ptr, unsigned long size)
{
  acc_map_data(cpu_ptr, gpu_ptr, size);
}
