include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
  take:
    Path transcriptome
    Path read_pairs_ch
 
  main: 
    INDEX(transcriptome)
    FASTQC(read_pairs_ch)
    QUANT(INDEX.out, read_pairs_ch)
    outputs = QUANT.out | concat(FASTQC.out) | collect

  emit: 
    List<Path> outputs
}