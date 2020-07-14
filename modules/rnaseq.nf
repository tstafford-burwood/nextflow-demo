params.outdir = 'results'

include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'
include { MULTIQC } from './multiqc'

workflow RNASEQ {
  take:
    transcriptome
    read_pairs_ch
    multiqc_config
 
  main: 
    INDEX(transcriptome)

    FASTQC(read_pairs_ch)

    QUANT(INDEX.out, read_pairs_ch)

    MULTIQC( 
        QUANT.out.mix(FASTQC.out).collect(),
        multiqc_config )

  emit: 
     QUANT.out
}