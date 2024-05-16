params.outdir = 'results'

process MULTIQC {
    conda 'multiqc=1.17'
    publishDir params.outdir, mode:'copy'

    input:
    List<Path> logs
    Path config

    output:
    Path report = path('multiqc_report.html')

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc .
    """
}
