$CVE_File = import-csv C:\Users\Admin\Desktop\cve-test.csv -Header Name,Status,Description

function searchCVEMenu {

    #Build out menu
    Write-host "================== CVE Search =================="
    Write-host "1) Search for a keyword in the name field"
    Write-Host "2) Search for a keyword in the description field"
    Write-Host "3) Exit"

    #prompt user
    $select = Read-Host -Prompt "Select and option: 1, 2, or 3"

    if ($select -eq 1) {
        searchCVEname

    } elseif ($select -eq 2) {
        searchCVEdesc

    } elseif ($select -eq 3) {
        exit

    } else {
        write-host "Invalid Option" -ForegroundColor Red
        sleep 2
        searchCVEMenu
    }
}

function searchCVEname {

    $keyword = Read-Host -Prompt "Provide a keyword to search for in the names field"

    foreach ($cveEntry in $CVE_File) {

        # read-host prompts for the user to select CVE Entry or Search by Description
        # For the description, which comparison operator will we use? -ilike
        if ($cveEntry.name -ilike "*$keyword*") {
    
            # Print that the CVE was found.
            write-host "Found."
            # Print the results for the CVE.
            $theName = $cveEntry.Name
            $theDesc = $cveEntry.Description
            $theStat = $cveEntry.Status

            write-host 
            Write-Host "CVE Name: $theName"
            Write-Host "CVE Description: $theDesc"
            Write-Host "CVE Status: $theStat"
            write-host
        } else {
            write-host "No entries found" -ForegroundColor Red
            continue
        }
        searchCVEMenu
    }
}
searchCVEMenu