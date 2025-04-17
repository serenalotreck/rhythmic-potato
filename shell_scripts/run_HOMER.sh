#!/bin/bash

program_name=$0

function Help() {
    echo
    echo "For a set of modules and genotypes, run HOMER."
    echo
    echo "Expects the module files passed to have names with the pattern"
    echo "descriptor_module_X_in_SPECIES.txt, where descriptor is anything"
    echo "without spaces, X is a number, SPECIES is either CND, M6, or ATL."
    echo
    echo "This script is set up to compare two species."
    echo
    echo "If running on the Farre lab server, use the genetics conda environment."
    echo
    echo "Syntax: $program_name [-h] [-m moduledir] [-o outdir] [-g1 g1] [-g2 g2] [-p1 prom1] [-p2 prom2] [-bg1 bg1] [-bg2 bg2] [-b begin] [-e end]"
    echo
    echo "Options:"
    echo "  -m moduledir specify path to module files"
    echo "  -o outdir    specify path to save output"
    echo "  -g g1        specify genotype 1"
    echo "  -i g2        specify genotype 2"
    echo "  -p prom1     specify installed promoter file name for genotype 1"
    echo "  -q prom2     specify installed promoter file name for genotype 2"
    echo "  -k bg1       specify path to background file for genotype 1"
    echo "  -l bg2       specify path to background file for genotype 2"
    echo "  -b begin     specify how far upstream to look for enrichments"
    echo "  -e end       specify how far downstream to look for enrichments"
}

# Define accepted args
while getopts ":hm:o:g:i:p:q:k:l:b:e:" option; do
    case $option in
      h) # Display Help
         Help
         exit;;
      m) # Enter the path to the modules
        modules=$OPTARG;;
      o) # Specify output directory
        outdir=$OPTARG;;
      g) # Specify the first genotype
        genotype1=$OPTARG;;
      i) # Specify the second genotype
        genotype2=$OPTARG;;
      p) # Specify first promoter file
        prom1=$OPTARG;;
      q) # Specify second promoter file
        prom2=$OPTARG;;
      k) # Specify first background file
        bg1=$OPTARG;;
      l) # Specify second background file
        bg2=$OPTARG;;
      b) # Specify how far upstream of TSS to look, default in HOMER=-300
        begin=$OPTARG;;
      e) # Specify how far downstream of TSS to look, default in HOMER=50
        end=$OPTARG;;
      :)
        echo "Option -${option} requires an argument."
        exit 1;;
      ?) # Invalid option
         echo "Error: Invalid option -${option}"
         exit;;
    esac
done

for file in $modules*; do
	filename=$(echo "${file##*/}") # Gets everything after the last /
	modulenum=$(grep -o -P "module_\d+" <<< $filename)
	comparison=$(echo "${filename%%_module*}") # Gets everything before _module
	fileend=$(echo "${filename##*module_}") # Gets everything after module_
    echo $filename
    echo $modulenum
    echo $comparison
    echo $fileend
    echo *$genotype1*
    # Assign input params for HOMER
	if [[ $fileend == *$genotype1* ]]; then
        species=$genotype1
        prom=$prom1
        bg=$bg1
	elif [[ $fileend == *$genotype2* ]]; then
		species=$genotype2
		prom=$prom2
		bg=$bg2
	else
		echo $filename >> errorlog.txt
		printf "\n" >> errorlog.txt
		continue
	fi

    # Define the subdirectory for output
    echo $outdir
    outdir_sub=$outdir/$comparison/$modulenum/$species
    echo $outdir_sub
	mkdir -p $outdir_sub
	findMotifs.pl $file $prom $outdir_sub -bg $bg -start $begin -end $end -p 10
done
