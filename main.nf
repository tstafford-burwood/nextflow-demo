#!/usr/bin/env nextflow

/*
 * Copyright (c) 2013-2023, Seqera Labs.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * This Source Code Form is "Incompatible With Secondary Licenses", as
 * defined by the Mozilla Public License, v. 2.0.
 */

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 *
 * Authors:
 * - Paolo Di Tommaso <paolo.ditommaso@gmail.com>
 * - Emilio Palumbo <emiliopalumbo@gmail.com>
 * - Evan Floden <evanfloden@gmail.com>
 */

nextflow.enable.dsl = 3

include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

workflow {
  log.info """\
    R N A S E Q - N F   P I P E L I N E
    ===================================
    transcriptome: ${params.transcriptome}
    reads        : ${params.reads}
    outdir       : ${params.outdir}
    """.stripIndent()

  params.reads                                              // String
    |> Channel.fromFilePairs( checkIfExists: true )         // Channel<Tuple2<String,List<Path>>>
    |> RNASEQ( file(params.transcriptome) )                 // MultiChannel(index: Path, quant: Channel<Path>, fastqc_logs: Channel<Path>)
    |> { out ->
      out.quant |> concat(out.fastqc_logs) |> collect
    }                                                       // List<Path>
    |> MULTIQC( file(params.multiqc) )                      // Path

  workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
  }
}

publish {
  directory params.outdir
  mode 'copy'

  'fastqc' {
    path '.'
  }

  'multiqc' {
    path '.'
  }
}
