
process QUANT {
    tag "$pair.id"
    conda 'salmon=1.10.2'

    input:
    Path index
    Sample pair

    output:
    Path result = path(pair.id)

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${pair.reads[0]} -2 ${pair.reads[1]} -o $pair.id
    """
}
