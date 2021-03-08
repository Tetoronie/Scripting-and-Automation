# Story Line: Download a CVE file and process it to look for vulnerabilities

# Download the CVE file
#import-csv C:\Users\Admin\Desktop\cve-test.csv
# Import the cve file into powershell.
$CVE_File = import-csv C:\Users\Admin\Desktop\cve-test.csv -Header Name,Status,Description

$user_input = read-host -Prompt "Please enter a product or keyword to search for"

$notFound = "true"
#$CVE_File |gm
write-host -BackgroundColor Red -ForegroundColor white "Searching for your info..."
# Then we will search for some data.
foreach ($cveEntry in $CVE_File) {

# read-host prompts for the user to select CVE Entry or Search by Description
     # For the description, which comparison operator will we use? -ilike
    if ($cveEntry.Description -ilike "*$user_input*") {
    
        # Print that the CVE was found.
        write-host "Found."
        # Print the results for the CVE.
        $theName = $cveEntry.Name
        $theDesc = $cveEntry.Description
        $theStat = $cveEntry.Status

        Write-Host "CVE Name: $theName"
        Write-Host "CVE Description: $theDesc"
        Write-Host "CVE Status: $theStat"

        # Set value to false to denote the entry was found.
        $notFound = "false"
        # Stops the foreach loop since the file only contains one CVE named "CVE-1999-0001"
        # This reduces memory and file read operations and you get the results faster.
        #break
    
    } else {

        #If the notfound variable is set to true, it should never be set to "false" again.
        if ($notFound -eq "false") {
            continue
        }
        else {
            $notFound = "true"
        }
    
    } # end check for CVE
    
} # end foreach loop

# Print if there was no entry found.
if ($notFound -eq "true" ) {
    write-host "CVE not found."
}