version 1.0

workflow immunedeconv {

  input {
    File resultsFile
  }
  
  parameter_meta {
    resultsFile: "A .genes.results file output from the RSEM workflow"
  }

  call prepare_inputs {
    input:
    resultsFile = resultsFile
  }

  call run_immunedeconv {
    input:
    tpmFile = prepare_inputs.tpmFile
  }

  output {
    File cibersort = run_immunedeconv.cibersortResults
    File percentiles = run_immunedeconv.percentileResults
  }

  meta {
    author: "Iain Bancarz and Rishi Shah, with modifications by Peter Ruzanov, Lawrence Heisler"
    email: "ibancarz@oicr.on.ca, pruzanov@oicr.on.ca, lheisler@oicr.on.ca"
    description: "QC metrics for RNASeq data"
    dependencies: [
      {
	name: "immunedeconv-tools/1.0.0",
	url: "https://bitbucket.oicr.on.ca/projects/GSI/repos/immunedeconvtools/"
      },
      {
	name: "immunedeconv/2.0.3",
	url: "https://www.rdocumentation.org/packages/immunedeconv/versions/2.0.3"
      }
    ]
  }  
}

task prepare_inputs {

  input {
    File resultsFile
    String modules = "immunedeconv-tools/1.0.0"
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

  output {
    File tpmFile = "tpm.txt"
  }

  meta {
    output_meta: {
      tpmFile: "Space-delimited file containing Hugo gene symbols and TPM values"
    }
  }
}

task run_immunedeconv {

  input {
    File tpmFile
    String modules = "immunedeconv-tools/1.0.0"
    Int jobMemory = 16
    Int threads = 4
    Int timeout = 4
  }

  parameter_meta {
    tpmFile: "Space-delimited TPM file from the prepare_inputs task"
    modules: "required environment modules"
    jobMemory: "Memory allocated for this job"
    threads: "Requested CPU threads"
    timeout: "hours before task timeout"
  }

  command <<<
    Rscript --vanilla ${IMMUNEDECONV_TOOLS_SCRIPTS}/immunedeconv_cibersort.R \
    ~{tpmFile} \
    ${IMMUNEDECONV_TOOLS_SCRIPTS}/CIBERSORT.R \
    ${IMMUNEDECONV_TOOLS_DATA}/LM22.txt \
    ${IMMUNEDECONV_TOOLS_DATA}/MATRIX.txt
  >>>

  output {
    File cibersortResults = "CIBERSORT-Results.txt"
    File percentileResults = "immunedeconv_out.csv"
  }

  meta {
    output_meta: {
      cibersortResults: "Output from the CIBERSORT.R script",
      percentileResults: "Output from immunedeconv with percentiles relative to the control set"
    }
  }

}
