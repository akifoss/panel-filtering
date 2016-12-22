## Sofia blastx pipeline spec

This repo contains a
[slurm-pipeline](https://github.com/acorg/slurm-pipeline) specification
file (`specification.json`) and associated scripts for processing Sofia's
samples using BLAST (specifically, blastx).

### Usage

It's assumed you've already run
[the first pipeline](https://github.com/acorg/sofia-pipeline) on the
samples you're interested in. This pipeline expects to find its initial
FASTQ input files in the `02-flash` directory of that pipeline.

To add processing for a sample. Do something like this:

```sh
$ mkdir 160211-25
$ cd 160211-25
$ git clone https://github.com/acorg/sofia-blastx-pipeline
$ make run
```

This will run `blastx` on all the reads for sample `160211-25`.

### Output

The scripts in `01-split`, `02-blastx`, etc. are all submitted by `sbatch`
for execution under [SLURM](http://slurm.schedmd.com/). The final step,
`03-panel` leaves its output in `03-panel/out` and
`03-panel/summary-virus`.

### Cleaning up

```sh
$ make clean-1
```

Note that this throws away all the intermediate work done by the pipeline.

### Cleaning up a bit more

```sh
$ make clean-2
```

Does a `make clean-1` and removes intermediate SLURM output log files.

### Really cleaning up

```sh
$ make clean-3
```

Does a `make clean-2` and also removes the final output in `03-panel/out`.
