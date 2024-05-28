
process MULTIQC {
    conda 'multiqc=1.17'

    input:
    inputs  : List<Path>
    config  : Path 

    output:
    report  : Path = path('multiqc_report.html')

    publish:
    report >> 'multiqc'

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc .
    """
}
