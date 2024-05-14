import pysam
import argparse
import os

# Create the parser
my_parser = argparse.ArgumentParser(
    prog='form bam to tsv',
    description=
    """
    It transform a consensus read bam file in a tsv file, 
    """
)

my_parser.add_argument(
    '--input_path', 
    type=str,
    default=None,
    help='input file, the input file must be compose by data of the same cell'
)


my_parser.add_argument(
    '--cbc', 
    type=str,
    default=None,
    help='name of the cell of the sample'
)


# Parse arguments
args = my_parser.parse_args()
bam_file = args.input_path
file_base = os.path.splitext(bam_file)[0]
output_tsv = file_base + '.tsv'
cbc = args.cbc

#bam_file = '/Users/ieo6943/Documents/Guido/scratch/consensus.bam'
#output_tsv = '/Users/ieo6943/Documents/Guido/scratch/consensus.tsv'
#cbc = 'ACCACACACACACAAAA'

#pysam.index(bam_file)

with pysam.AlignmentFile(bam_file, "rb", check_sq=False) as bam:
    with open(output_tsv, "w") as tsv:
        tsv.write("readID\tCBC\tUMI\tfeature\n")
        read_id = 0
        for alignment in bam: 
            feature= alignment.seq[33:33+18]
            umi = alignment.get_tag("RX")
            read_id += 1
            tsv.write(f"{read_id}\t{cbc}\t{umi}\t{feature}\n")