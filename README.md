## panel-filtering spec

This repo contains a
[slurm-pipeline](https://github.com/acorg/slurm-pipeline) specification
file (`specification.json`) and associated scripts for filtering
BLAST results (specifically, blastx) and creating a panel.

### Usage

It's assumed you've already run
[the pipeline](https://github.com/acorg/sofia-blastx-pipeline) on the
samples you're interested in.

To add processing for a sample. Do something like this:

```sh
$ mkdir 160211-25
$ cd 160211-25
$ git clone https://github.com/akifoss/panel-fitering
$ make run
```

This will run `panel.sh` on all the blast results for sample `160211-25`.

### Output

The scripts in `01-panel`, `02-stop`, etc. are all submitted by `sbatch`
for execution under [SLURM](http://slurm.schedmd.com/). `01-panel` 
leaves its output in `01-panel/out` and `01-panel/summary-virus`.

### Cleaning up

```sh
$ make clean
```
Removes all intermediate files and the final output in `01-panel/out`.
