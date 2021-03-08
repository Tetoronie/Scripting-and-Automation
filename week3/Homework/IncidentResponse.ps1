$path = Read-Host "Input a Folder Path (Full path with drive letter)"

#path set for testing
$path = "C:\Users\float\Desktop"

$1 = read-host "Get all processes [Y/N]"

if ($1 -ilike "y") {
    Write-Host -BackgroundColor Black -ForegroundColor Green "Retrieving processes..."
    Get-Process | select ProcessName, ID, Path | export-csv -NoTypeInformation -Path "$Path\Processes.csv"
    Write-Host -BackgroundColor Black -ForegroundColor Green "File exported to $path\Processes.csv"
    }
else {
    continue
    }

$2 = read-host "Get all services [Y/N]"

if ($2 -ilike "y") {
    Write-Host -BackgroundColor Black -ForegroundColor Green "Retrieving services..."
    Get-WmiObject -Class win32_service | select name, processid, PathName | export-csv -NoTypeInformation -Path "$path\AllService.csv"
    Write-Host -BackgroundColor Black -ForegroundColor Green "File exported to $path\AllService.csv"
    }
else {
    continue
    }

$3 = read-host "Get all running services [Y/N]"

if ($3 -ilike "y") {
    Write-Host -BackgroundColor Black -ForegroundColor Green "Retrieving all running services..."
    Get-WmiObject -Class win32_service | where {$_.state -eq "RUNNING"} | select state, name, processid, PathName | export-csv -NoTypeInformation -Path "$path\RunningService.csv"
    Write-Host -BackgroundColor Black -ForegroundColor Green "File exported to $path\RunningService.csv"
    }
else {
    continue
    }

$4 = read-host "Get all users [Y/N]"

if ($4 -ilike "y") {
    Write-Host -BackgroundColor Black -ForegroundColor Green "Retrieving all users..."
    Get-LocalUser | export-csv -NoTypeInformation -Path "$path\Users.csv"
    Write-Host -BackgroundColor Black -ForegroundColor Green "File exported to $path\Users.csv"
    }
else {
    continue
    }

$5 = read-host "Get all current TCP connections [Y/N]"

if ($5 -ilike "y") {
    Write-Host -BackgroundColor Black -ForegroundColor Green "Retrieving all TCP connections..."
    Get-NetTCPConnection | export-csv -NoTypeInformation -Path "$path\Connections.csv"
    Write-Host -BackgroundColor Black -ForegroundColor Green "File exported to $path\Connections.csv"
    }
else {
    continue
    }

$6 = Read-Host "Get all installed software [Y/N]"

if ($6 -ilike "y") {
    Write-Host -BackgroundColor Black -ForegroundColor Green "Retrieving all installed software..."
    Get-WmiObject -Class Win32_Product | export-csv -NoTypeInformation -Path "$path\Software.csv"
    Write-Host -BackgroundColor Black -ForegroundColor Green "File exported to $path\Software.csv"
    }
else {
    continue
    }
