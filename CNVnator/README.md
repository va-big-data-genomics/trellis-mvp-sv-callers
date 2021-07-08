# CNVnator
Trellis resources for running CNVnator to characterize copy number variants in whole-genome sequencing data. 

[CNVnator Publication](https://pubmed.ncbi.nlm.nih.gov/21324876/)  <br/>
[CNVnator GitHub page](https://github.com/abyzovlab/CNVnator)  <br/>
[Dsub GitHub page](https://github.com/DataBiosphere/dsub)  <br/>

This example demonstrates how to run CNVnator on BAM files stored in a Google Cloud Storage bucket using a job scheduler. Dsub allows one to submit a simple command on from the shell prompt on the laptop. The job is executed on the cloud. 

In this example we will be using a single binary Sequence Alignment/Map format (BAM) file from [Illumina Platinum Genomes Project](https://www.illumina.com/platinumgenomes.html). The BAM files for the Platinum Genomes project can be found [here](https://console.cloud.google.com/storage/browser/genomics-public-data/platinum-genomes/bam?pageState=(%22StorageObjectListTable%22:(%22f%22:%22%255B%255D%22))&prefix=&forceOnObjectsSortingFiltering=false). <br>

# Requirements
1. Google Cloud Account
2. CNVnator docker image : [Version 0.4.1](https://hub.docker.com/r/clinicalgenomics/cnvnator), [Version 0.4](https://hub.docker.com/r/mgibio/cnvnator-cwl), [Version 0.3.3](https://hub.docker.com/r/vandhanak/cnvnator). For this eaxmple we will be using CNVnator:0.3.3.
3. Refrence genome split by chromosome and stored in a folder  
   Note: Ensure that the individual chromosome fasta files are named similar to the chromosome headers in the BAM files. 
5. BAM files 

# Running CNVnator on Google Cloud: <br>
Prerequisites<br>
 • [Create a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) <br>
 • Enable the Genomics, Storage and Compute API's <br>
 • [Install the Google Cloud SDK and run](https://cloud.google.com/sdk/docs/install) <br>
 ```
 gcloud init 
 ```
 This will set up the default project and grant credentials to Google Cloud SDK. 
 ```
 gcloud auth application-default login
 ```
 This will provide credentials to ensure that dsub can call all Google API's
 
Dsub is a command line tool that helps simplify job submission and running of batch scripts on the cloud. When running a dsub script, one must keep in mind the following
1. ```--provider``` <br>
   dsub provides multiple "backend providers". Each of these implement consisten runtime environments. For more information on        backend providers [click here](https://github.com/DataBiosphere/dsub/blob/main/docs/providers/README.md). <br> 
   The current providers are: <br> 
   	  • local <br> 
	    • google-v2 (deafult) <br>
      • google-cls-v2 (new) <br>
    For this example we will use: <br>
  ```
   --provider google-v2
  ```
  
2. ```--project``` <br>
   Cloud project ID to use for running the job. 

3. ```--region``` <br>
   List of Google Cloud Engine regions. Always ensure that the region is the same for your Cloud Storage regional bucket and your Compute Engines VM. Copying data across regions can incur charges. List of regions may be found [here](https://cloud.google.com/compute/docs/regions-zones). <br>
   In this example the region is specified as: <br>
  ```
   --region us-west1
  ``` 
   
4. Google cloud storage bucket <br>
   The log files and output files generated upon running a dsub script will be stored in a bucket. The user can create a storage      bucket using the storage browser or run the command line utility gsutil, which is included in the Cloud SDK. To understand how    to create a Google cloud storage bucket [click here](https://cloud.google.com/storage/docs/creating-buckets). <br>
   The bucket is specified using the parameter ```--bucket```
 
5. ```--machine-type``` <br>
   This flag helps to explicitly set the virtual machine RAM and number of CPU cores to use. The ```machine-type``` value can be one of the [predefined machine type](https://cloud.google.com/compute/docs/machine-types) or a [custom machine type](https://cloud.google.com/compute/docs/machine-types#custom_machine_types). For this example we will use: <br>
  ```
   --machine-type n1-standard-8
  ``` 
   
6. ```--image``` <br>
   This flag allows the user to specify the Docker image to be used to run the ```--script``` or ```--command```. Many software packages, including CNVnator, are already available as public docker images on sites such as [Docker Hub](https://hub.docker.com/). Images can be pulled from Docker hub or any other container registry. In this example the image has been pulled from Docker Hub. 
  ```
    --image vandhanak/cnvnator:0.3.3
  ```
  
7. Input and Output files 
   When running dsub, the input files are present in a Google Cloud Storage specified using ```--bucket``` and the output files are written into the same bucket. 
9. Viewing job status 
10. Deleting a job

# Dsub Script
```
dsub \
  --provider google-v2 \ 
  --project {PROJECT_ID} \ 
  --regions us-west1 \ 
  --machine-type n1-standard-8 \
  --logging gs://{LOG_BUCKET}/MVP_Genomes/cnvnator_0.4.1 \ 
  --name MGIBio_CNVnator0.4.1 \ 
  --image clinicalgenomics/cnvnator:0.4.1 \ 
  --input BAM="gs://{BUCKET_ID}/{INPUT_FILE_PATH}" \ 
  --input-recursive DIR="gs://{BUCKET_ID}/{REFERENCE_FOLDER_PATH}" \ 
  --output ROOT="gs://{BUCKET_ID}/{PATH}" \ 
  --output CALL_OUT="gs://{BUCKET_ID}/{PATH}/{FILE_NAME}" \ 
  --output EVAL_OUT="gs://{BUCKET_ID}/{PATH}/{FILE_NAME}"\ 
  --output CALL_VCF="gs://{BUCKET_ID}/{PATH}/{FILE_NAME}" \
  --output GENOTYPE_OUT="gs://{BUCKET_ID}/{PATH}/{FILE_NAME}" \ 
  --script "gs://{BUCKET_ID}/{PATH}/{FILE_NAME}" 
```   

# CNVnator commands <br>
The list of CNVnator commands may be encompassed into a script and passed to the ```--script``` parameter. <br>
 1. Extract read mapping 
 2. Generate histogram 
 3. Calculating statistics 
 4. Partioning
 5. Calling structural variants 
 6. Convert structural variant calls to the VCF format 
 7. Genotyping genomic regions 
Note: 
Ensure that the bash script is located in the reference bucket. This script will conatin the commands to run CNVnator. 


# Running CNVnator on command prompt 

1. Dsub installation guide
```apt-get update
   apt-get install pip3
   sudo apt install python3-pip
   pip3 --version
   pip3 install dsub
```

2. Install docker engine  

   Click here to go through Docker installation : [Docker Installation Guide](https://docs.docker.com/engine/install/ubuntu/)
   
3. Pull CNVnator image from DockerHub
   Latest docker images with docker files may be found on CNVnator. Docker image used in the example is _vandhanak/cnvnator:0.3.3_ <br>
   Docker image: https://hub.docker.com/r/vandhanak/cnvnator. <br>
   The latest version of CNVnator (0.4 and 0.4.1) are also available on Dockerhub. <br>
   Pull the docker image using the command:
   
```
  docker pull vandhanak/cnvnator
```
 
