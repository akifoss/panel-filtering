#!/bin/bash

. $HOME/.virtualenvs/35/bin/activate
. ../common.sh

log=$sampleLogFile

echo "01-split started at `date`" >> $log

IFS=$'\n'
fastq=($(ls $dataDir/*.fastq.gz | sed -e 's:.*/::' | cut -f1 -d.))
unset IFS

task=`echo $fastq[0] | sed -e s/_R1_.*//`

fastq1=$flashDir/${task}_R1_001-flash.fastq.gz
fastq2=$flashDir/${task}_R2_001-flash.fastq.gz
fastqMerged=$flashDir/${task}-merged-flash.fastq.gz

prexistingCount=`ls chunk-* 2>/dev/null | wc -l | awk '{print $1}'`
echo "  There are $prexistingCount pre-existing split files." >> $log

function skip()
{
    echo "  Skipping."
}

function makeFasta()
{
    echo "  FASTQ1 $fastq1" >> $log
    echo "  FASTQ2 $fastq2" >> $log
    echo "  FASTQ merged (by flash) $fastqMerged" >> $log

    # BLAST can't read FASTQ and can't read gzipped files. So make a bunch
    # of FASTA files for it. Note that we know reads just take a single
    # line in the output and that we need to split on an even number of
    # input FASTA lines.
    #
    # We need put /1 at the end of the ids in $fastq1 and /2 at the end of
    # $fastq2, otherwise we'll end up with duplicate read ids from the
    # paired reads.
    echo "  Uncompressing and splitting all FASTQ at `date`" >> $log
    (
        zcat $fastq1 | filter-fasta.py --readClass fastq --saveAs fasta | awk '{if (NR % 2 == 1){printf "%s/1\n", $0} else {print}}'
        zcat $fastq2 | filter-fasta.py --readClass fastq --saveAs fasta | awk '{if (NR % 2 == 1){printf "%s/2\n", $0} else {print}}'
        zcat $fastqMerged | filter-fasta.py --readClass fastq --saveAs fasta
    ) | split -l 500000 -a 5 --additional-suffix=.fasta - chunk-
    echo "  FASTQ uncompressed at `date`" >> $log
    echo "  Split into `ls chunk-* | wc -l | awk '{print $1}'` files." >> $log
}


if [ $SP_SIMULATE = "1" ]
then
    echo "  This is a simulation." >> $log
else
    echo "  This is not a simulation." >> $log
    if [ $SP_SKIP = "1" ]
    then
        echo "  Split is being skipped on this run." >> $log
        skip
    elif [ $prexistingCount -ne 0 ]
    then
        if [ $SP_FORCE = "1" ]
        then
            echo "  Pre-existing split files exist, but --force was used. Overwriting." >> $log
            makeFasta
        else
            echo "  Not overwriting pre-existing split files. Use --force to make me." >> $log
        fi
    else
        echo "  No pre-existing split files exists, making them." >> $log
        makeFasta
    fi
fi

for file in chunk-*.fasta
do
    task=`echo $file | cut -f1 -d.`
    echo "TASK: $task"
done

echo "01-split stopped at `date`" >> $log
echo >> $log
