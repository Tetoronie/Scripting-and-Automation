# Array of websites containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rules list
foreach ($u in $drop_urls) {

    # Extract the filename
    $temp = $u.split("/")
    
    # The last element in the array plucked off is the filename
    $file_name = "./" +$temp[4]

    # Temp to prevent routinely downloading files
    if (Test-path -Path $file_name) {
        
        $uinput = read-host "File: $file_name found, would you like to download an up to date copy? (Y/N)"
        switch ($uinput) {
            Y { Invoke-WebRequest -Uri $u -OutFile $file_name }
            N { continue }
            default { write-host -ForegroundColor Red "Invalid input"}

        }
    
    } else {
        
        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name

    } # check if file exists

} # End foreach loop

# Array containing the filename
$input_paths = @('.\emerging-botcc.rules','.\compromised-ips.txt')


# Extract the IP addresses.
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list.
Select-String -Path $input_paths -Pattern $regex_drop | ForEach-Object { $_.matches } | `
ForEach-Object { $_.value } | sort | Get-Unique | `
# Write results to file
set-content -Path "ips-bad.txt"

<#

Task: Create a prompt ans ask the user if they want to save the file for IPTables or as a Cisco ACL,
then create the appropriate syntax

Cisco example:

access-list 1 deny host 103.133.104.71

#>
# Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
# After the IP address, add the remaining IPTables syntax and save the results to a file.
# IPTables: iptables -A input -s 104.131.182.103 -j DROP

$Uinput = Read-Host -Prompt "Save file for [I]PTables or [C]isco ACL" 

if ($Uinput -ilike "I") {
    
    (Get-Content -Path ".\ips-bad.txt") | `
    % {$_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
    Set-Content -path "toLinuxFirewall.bash"

    # Put file into variable for later use
    $setfile = ".\toLinuxFirewall.bash"

    # Open file in notepad for verification
    notepad $setfile


} elseif ($Uinput -ilike "C") {
    
    (Get-Content -Path ".\ips-bad.txt") | `
    % {$_ -replace "^", "acces-list 1 deny host "} | `
    Set-Content -path "toCisco.bash"
        
    $setfile = ".\toCisco.bash"

    notepad $setfile

} else {
    Write-Host -ForegroundColor Red "Invalid option"
}

<#
switch ($Uinput) {
    I {
    (Get-Content -Path ".\ips-bad.txt") | `
    % {$_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
    Set-Content -path "toLinuxFirewall.bash"
    }
    C {
    (Get-Content -Path ".\ips-bad.txt") | `
    % {$_ -replace "^", "acces-list 1 deny host "} | `
    Set-Content -path "toCisco.bash"
    }

    default{write-host -foregroundcolor Red " Invalid option"}


#>

$switch = Read-Host "Send file over ssh? (Y/N)"

switch ($switch) {

    Y {

    # Create SSH session
    New-SSHSession -ComputerName '192.168.7.81' -Credential (get-credential sys320)

    # Send file in format that was chosen
    Set-SCPFile -ComputerName '192.168.7.81' -Credential (Get-Credential sys320) `
    -LocalFile $setfile -RemotePath /home/sys320

    }
    n {exit}
    default {exit}
}