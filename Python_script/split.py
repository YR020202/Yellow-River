# Split a multi‑FASTA file (vOTU.fa) into individual FASTA files, each containing a single sequence
# A new output folder with a timestamp is created to store the split files

import time, os, sys
from datetime import datetime, timedelta

# Create a timestamped output folder inside './OutputFolder'
def CreateFolder():
    # Create the base output directory if it does not exist
    if not os.path.exists(f'./OutputFolder'):
        os.makedirs(f'./OutputFolder')
    
    # Obtain the current Unix timestamp (integer) for unique naming
    current_time = time.time()
    timestamp = int(current_time)
    
    # Format the current date as YYYY‑MM‑DD
    day = (datetime.now() - timedelta(days=0)).strftime('%Y-%m-%d')
    
    # Define the full output folder path: ./OutputFolder/YYYY-MM-DD_timestamp/
    OutputFolder = ('./OutputFolder/' + str(day) + '_' + str(timestamp) + '/')
    
    # Create the timestamped output folder
    os.makedirs(OutputFolder)
    
    return OutputFolder

def main():
    # Create the output folder and get its path
    OutputFolder = CreateFolder()
    
    # Read the entire multi‑FASTA file (expected format: sequences separated by '>')
    with open("vOTU.fa", "r") as file:
        content = file.read()
    
    # Split the content by the '>' character; the first element is empty
    rows = content.split('>')
    
    # Iterate over each sequence record (skip the first empty element)
    for i in range(1, len(rows)):
        j = rows[i]
        if j != '':
            # Extract the sequence identifier (first line of the record)
            file_name = j.split('\n')[0] + '.fasta'
            
            # Reconstruct the FASTA entry by adding back the '>' prefix
            file_content = '>' + j
            
            # Write the individual FASTA file to the output folder
            with open(OutputFolder + file_name, 'w', encoding='utf-8') as file:
                file.write(file_content)
            
            # Print progress percentage (overwrites the same line)
            print(f"\rCompleted {int((i/len(rows))*100)}%", end='', flush=True)
    
    # Print final completion message
    print(f"\rCompleted", end='', flush=True)

# Execute the main function
main()
