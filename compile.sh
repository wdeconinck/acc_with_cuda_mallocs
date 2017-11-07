# To compile on ECMWF's lxg:
#     module unload gnu
#     module load pgi/16.7
#     module load cuda/cuda-7.5

ACC_FLAG="-acc -ta=tesla,cuda7.5,nordc"

CUDA_DIR=/opt/cuda/cuda-7.5
CUDA_INC="-I${CUDA_DIR}/include" 
CUDA_LINK="-Wl,-rpath,${CUDA_DIR}/lib64 ${CUDA_DIR}/lib64/libcudart.so" 

#CUDA_DIR=/usr/local/apps/pgi/pgi-16.7/linux86-64/2016/cuda/7.5
#CUDA_INC="-I${CUDA_DIR}/include" 
#CUDA_LINK="-Wl,-rpath,${CUDA_DIR}/lib64 ${CUDA_DIR}/lib64/libcudart.so" 

PGI_INC="-I/usr/local/apps/pgi/16.7/include"

# Function that calls acc_map_data (needs to be compiled with pgcc!)
pgcc ${PGI_INC} -fPIC -o my_acc_map_data.c.o -c my_acc_map_data.c
pgcc -shared -Wl,-soname,libmyAccMapData.so -o libmyAccMapData.so my_acc_map_data.c.o ${ACC_FLAG}

# Compile our code that allocates memory using cuda ( typically libatlas.so )
gcc ${CUDA_INC} -fPIC -o cuda_malloc.c.o -c cuda_malloc.c
pgfortran -fPIC -o cuda_malloc.f90.o  -c cuda_malloc.f90 
pgfortran -shared -Wl,-soname,libmy_cuda_malloc.so -o libmy_cuda_malloc.so \
  cuda_malloc.c.o cuda_malloc.f90.o ${CUDA_LINK} ${ACC_FLAG}

# Compile code that uses OpenACC directives ( typically shared library based on atlas )
pgfortran ${ACC_FLAG} -fPIC -o accAllocTest.F90.o  -c accAllocTest.F90 
pgfortran -shared -Wl,-soname,libaccAllocTest.so -o libaccAllocTest.so accAllocTest.F90.o ${ACC_FLAG}  ${CUDA_LINK} 

# Driver main program, unaware of any OpenACC or CUDA
pgfortran -fPIC -o main.f90.o  -c main.f90 

# Link shared
pgfortran main.f90.o -o acc_main ${CUDA_LINK} ${ACC_FLAG} -Wl,-rpath,$(pwd) \
  libmyAccMapData.so \
  libmy_cuda_malloc.so \
  libaccAllocTest.so

# To run:
#     salloc -n 1 --gres=gpu:1
#     srun acc_main_static
#     srun acc_main_shared






# Link statically
#pgfortran main.f90.o -o acc_main_static ${CUDA_LINK} ${ACC_FLAG} -Wl,-rpath,$(pwd) \
#  libmyAccMapData.so \
#  cuda_malloc.c.o cuda_malloc.f90.o \
#  accAllocTest.F90.o ${CUDA_LINK}