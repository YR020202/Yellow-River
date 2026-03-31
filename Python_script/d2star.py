# Assign each virus to its closest MAG (metagenome-assembled genome) based on distance matrix
# The script reads a pairwise distance matrix (d2star_k6.csv) and assigns a virus to a MAG if the minimum distance < 0.25

import sys

# Define a helper function to find the minimum value and its index in a list
def find_min_index(lst):
    return min(lst), lst.index(min(lst))

# Open the CSV file containing distance values (format: first row is MAG names, first column is virus IDs)
with open('d2star_k6.csv', 'r', encoding='utf-8') as csvfile:
    reader = csvfile.read().split('\n')

# Initialize result list with header "Virus,MAG"
result = ['Virus,MAG']

# Extract MAG names from the first row (skip the first empty cell if present)
MAGS = reader[0].split(',')

# Iterate over each data row (skip header row and last empty row)
for i in range(1, len(reader) - 1):
    # Convert distance values from the current row to floats, excluding the first column (virus ID) and last empty cell
    data_list = [float(item) for item in reader[i].split(',')[1:][:-1]]
    
    # Find the minimum distance and its corresponding MAG index
    min_num, min_index = find_min_index(data_list)
    
    # If the minimum distance is below the threshold (0.25), assign the virus to that MAG
    if min_num < 0.25:
        MAG = MAGS[min_index + 1]  # +1 to skip the initial empty cell in MAG list
        virus_id = reader[i].split(',')[0]
        result.append(f'{virus_id},{MAG}')

# Write the assignment results to result.csv
with open('result.csv', 'w', encoding='utf-8') as file:
    file.write('\n'.join(result))