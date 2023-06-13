# `hello_jobstep`

This program is used to test process, thread, and GPU binding for job steps launched with Slurm's `srun` command. It prints the hardware thread IDs that each MPI rank and OpenMP thread runs on as well as the GPU IDs that each rank/thread has access to.

## Compiling

To compile, MPI, HIP, and an OpenMP-capable compiler will be needed. Modify the Makefile according to your needs.

### Included `Makefile` for Frontier

* CCE + CrayMPI

### Clone and build on Frontier

```
$ git clone https://code.ornl.gov/olcf/hello_jobstep.git
$ cd hello_jobstep
$ module load craype-accel-amd-gfx90a rocm
$ make
```

## Usage

To run, set the `OMP_NUM_THREADS` environment variable and launch the executable with `srun`. For example...

```
$ OMP_NUM_THREADS=1 srun -N2 -n16 -c7 --gpus-per-task=1 --gpu-bind=closest ./hello_jobstep | sort
MPI 000 - OMP 000 - HWT 001 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 4 - Bus_ID d1
MPI 001 - OMP 000 - HWT 009 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 5 - Bus_ID d6
MPI 002 - OMP 000 - HWT 017 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID c9
MPI 003 - OMP 000 - HWT 025 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID ce
MPI 004 - OMP 000 - HWT 033 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 6 - Bus_ID d9
MPI 005 - OMP 000 - HWT 041 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 7 - Bus_ID de
MPI 006 - OMP 000 - HWT 049 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c1
MPI 007 - OMP 000 - HWT 057 - Node frontier10227 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
MPI 008 - OMP 000 - HWT 001 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 4 - Bus_ID d1
MPI 009 - OMP 000 - HWT 009 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 5 - Bus_ID d6
MPI 010 - OMP 000 - HWT 017 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID c9
MPI 011 - OMP 000 - HWT 025 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID ce
MPI 012 - OMP 000 - HWT 033 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 6 - Bus_ID d9
MPI 013 - OMP 000 - HWT 041 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 7 - Bus_ID de
MPI 014 - OMP 000 - HWT 049 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID c1
MPI 015 - OMP 000 - HWT 057 - Node frontier10228 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID c6
```

### Explanation of Reported IDs

| ID          | Description                                              |
|:-----------:|----------------------------------------------------------|
| `MPI`       | MPI rank ID                                              |
| `OMP`       | OpenMP thread ID                                         |
| `HWT`       | CPU hardware thread the MPI rank or OpenMP thread ran on |
| `Node`      | Compute node the MPI rank or OpenMP thread ran on        |
| `GPU_ID`    | The node-level GPU ID the rank or thread had access to   |
| `RT_GPU_ID` | The runtime GPU ID the rank or thread had access to      |
| `Bus_ID`    | The physical bus ID associated with a GPU                |

#### ADDITIONAL NOTES:

* `GPU_ID` is the node-level (or global) GPU ID read from `ROCR_VISIBLE_DEVICES`. If this environment variable is not set (either by the user or by Slurm), the value of `GPU_ID` will be set to `N/A`.
* `RT_GPU_ID` is the HIP runtime GPU ID (as reported from, say `hipGetDevice`).
* `Bus_ID` is the physical bus ID associated with the GPUs. Comparing the bus IDs is meant to definitively show that different GPUs are being used.

## Examples

For examples, please see the [GPU Mapping section](https://docs.olcf.ornl.gov/systems/frontier_user_guide.html#gpu-mapping) of the Frontier User Guide. 

----------------
