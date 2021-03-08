#get-service | Get-Member #gm
#get-service | Export-Csv -NoTypeInformation `
#-Path "C:\Users\Christopher.mathieso\Desktop\services.csv"

#Get-Service | where {$_.Status -eq "Running"}
#$u_status = read-host -Prompt "Please enter a service status."

#Get-Service | where {$_.Status -eq "$u_status"}

Get-EventLog -list
# user prompt
$u_prompt = Read-Host -Prompt "Please specify an Eventlog to search"
$u_message = Read-Host -Prompt "Please specify a keyword to search for"
# Search the event log
Get-EventLog $u_prompt | where {$_.Message -ilike "*$u_message*"} `
| Export-Csv -NoTypeInformation -Path "C:\users\Chris\Desktop\messages.csv"

# Task: Modify the code above to add a prompt for the user to specify a keyword to search on.
# so replace "success" with the variable you created for the prompt