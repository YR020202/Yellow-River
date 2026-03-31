### extract.py
# The following is a Python script for extracting sequences with specific IDs from a nucleic acid sequence file.
from Bio import SeqIO
# Open a file for writing the extracted sequences.
result= open('Method.fa', 'w')
# Initialize an empty dictionary for storing the IDs of the sequences to be extracted.
a={}
# Open the file containing the IDs of the sequences to be extracted.
f=open('Method-ID.txt', 'r')
# Read the ID file line by line.
for line in f:
    # Store the read ID as a key in the dictionary after removing leading and trailing whitespace.
    a[line.strip()]=1
# Close the ID file.
f.close()
# Parse the nucleic acid sequence file line by line.
for seq_record in SeqIO.parse('contigs_5000.fasta', 'fasta'):
    # Check if the ID of the current sequence is in the dictionary.
    if str(seq_record.id) in a:
        # If it exists, write the description information of the sequence to the result file.
        result.write('>'+str(seq_record.description)+'\n')
        # Write the sequence itself to the result file.
        result.write(str(seq_record.seq)+'\n')
# Close the result file.
result.close()
# Print a prompt message indicating that the operation is completed.
print('ok')