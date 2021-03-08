#Get-EventLog -list
Write-Host "This script grabs all successful security events before 8/30/2019" -ForegroundColor DarkCyan -BackgroundColor Black
# user prompt
#$u_prompt = Read-Host -Prompt "Please specify an Eventlog to search"
#$u_message = Read-Host -Prompt "Please specify a keyword to search for"
$u_save = Read-Host -Prompt "Would you like to export and save the file (Y/N)?"

if ($u_save -ilike "y") {
    $u_path = Read-Host -Prompt "Please specify a path to save to(eg: C:\users\chris\Desktop\output.csv)"

    Write-host "Path: $u_path" -ForegroundColor DarkMagenta -BackgroundColor Black

    #Search EventLog and export
    Get-EventLog Security | where {$_.Message -ilike "*Successful*"} | Export-Csv -NoTypeInformation -Path "$u_path"
    Write-Host "Export successful" -ForegroundColor Green -BackgroundColor Black }

elseif ($u_save -ilike "n") {
    # Search the event log
    Get-EventLog Security | where {$_.Message -ilike "*Successful*"} }

else {
    Write-Host "Something went wrong" -ForegroundColor DarkRed }