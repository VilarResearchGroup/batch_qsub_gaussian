# High-throughput Gaussian job submission on the Imperial HPC

Bash scripts and instructions to submit a large batch of Guassian calculations on the Imperial HPC.

__Note__: The Imperial HPC queuing system only allows a user to submit 50 jobs at a time to the queue.

This project is written for UNIX systems.

## Contents

- `scripts/` Contains all of the bash shell scripts required.
- `test_run/` Contains a resettable example of how to use the scripts.

## Workflow

1. Connect to the Imperial HPC via ssh in the terminal.

    ```
    ssh <username>@login.hpc.imperial.ac.uk
    ```

1. Create and navigate to a new working directory.

    ```
    mkdir <new_dir>
    cd <new_dir>
    ```

1. Copy no more than 50 Gaussian input files (.gjf) you wish to submit and paste into the new working directory.

    ```
    cp <path_to_gjf> <new_dir>
    ```

1. Copy all scripts in `scripts/` and paste into the same working directory.

    ```
    cp scripts/*.sh <new_dir>
    ```

1. Submit jobs using the `batch_qsub.sh` script.

    ```
    bash batch_qsub.sh
    ```

1. View the status of jobs.

    ```
    qstat
    ```

1. Another useful command is to list the number of output files (.log) are present in the working directory.

    ```
    find . -type f -iname "*.log" | wc -l
    ```

1. Alternatively, the number jobs that terminated normally or with errors can be counted.

    ```
    grep -rl "Normal termination" --include="*.log" --include="*.LOG" | wc -l
    grep -rl "Error termination" --include="*.log" --include="*.LOG" | wc -l
    ```

1. Export Gaussian output files (.log) using the `export_output.sh` script when jobs are finished.

    ```
    bash export_output.sh
    ```

1. All output files will be located in either `norm_term/` or `err_term/`.

## Test run

1. Navigate into `test_run/`.

    ```
    cd test_run/
    ```

1. Execute the batch submission script.

    ```
    bash batch_qsub.sh
    ```

    Example output:

    ```
    > Submitting vilar_ethanol
    > <job_id>
    > Submitting vilar_iso_propanol
    > <job_id>
    > ...
    > Submitting vilar_tert_butanol
    > <job_id>
    ```

1. Check the status of the jobs.

    ```
    qstat
    ```

    Example output:

    ```
    > <output_table>
    ```

1. Once all of the jobs have finished (approx. 10 min) execute export script.

    ```
    bash export_output.sh
    ```

    Example output:

    ```
    > Exported 7 log files.
    ```

1. Check the contents of `output/`.

    ```
    ls output/
    ```

    Example output:

    ```
    > vilar_ethanol.log
    > vilar_iso_propanol.log
    > ...
    > vilar_tert_butanol
    ```

1. To reset the test execute the reset script.

    ```
    bash reset_test.sh
    ```

    Example output:

    ```
    > Test reset.
    ```

## Converting output files to SDF

1. Copy and paste the output files in `output/` to a local directory. This is because you cannot access Openbabel on the HPC.

1. Ensure `obabel` is installed on your virtual environment.

    ```
    conda install -c conda-forge openbabel
    ```

1. _(Optional)_ In your working directory with all of the .log files, move all files to a new directory. This might make importing the `.sdf` files easier later on.

    ```
    mkdir <new_dir/>
    mv *.log <new_dir/>
    ```

1. Use Openbabel in the Terminal to convert from `.log` to `.sdf`.

    ```
    obabel *.log -osdf -m
    obabel <new_dir/>*.log -osdf -m
    ```

1. It is possible to convert to other file types. Search the type of input and output file types Openbabel accepts. The `-m` option is required when multiple files are being converted.

    ```
    obabel -L formats read
    obabel -L formats write
    obabel *.log -o<file_extension> -m
    ```
