// filtering and collapsing subworkflow

nextflow.enable.dsl = 2

// Include here
include { CONSENSUS_BAM } from "./modules/consensus_bam.nf"
include { CONSENSUS_TSV } from "./modules/consensus_tsv.nf"

//

//----------------------------------------------------------------------------//
// filtering and collapsing into consensus reads to tsv file subworkflow
//----------------------------------------------------------------------------//


workflow filtering_collapsing {
    
    take:
        ch_input

    main:
 
        // Merge reads and Solo
        CONSENSUS_BAM(ch_input)
        CONSENSUS_TSV(CONSENSUS_BAM.out.consensus_filtered_bam) 
    

    emit:

        tsv = CONSENSUS_TSV.out.consensus_filtered_tsv

}



//workflow {
//    CONSENSUS_BAM(channel_i)
//    CONSENSUS_TSV(CONSENSUS_BAM.out.consensus_filtered_bam) 
//    CONSENSUS_TSV.out.consensus_filtered_tsv | view
//    
//}