#! /usr/bin/env bash



module load craype-accel-amd-gfx942
module load rocm
module load cray-mpich
module load cray-libsci


export LD_LIBRARY_PATH=${CRAY_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}

hipcc -O3 -DNDEBUG -fopenmp \
   ${PE_MPICH_GTL_DIR_amd_gfx942} ${PE_MPICH_GTL_LIBS_amd_gfx942} -I${CRAY_MPICH_DIR}/include \
   -L${CRAY_MPICH_DIR}/lib -lmpi \
   -o hello_jobstep hello_jobstep.cpp
