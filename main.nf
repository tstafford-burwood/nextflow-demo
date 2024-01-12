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

/* 
 * enables modules 
 */
nextflow.enable.dsl = 2

// import modules
include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

/* 
 * main script flow
 */
workflow {
  /*
   * Default pipeline parameters. They can be overriden on the command line eg.
   * given `foo` specify on the run command line `--foo some_value`.
   */
  input:
  Path reads = "$baseDir/data/ggal/ggal_gut_{1,2}.fq"
  Path transcriptome = "$baseDir/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
  Path multiqc = "$baseDir/multiqc"
  String outdir = "results"

  main:
  log.info """\
    R N A S E Q - N F   P I P E L I N E
    ===================================
    transcriptome: ${transcriptome}
    reads        : ${reads}
    outdir       : ${outdir}
    """

  read_pairs_ch = channel.fromFilePairs( reads, checkIfExists: true ) 
  RNASEQ( transcriptome, read_pairs_ch )
  MULTIQC( RNASEQ.out, multiqc )

  /* 
   * completion handler
   */
  workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
  }

  output:
  List<Path> rnaseq_outputs = RNASEQ.out
  Path multiqc_report = MULTIQC.out
}
