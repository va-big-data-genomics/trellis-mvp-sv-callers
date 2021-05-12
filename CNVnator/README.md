# CNVnator
Trellis resources for running CNVnator to characterize copy number variants in whole-genome sequencing data. 

Publication: https://pubmed.ncbi.nlm.nih.gov/21324876/

DSUB pipeline for CNVnator

Note: 
Ensure that the bash script is located in the reference bucket. This script will conatin the commands to run CNVnator. 

  dsub \ <br/>
  --provider Provider_Name \ <br/>
  --project Project_Name \ <br/>
  --regions Region_Code \ <br/>
  --machine-type Machine_Type \
  --logging gs://Bucket_Name>/Path_To_Log_Files \ <br/>
  --name Name \ <br/>
  --image NameOfImage \ <br/>
  --input BAM="gs://Bucket_Name/Path_To_Bam_File" \ <br/>
  --input-recursive DIR="gs://Bucket_Name/Path_To_Reference_Folder" \ <br/>
  --output ROOT="gs://Bucket_Name/Path_To_Root" \ <br/>
  --output CALL_OUT="gs://Bucket_Name/Path_To_Call_Output" \ <br/>
  --output EVAL_OUT="gs://Bucket_Name/Path_To_Statistics_Output"\ <br/>
  --output CALL_VCF="gs://Bucket_Name/Path_To_VCF_Output" \ <br/>
  --output GENOTYPE_OUT="gs://Bucket_Name/Path_To_Genotype_Output" \ <br/>
  --script "gs://Bucket_Name/Path_To_Script" <br/>
  
 
Ex: Bash Script - Run for a bin size of 100 <br/>
Note: cnvnator2VCF.pl is an inbuilt tool within CNVnator that converts the SV calls file into the VCF format

  #!/bin/bash <br/>
  cnvnator -unique -root $ROOT -tree $BAM -chrom $(seq -f 'chr%g' 1 22) chrX chrY chrM <br/>
  cnvnator -root $ROOT -his 100 -d $DIR <br/>
  cnvnator -root $ROOT -stat 100 <br/>
  cnvnator -root $ROOT -eval 100 > $EVAL_OUT <br/> 
  cnvnator -root $ROOT -partition 100 <br/>
  cnvnator -root $ROOT -call 100 > $CALL_OUT <br/>
  perl /opt/build/CNVnator_v0.3.3/cnvnator2VCF.pl $CALL_OUT $DIR > $CALL_VCF <br/>
  awk '{print $2} END {print "exit"}' $CALL_OUT | cnvnator -root $ROOT -genotype 100 > $GENOTYPE_OUT <br/>


 
