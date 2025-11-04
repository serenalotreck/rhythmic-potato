# rhythmic-potato
Cis-element enrichment in domesticated and wild potato

ATL -- *S. tuberosum* var. Atlantic, domesticated variety
CND -- *S. candolleanum*, wild variety

## *de novo* motif enrichment
We used the tool [HOMER](http://homer.ucsd.edu/homer/) to identify *de novo* cis-regulatory elements. Code for the initial identification of motifs is in `shell_scripts/run_HOMER.sh`, and code for the cross-comparison (looking for enrichment of ATL motifs in CND and vice versa) is found in `shell_scripts/find_shared_motifs.sh`. Both scripts are designed to run all necssary HOMER calls automatedly; details on the command line options can be printed using the `-h` option for both scripts.

## Statistical analysis
After using HOMER to look for cross-enrichment of each species' motifs, we performed some statistical analysis, which is found in `notebooks/checking_motif_overlap.ipynb`. The notebook `notebooks/rve_search.ipynb` was used to generate some of the figures for the manuscript.
