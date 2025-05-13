# Cluster Testing Workflow

This Nextflow script is designed to test different properties of a SLURM cluster setup.
It creates multiple instances of a cluster job based on predefined flavor configurations and executes them on the cluster.

## Requirements

To run this workflow, you need:

*   A SLURM cluster setup with a working configuration (e.g., `sbatch`, `squeue` commands)
*   Nextflow installed on the master node. Check the Nextflow website for the official installation guide: https://www.nextflow.io/docs/latest/install.html#install-nextflow 
*   Docker installed on all worker nodes 
*   A shared directory between all nodes
*   A `/vol/scratch` directory available on all worker nodes

## Running the Workflow

To run the workflow, clone the repository in a shared directory, navigate to the repository directory in your terminal and execute the following command:

```bash
NXF_VER=24.10.4 nextflow run test.nf -with-trace -profile slurm
```

The `--trace` option is required to enable detailed logging of the workflow execution. This will provide valuable information for debugging purposes.
In case the workflow fails, look for the job information in the trace*.txt file. Check the Nextflow website for an explanation for all [columns](https://www.nextflow.io/docs/latest/reports.html#trace-file).
The columns "status" and "hash" are of particular interest. "Status" specifies which jobs have failed, and "hash" specifies where to find the job output in the work directory.

### Options

The workflow can also be executed on the local system by specifying the `-profile local` parameter.

## Properties Tested

If the workflow finishes successfully, it indicates that the cluster has passed the following tests:

*   Job submission and management: The script submits multiple jobs to the cluster and verifies that they are executed correctly.
*   Resource allocation: The script checks that the allocated resources (CPU, memory) are sufficient for each job.
*   `/vol/scratch` is available on each node.
*   Docker is installed on each node.
*   A directory is shared between all nodes.
