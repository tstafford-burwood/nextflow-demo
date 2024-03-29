params.outdir = 'results'

process FASTQC {
    tag "FASTQC on $sample.id"
    conda 'fastqc=0.12.1'
    publishDir params.outdir, mode:'copy'

    input:
    Sample sample

    output:
    Path logs = path("fastqc_${sample.id}_logs")

    script:
    """
    fastqc.sh "$sample.id" "$sample.reads"
    """
}
