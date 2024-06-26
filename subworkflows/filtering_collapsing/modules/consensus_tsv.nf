// CONSENSUS_TSV  module
//from a bam consensu file to a tsv consensus file

nextflow.enable.dsl = 2

//

process CONSENSUS_TSV {

    tag "${cell}"

    input:
    tuple val(cell), path(consensus_filtered_bam)
        
    output:
    tuple val(cell), path("${cell}_consensus_filtered.tsv"), emit: consensus_filtered_tsv

    script:
    """
    python ${baseDir}/bin/filtering_collapsing/from_consensus_bam_to_tsv.py \
    --input_path ${consensus_filtered_bam} \
    --cbc ${cell}
    """

    stub:
    """
    touch ${cell}_consensus_filtered.tsv
    """

}