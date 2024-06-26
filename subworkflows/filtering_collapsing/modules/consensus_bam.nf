// CONSENSUS_BAM  module
//Collapsing e filtering Pipeline from fastq to consensus to a bam file

nextflow.enable.dsl = 2

process CONSENSUS_BAM {

      tag "${cell}"

      input:
      tuple val(cell), path(cell_folder)
      
      output:
      tuple val(cell), path("${cell}_consensus_filtered.bam"), emit: consensus_filtered_bam 
      
      script:
      """
      fgbio --compression 1 FastqToBam -i ${cell_folder}/*R1.fastq ${cell_folder}/*R2.fastq \
            -r 16B12M +T -o unmapped.bam --sample MDA_clones --library UMI
      samtools fastq unmapped.bam | bwa mem -t 16 -p -K 150000000 -Y ${params.ref} - | \
            fgbio -Xmx4g --compression 1 --async-io ZipperBams --unmapped unmapped.bam \
            --ref ${params.ref} --output mapped.bam
      fgbio GroupReadsByUmi -s Identity -e 0 -i mapped.bam -o grouped.bam --raw-tag RX -T MI    
      fgbio CallMolecularConsensusReads -t RX -i grouped.bam -o ${cell}_consensus.bam -M ${params.min_reads} 
      fgbio FilterConsensusReads -i ${cell}_consensus.bam -o ${cell}_consensus_filtered.bam -r ${params.ref} \
            -M ${params.min_reads} -e 0.1 -N 20 -E 0.025
      samtools index ${cell}_consensus_filtered.bam
      """   

      stub:
      """
      touch ${cell}_consensus_filtered.bam      
      """

}

