# immunedeconv

Run [immunedeconv](https://www.rdocumentation.org/packages/immunedeconv/versions/2.0.3) functions

## Overview

## Dependencies

* [immunedeconv-tools 1.1.0](https://bitbucket.oicr.on.ca/projects/GSI/repos/immunedeconvtools/)
* [immunedeconv 2.0.3](https://www.rdocumentation.org/packages/immunedeconv/versions/2.0.3)


## Usage

### Cromwell
```
java -jar cromwell.jar run immunedeconv.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`resultsFile`|File|A .genes.results file output from the RSEM workflow
`sampleName`|String|Sample or library identifier as prefix for output filenames


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`prepareInputs.modules`|String|"immunedeconv-tools/1.1.0"|required environment modules
`prepareInputs.jobMemory`|Int|4|Memory allocated for this job
`prepareInputs.threads`|Int|1|Requested CPU threads
`prepareInputs.timeout`|Int|1|hours before task timeout
`runCibersort.modules`|String|"immunedeconv-tools/1.1.0"|required environment modules
`runCibersort.jobMemory`|Int|16|Memory allocated for this job
`runCibersort.threads`|Int|4|Requested CPU threads
`runCibersort.timeout`|Int|4|hours before task timeout


### Outputs

Output | Type | Description | Labels
---|---|---|---
`cibersort`|File?|Output from the CIBERSORT.R script|
`percentiles`|File|Output from immunedeconv with percentiles relative to the control set|


## Commands
This section lists command(s) run by immunedeconv workflow
 
* Running immunedeconv workflow
 
Immunedeconv workflow analyzes the expression data (RSEM-generated tags per million) and runs
CIBERSORT, outputting the predicted persentiles for cellular sub-populations.
 
### Convert the inputs (RSEM results file) into a TPM table
 
```
  Rscript convert_rsem_results.R 
  -i RESULT_FILE
  -o tpm.txt
  -n ensembl_conversion_hg38.txt
```
 
### Running CIBERSORT script
 
```
  set -euo pipefail
  Rscript --vanilla immunedeconv_cibersort.R 
  TPM_FILE
  CIBERSORT.R
  LM22.txt
  MATRIX.txt
  if [ -f CIBERSORT-Results.txt ]
    then
    mv CIBERSORT-Results.txt ~{sampleName}.immunedeconv_CIBERSORT-Results.tsv
    fi
 
  mv immunedeconv_out.csv ~{sampleName}.immunedeconv_CIBERSORT-Percentiles.csv
```
## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi/immunedeconvWorkflow) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
