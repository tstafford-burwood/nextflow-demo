
process FASTQC {
    tag "FASTQC on $id"
    conda 'fastqc=0.12.1'

    input:
    id      : String
    reads   : List<Path>

    output:
    logs    : Path = path("fastqc_${id}_logs")

    publish:
    logs >> 'fastqc'

    script:
    """
    fastqc.sh "$id" "$reads"
    """
}
