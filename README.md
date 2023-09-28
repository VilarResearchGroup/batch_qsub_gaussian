# High-throughput Gaussian job submission on the Imperial HPC

Bash scripts and instructions to submit a large batch of Guassian calculations on the Imperial HPC.

__Note__: The Imperial HPC queuing system only allows a user to submit 50 jobs at a time to the queue.

## Contents

- `scripts/` Contains all of the bash shell scripts required.
- `test_run/` Contains a resettable example of how to use the scripts.

## Workflow

1. Connect to the Imperial HPC via ssh in the terminal.

    ```
    $ ssh <username>@login.hpc.imperial.ac.uk
    ```

1. Create and navigate to a new working directory.

    ```
    $ mkdir <new_dir>
    $ cd <new_dir>
    ```

1. Copy no more than 50 Gaussian input files (.gjf) you wish to submit and paste into the new working directory.

    ```
    cp <path_to_gjf> <new_dir>
    ```

1. Copy all scripts in `scripts/` and paste into the same working directory.

   ```
   cp scripts/* <new_dir>
   ```

1. Submit jobs using the `batch_qsub.sh` script.

    ```
    $ bash batch_qsub.sh
    ```

1. View the status of jobs.

    ```
    $ qstat
    ```

1. Export Gaussian output files (.log) using the `export_output.sh` script when jobs are finished.

   ```
   $ bash export_output
   ```

1. All output files will be located in `output/`.

## Test run

1. Navigate into `test_run/`.

    ```
    $ cd test_run/
    ```

1. Execute the batch submission script.

    ```
    $ bash batch_qsub.sh
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
    $ qstat
    > <output_table>
    ```

1. Once all of the jobs have finished (approx. 10 min) execute export script.

    ```
    $ bash export_output.sh
    > Exported 7 log files.
    ```

1. Check the contents of `output/`.

    ```
    $ ls output/
    > vilar_ethanol.log
    > vilar_iso_propanol.log
    > ...
    > vilar_tert_butanol
    ```

1. To reset the test execute the reset script.

    ```
    $ bash reset_test.sh
    > Test reset.
    ```