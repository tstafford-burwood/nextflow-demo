
process MULTIQC {
    conda 'multiqc=1.17'

    input:
    List<Path> inputs
    Path config 

    output:
    Path report = path('multiqc_report.html')

    publish:
    report >> 'multiqc'

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc .
    """
}
