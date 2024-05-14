#!/bin/bash -ue
fgbio --compression 1 FastqToBam -i AACCAACTCAAGCTTG/*R1.fastq AACCAACTCAAGCTTG/*R1.fastq           -r 16B12M +T -o unmapped.bam --sample MDA_clones --library UMI
samtools fastq unmapped.bam | bwa mem -t 16 -p -K 150000000 -Y /Users/ieo6943/Documents/Guido/data/MDA_clones/fasta_ref/cassette.up.fa - |           fgbio -Xmx4g --compression 1 --async-io ZipperBams --unmapped unmapped.bam           --ref /Users/ieo6943/Documents/Guido/data/MDA_clones/fasta_ref/cassette.up.fa --output mapped.bam
fgbio GroupReadsByUmi -s Identity -e 0 -i mapped.bam -o grouped.bam --raw-tag RX -T MI    
fgbio CallMolecularConsensusReads -t RX -i grouped.bam -o consensus.bam -M 3 
fgbio FilterConsensusReads -i consensus.bam -o consensus_filtered.bam -r /Users/ieo6943/Documents/Guido/data/MDA_clones/fasta_ref/cassette.up.fa           -M 3 -e 0.1 -N 20 -E 0.025
samtools index consensus_filtered.bam
