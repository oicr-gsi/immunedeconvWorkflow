# immunedeconv

Run [immunedeconv](https://www.rdocumentation.org/packages/immunedeconv/versions/2.0.3) functions

## Overview

## Dependencies

* [immunedeconv-tools 1.0.0](https://bitbucket.oicr.on.ca/projects/GSI/repos/immunedeconvtools/)
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


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`prepare_inputs.modules`|String|"immunedeconv-tools/1.0.0"|required environment modules
`prepare_inputs.jobMemory`|Int|4|Memory allocated for this job
`prepare_inputs.threads`|Int|1|Requested CPU threads
`prepare_inputs.timeout`|Int|1|hours before task timeout
`run_immunedeconv.modules`|String|"immunedeconv-tools/1.0.0"|required environment modules
`run_immunedeconv.jobMemory`|Int|16|Memory allocated for this job
`run_immunedeconv.threads`|Int|4|Requested CPU threads
`run_immunedeconv.timeout`|Int|4|hours before task timeout


### Outputs

Output | Type | Description
---|---|---
`cibersort`|File|Output from the CIBERSORT.R script
`percentiles`|File|Output from immunedeconv with percentiles relative to the control set

 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi/immunedeconvWorkflow) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
