#!/bin/bash -e

. $HOME/.virtualenvs/35/bin/activate
. ../common.sh

# Remove the marker file that indicates when a job is fully complete or
# that there has been an error and touch the file that shows we're running.
rm -f $doneFile $errorFile
touch $runningFile

# Remove the top-level logging directory. With a sanity check!
if [ ! $logDir = ../logs ]
then
    # SLURM will catch this output and put it into slurm-N.out where N is
    # out job id.
    echo "$0: logDir variable has unexpected value '$logDir'!" >&2
    exit 1
fi

rm -fr $logDir

mkdir $logDir || {
    # SLURM will catch this output and put it into slurm-N.out where N is
    # out job id.
    echo "$0: Could not create log directory '$logDir'!" >&2
    exit 1
}

log=$sampleLogFile

echo "SLURM pipeline started at `date`" >> $log

echo >> $log
echo "00-start started at `date`" >> $log


IFS=$'\n'
fastq=($(ls $dataDir/*.fastq.gz | sed -e 's:.*/::' | cut -f1 -d.))
unset IFS

task=`echo $fastq[0] | sed -e s/_R1_.*//`

fastq1=$flashDir/${task}_R1_001-flash.fastq.gz
fastq2=$flashDir/${task}_R2_001-flash.fastq.gz
fastqMerged=$flashDir/${task}-merged-flash.fastq.gz

if [ ! -f $fastq1 ]
then
    echo "  FASTQ1 $fastq1 does not exist!" >> $log
    exit 1
fi

if [ ! -f $fastq2 ]
then
    echo "  FASTQ2 $fastq2 does not exist!" >> $log
    exit 1
fi

if [ ! -f $fastqMerged ]
then
    echo "  FASTQ1 $fastqMerged does not exist!" >> $log
    exit 1
fi

echo "  FASTQ1 $fastq1" >> $log
echo "  FASTQ2 $fastq2" >> $log
echo "  FASTQ merged (by flash) $fastqMerged" >> $log

echo "00-start stopped at `date`" >> $log
echo >> $log
