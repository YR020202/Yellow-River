# Extract tRNA sequences from a plain text file (tRNA.txt) and write them to a FASTA-like result file
# The input file is expected to contain lines with "Length" (indicating a new tRNA record) and "Seq:" (containing the sequence)
# The output file (Result.txt) will contain each tRNA header (from the "Length" line) followed by its sequence

# Read the entire input file and split by newline into a list of lines
with open("tRNA.txt", "r") as file:
    tRNA = file.read().split('\n')

# Clear the output file by opening it in write mode and writing an empty string
with open('Result.txt', 'w', encoding='utf-8') as file:
    file.write('')

# Initialize an empty string to store the current sequence (not strictly needed in this loop)
Seq = ''

# Iterate over each line in the tRNA list
for i in tRNA:
    # If the line contains the keyword "Length", treat it as the start of a new tRNA record
    if 'Length' in i:
        # Extract the header: everything before the first '(' character, prepend '>'
        OutName = '>' + i.split('(')[0] + '\n'
        # Append the header line to the output file
        with open('Result.txt', 'a', encoding='utf-8') as file:
            file.write(OutName)
    
    # If the line contains the keyword "Seq:", extract the sequence part
    if 'Seq: ' in i:
        # Remove the "Seq:" prefix and all whitespace, then add a newline
        Seq = i.split('Seq:')[1].replace(' ', '') + '\n'
        # Append the sequence line to the output file
        with open('Result.txt', 'a', encoding='utf-8') as file:
            file.write(Seq)
