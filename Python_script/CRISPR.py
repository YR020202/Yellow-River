# Extract CRISPR array sequences from minCED output using a GFF3 annotation file
# The script parses the GFF3 file to locate CRISPR regions, retrieves the corresponding sequences from a FASTA file,
# and writes them to a new FASTA file with unique identifiers

import argparse
import os
from Bio.SeqRecord import SeqRecord
from Bio import SeqIO

# Define command-line arguments
parser = argparse.ArgumentParser(description='take minCED CRISPR result')
parser.add_argument('--gff3', help='< minCED gff3 output >')
parser.add_argument('--input_fa', help='< your all MAGs contig >')
parser.add_argument('--output_fa', help='< output CRISPR fasta >')

# Parse arguments
args = parser.parse_args()
gff3 = args.gff3
input_fa = args.input_fa
output_fa = args.output_fa

# Initialize a dictionary to store extracted CRISPR sequences
result_db = {}

# Process the GFF3 file and the input FASTA file simultaneously
with open(gff3, "r") as gff, open(input_fa, "r") as ifa, open(output_fa, "w") as ofa:
    # Load all input sequences into a dictionary keyed by their sequence ID
    sequences = SeqIO.to_dict(SeqIO.parse(ifa, "fasta"))
    
    # Iterate through each line of the GFF3 file
    for line in gff:
        # Skip comment lines (starting with '#')
        if line.startswith("#"):
            continue
        
        # Parse the GFF3 line (tab‑separated)
        fields = line.strip("\n").split("\t")
        seq_id = fields[0]                # Contig/scaffold ID
        start = int(fields[3]) - 1        # Start coordinate (convert to 0‑based)
        end = int(fields[4])              # End coordinate (1‑based, exclusive)
        zhushi = fields[8]                # Attributes field
        
        # Extract the CRISPR ID from the attributes (format: ID=xxx;...)
        ID = zhushi.split(";")[0]
        ID = ID.split("=")[1]
        
        # Create a unique name for the CRISPR sequence: "seq_id+ID"
        name = f"{seq_id}+{ID}"
        
        # Retrieve the subsequence from the stored sequence dictionary
        subseq = sequences[seq_id].seq[start:end]
        
        # Create a SeqRecord object with the extracted sequence
        record = SeqRecord(subseq, id=name, description="")
        
        # Store the record in the dictionary (key = unique name)
        result_db[name] = record
    
    # Write all collected CRISPR sequences to the output FASTA file
    SeqIO.write(result_db.values(), ofa, 'fasta')