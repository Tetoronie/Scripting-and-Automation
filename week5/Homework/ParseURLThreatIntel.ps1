
# Download CSV file
Invoke-WebRequest -uri http://malwaredomainlist.com/mdlcsv.php -OutFile .\outfile.csv

$file_name = ".\outfile.csv"

# Extract URLs from Column C. 
$CSV = import-csv -Path $file_name -Header Date,URL,IP

# Loop through the imported lines and extract the URL column using header and create file
ForEach-Object {$CSV.URL -ne "-"} | sort | Get-Unique | Set-Content -Path .\URLS.txt


# Pull URLS from file and format for Cisco Unified Threat manager
# Create file using the Cisco format
get-content -Path .\URLS.txt | % {$_ -replace "^", "parameter-map type regex urlf_blacklist_pma1 `nparameter " } `
| set-content -path .\CiscoURLS.txt

# Display file contents to command line for test purposes
Get-Content .\CiscoURLS.txt

# parameter-map type regex urlf_blacklist_pma1
# pattern www.example.com
