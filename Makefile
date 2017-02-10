all:
	nvcc -c cuda_malloc.cu -I/global/opt/nvidia/cudatoolkit/7.0.28/include/
	ftn -hacc accAllocTest.f90 cuda_malloc.o -lstdc++ -o accAllocTest
