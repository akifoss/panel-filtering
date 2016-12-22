# IMPORTANT: All paths in this file are relative to the scripts in
# 00-start, etc. This file is sourced by those scripts.

dataDir=../../../../$(basename $(dirname $(/bin/pwd)))
flashDir=../../../initial/$(basename $(dirname $(/bin/pwd)))/02-flash
logDir=../logs
doneFile=../slurm-pipeline.done
runningFile=../slurm-pipeline.running
sampleLogFile=$logDir/sample.log
