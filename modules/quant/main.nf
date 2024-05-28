
process QUANT {
    tag "$id"
    conda 'salmon=1.10.2'

    input:
    index   : Path
    id      : String
    reads   : List<Path>

    output:
    quant   : Path = path(id) 

    script:
    """
    salmon quant \
        --threads $task.cpus \
        --libType=U \
        -i $index \
        -1 ${reads[0]} \
        -2 ${reads[1]} \
        -o $id
    """
}
