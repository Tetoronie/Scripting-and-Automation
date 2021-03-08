Get-EventLog -list
# user prompt
$u_prompt = Read-Host -Prompt "Please specify an Eventlog to search"
$u_message = Read-Host -Prompt "Please specify a keyword to search for"
$u_path = Read-Host -Prompt "Please specify a path to save to(eg: C:\users\chris\Desktop\output.csv)"

Write-host "Path: $u_path" -ForegroundColor DarkMagenta 

# Search the event log
Get-EventLog $u_prompt | where {$_.Message -ilike "*$u_message*"} `
| Export-Csv -NoTypeInformation -Path "$u_path"