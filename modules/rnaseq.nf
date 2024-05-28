include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
  take:
  reads         : Channel<Tuple2<String,List<Path>>>
  transcriptome : Path
 
  main: 
  transcriptome             // Path
    |> INDEX                // Path 
    |> set { index }        // Path

  reads                     // Channel<Tuple2<String,List<Path>>>
    |> map { id, reads ->
      QUANT(index, id, reads)
    }                       // Channel<Path>
    |> set { quant }        // Channel<Path>

  reads                     // Channel<Tuple2<String,List<Path>>>
    |> map { id, reads ->
      FASTQC( id, reads )
    }                       // Channel<Path>
    |> set { fastqc_logs }  // Channel<Path>

  emit:
  index
  quant
  fastqc_logs
}