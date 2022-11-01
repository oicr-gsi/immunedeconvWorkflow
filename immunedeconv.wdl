version 1.0

workflow immunedeconv {

  input {
    File resultsFile
    String sampleName
  }
  
  parameter_meta {
    resultsFile: "A .genes.results file output from the RSEM workflow"
    sampleName: "Sample or library identifier as prefix for output filenames"
  }

  call prepareInputs {
    input:
    resultsFile = resultsFile
  }

  call runCibersort {
    input:
    tpmFile = prepareInputs.tpmFile,
    sampleName = sampleName
  }

  output {
    File? cibersort = runCibersort.cibersortResults
    File percentiles = runCibersort.percentileResults
  }

  meta {
    author: "Iain Bancarz"
    email: "ibancarz@oicr.on.ca"
    description: "Run immunedeconv functions"
    dependencies: [
      {
	name: "immunedeconv-tools/1.1.0",
	url: "https://bitbucket.oicr.on.ca/projects/GSI/repos/immunedeconvtools/"
      },
      {
	name: "immunedeconv/2.0.3",
	url: "https://www.rdocumentation.org/packages/immunedeconv/versions/2.0.3"
      }
    ]
  }  
}

task prepareInputs {

  input {
    File resultsFile
    String modules = "immunedeconv-tools/1.1.0"
    Int jobMemory = 4
    Int threads = 1
    Int timeout = 1
  }

  parameter_meta {
    resultsFile: "genes.results file from the RSEM workflow"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
  }

  command <<<
    Rscript ${IMMUNEDECONV_TOOLS_SCRIPTS}/convert_rsem_results.R \
    -i ~{resultsFile} \
    -o tpm.txt \
    -n ${IMMUNEDECONV_TOOLS_DATA}/ensembl_conversion_hg38.txt
  >>>

  runtime {
    memory: "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File tpmFile = "tpm.txt"
  }

  meta {
    output_meta: {
      tpmFile: "Space-delimited file containing Hugo gene symbols and TPM values"
    }
  }
}

task runCibersort {

  input {
    File tpmFile
    String sampleName
    String modules = "immunedeconv-tools/1.1.0"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
  }

  parameter_meta {
    tpmFile: "Space-delimited TPM file from the prepare_inputs task"
    sampleName: "Sample or library identifier; prefix for output filenames"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
  }

  command <<<
    set -euo pipefail
    Rscript --vanilla ${IMMUNEDECONV_TOOLS_SCRIPTS}/immunedeconv_cibersort.R \
    ~{tpmFile} \
    ${IMMUNEDECONV_TOOLS_SCRIPTS}/CIBERSORT.R \
    ${IMMUNEDECONV_TOOLS_DATA}/LM22.txt \
    ${IMMUNEDECONV_TOOLS_DATA}/MATRIX.txt
    if [ -f CIBERSORT-Results.txt ]
      then
      mv CIBERSORT-Results.txt ~{sampleName}.immunedeconv_CIBERSORT-Results.tsv
      fi

    mv immunedeconv_out.csv ~{sampleName}.immunedeconv_CIBERSORT-Percentiles.csv
  >>>

  runtime {
    memory: "~{jobMemory} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {
    File? cibersortResults = "~{sampleName}.immunedeconv_CIBERSORT-Results.tsv"
    File percentileResults = "~{sampleName}.immunedeconv_CIBERSORT-Percentiles.csv"
  }

  meta {
    output_meta: {
      cibersortResults: "Output from the CIBERSORT.R script",
      percentileResults: "Output from immunedeconv with percentiles relative to the control set"
    }
  }

}
