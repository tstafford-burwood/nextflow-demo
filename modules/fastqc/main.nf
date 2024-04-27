
process FASTQC {
    tag "FASTQC on $sample.id"
    conda 'fastqc=0.12.1'

    input:
    Tuple2<String,List<Path>> sample

    output:
    Path logs = path("fastqc_${sample.id}_logs")

    publish:
    logs >> 'fastqc'

    script:
    """
    fastqc.sh "$sample.id" "$sample.reads"
    """
}
