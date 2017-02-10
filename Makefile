all:
	g++ -c cuda_malloc.cpp -I/global/opt/nvidia/cudatoolkit/7.0.28/include/ -I/opt/cray/cce/8.4.0/craylibs/x86-64/include/
	ftn -hacc accAllocTest.f90 cuda_malloc.o -lstdc++ -o accAllocTest
