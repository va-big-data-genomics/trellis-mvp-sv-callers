#!/bin/bash
#<PARAMATERS_TO_REPLACE>


dsub \
--provider google-v2 \
--project <PROJECT_ID> \
--regions us-west1 \
--machine-type n1-standard-8 \
--logging <PATH_FOR_LOG_FILES> \
--name <PIPELINE_NAME> \
--image vandhanak/cnvnator:0.3.3 \
--input BAM="<PATH_TO_BAM_FILE>" \
--input-recursive DIR="<PATH_TO_REFERENCE_DIRECTORY>" \
--output ROOT="<PATH_FOR_ROOT_FILE>" \
--output CALL_OUT="<PATH_FOR_CALL_OUT_FILE>" \
--output EVAL_OUT="<PATH_FOR_EVAL_OUT_FILE>"\
--output CALL_VCF="<PATH_FOR_VCF_FILE>" \
--output GENOTYPE_OUT="<PATH_FOR_GENOTYPE_FILE>" \
--script "<PATH_TO_CNVNATOR_SCRIPT_ON_GCP>"