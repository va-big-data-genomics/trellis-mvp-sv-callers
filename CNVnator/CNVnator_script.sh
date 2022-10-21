#The script used to run CNVnator for Genome in a Bottle (n=7) samples on GCP 

#!/bin/bash


cnvnator -unique -root $ROOT -tree $BAM -chrom $(seq -f 'chr%g' 1 22) chrX chrY chrM
cnvnator -root $ROOT -his 100 -d $DIR 
cnvnator -root $ROOT -stat 100 
cnvnator -root $ROOT -eval 100 > $EVAL_OUT
cnvnator -root $ROOT -partition 100 
cnvnator -root $ROOT -call 100 > $CALL_OUT
perl /opt/build/CNVnator_v0.3.3/cnvnator2VCF.pl $CALL_OUT $DIR > $CALL_VCF
awk '{print $2} END {print "exit"}' $CALL_OUT | cnvnator -root $ROOT -genotype 100 > $GENOTYPE_OUT