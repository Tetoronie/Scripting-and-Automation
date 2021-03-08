#get-service | Get-Member #gm
#get-service | Export-Csv -NoTypeInformation `
#-Path "C:\Users\Christopher.mathieso\Desktop\services.csv"

#Get-Service | where {$_.Status -eq "Running"}
$u_status = read-host -Prompt "Please enter a service status."

Get-Service | where {$_.Status -eq "$u_status"}