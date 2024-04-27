
process INDEX {
    tag "$transcriptome.simpleName"
    conda 'salmon=1.10.2'

    input:
    Path transcriptome

    output:
    Path index = path('index')

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}
