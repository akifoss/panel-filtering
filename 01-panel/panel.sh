#!/bin/bash -e

. $HOME/.virtualenvs/35/bin/activate
. ../common.sh

# The log file is the top-level sample log file, seeing as this step is a
# 'collect' step that is only run once.
log=$sampleLogFile
out=summary-virus

echo "01-panel started at `date`" >> $log

sample=$(basename $(dirname $(/bin/pwd)))
json="/home/tcj25/scratch/projects/sofia/pipelines/secondary/$sample/02-blastx/chunk-*.json.bz2"
fasta="/home/tcj25/scratch/projects/sofia/pipelines/secondary/$sample/01-split/chunk-*.fasta"

if [ -z "$json" ]
then
    echo "  No tasks found!" >> $log
    exit 1
fi

function skip()
{
    # We're being skipped. Make an empty output file, if one doesn't
    # already exist. There's nothing much else we can do and there's no
    # later steps to worry about.
    [ -f $out ] || touch $out
}

function panel()
{
    echo "  noninteractive-alignment-panel.py started at `date`" >> $log
    noninteractive-alignment-panel.py \
      --json $json \
      --fasta $fasta \
      --matcher blast \
      --checkAlphabet 0 \
      --outputDir out \
      --withScoreBetterThan 50 \
      --scoreCutoff 50 \
      --minCoverage 0.1 \
      --minMatchingReads 10 > summary-virus
    echo "  noninteractive-alignment-panel.py stopped at `date`" >> $log
}

if [ $SP_SIMULATE = "1" ]
then
    echo "  This is a simulation." >> $log
else
    echo "  This is not a simulation." >> $log
    if [ $SP_SKIP = "1" ]
    then
        echo "  Panel is being skipped on this run." >> $log
        skip
    elif [ -f $out ]
    then
        if [ $SP_FORCE = "1" ]
        then
            echo "  Pre-existing output file $out exists, but --force was used. Overwriting." >> $log
            panel
        else
            echo "  Will not overwrite pre-existing output file $out. Use --force to make me." >> $log
        fi
    else
        echo "  Pre-existing output file $out does not exist. Making panel." >> $log
        panel
    fi
fi

echo "01-panel stopped at `date`" >> $log
echo >> $log
