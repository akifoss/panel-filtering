.PHONY: x, run, clean-1, clean-2, clean-3

x:
	@echo "There is no default make target. Use 'make run' to run the SLURM pipeline."

run:
	slurm-pipeline.py -s specification.json > status.json

# Remove all large intermediate files. Only run this if you're sure you
# want to throw away all that work!

# Remove *all* intermediates, including the final panel output.
clean:
	rm -fr \
               01-panel/out \
               01-panel/summary-virus \
               slurm-pipeline.done \
               slurm-pipeline.running \
               logs \
               status.json
