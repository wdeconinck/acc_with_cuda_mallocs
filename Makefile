all:
	g++ -c cuda_malloc.cpp -I/opt/cuda/cuda-7.5/include
	pgcc -c my_acc_map_data.c -I/usr/local/apps/pgi/16.7/include
	pgfortran -acc accAllocTest.f90 cuda_malloc.o my_acc_map_data.o -lstdc++ /opt/cuda/cuda-7.5/lib64/libcudart.so -o accAllocTest
