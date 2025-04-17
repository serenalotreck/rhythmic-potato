#!/bin/bash

program_name=$0

function Help() {
    echo
    echo "Using the output of a HOMER run for two genotypes, check if one "
    echo "genotype's motifs are present in the other."
    echo
    echo "This script is set up to compare two species."
    echo
    echo "If running on the Farre lab server, use the genetics conda environment."
    echo
    echo "Syntax: $program_name [-h] [-m motifResults] [-o outdir] [-n name] [-a searchGeno] [-g genome] [-b begin] [-e end]"
    echo
    echo "Options:"
    echo "  -m motifResults specify path to HOMER output for a pair of genotypes"
    echo "  -o outdir       specify path to save output"
    echo "  -n name         specify the name of the genotype the motifs are from"
    echo "  -s searchGeno   specify which genotype is being searched"
    echo "  -g genome       specify the genome for the searchGeno"
    echo "  -b begin        specify how far upstream to look for enrichments"
    echo "  -e end          specify how far downstream to look for enrichments"
}

# Define accepted args
while getopts ":hm:o:n:s:g:b:e:" option; do
    case $option in
      h) # Display Help
         Help
         exit;;
      m) # Enter the path to the motifs
        motifs=$OPTARG;;
      o) # Specify output directory
        outdir=$OPTARG;;
      n) # Specify the name of the genomes the motifs are from
        name=$OPTARG;;
      s) # Specify the search genotype
        searchGeno=$OPTARG;;
      g) # Specify the installed genome to use
        genome=$OPTARG;;
      b) # Specify how far upstream of TSS to look, default in HOMER=-300
        begin=$OPTARG;;
      e) # Specify how far downstream of TSS to look, default in HOMER=50
        end=$OPTARG;;
      :)
        echo "Option -${option} requires an argument."
        exit 1;;
      ?) # Invalid option
        echo "Error: Invalid option -${option}"
        exit 1;;
    esac
done

for module in $motifs*; do
    module_basename=$(echo "${module##*/}") # Gets everything after the last /
    # Go through output from each module
    for motif_file in $module/$name/homerResults/*; do
        # If it's a motif file then
        if [[ "${motif_file#*.}" == motif ]]; then
            filename=$(echo "${motif_file##*/}") # Gets everything after the last /
            motifname=$(echo "${filename%%.motif}") # Gets everything before .motif
            outfile="${outdir}/${module_basename}_${motifname}_${name}_searching_${searchGeno}_output.txt"
            annotatePeaks.pl tss $genome -size $begin,$end -m $motif_file > $outfile
        fi
    done
done