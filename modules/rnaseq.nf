params.outdir = 'results'

include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
  take:
    reads         // Channel<Tuple2<String,List<Path>>>
    transcriptome // Path
 
  main: 
    transcriptome             // Path
      |> INDEX                // Path 
      |> set { index }        // Path

    reads                     // Channel<Tuple2<String,List<Path>>>
      |> map { pair ->
        QUANT(index, pair)
      }                       // Channel<Path>
      |> set { quant }        // Channel<Path>

    reads                     // Channel<Tuple2<String,List<Path>>>
      |> map(FASTQC)          // Channel<Path>
      |> set { fastqc_logs }  // Channel<Path>

  emit:
    index
    quant
    fastqc_logs
}