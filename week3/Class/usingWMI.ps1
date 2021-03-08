# Story line: Dig deeper into the Windows OS using WMI (Windows Management Instrumentation)

# List Wmi-objects
#Get-WmiObject -List

# Filter a specific WMI-Object
#Get-WmiObject -list | where {$_.Name -ilike "Win32_*"}

# Filter for WMI-object using regular expressions (regex)
#eGet-WmiObject -list | where {$_.Name -ilike "Win32_n*"} | sort

# Use Get-Member to list the properties for the wmi-object
#Get-WmiObject -Class Win32_account | Get-Member
#Get-WmiObject -Class Win32_account | select name, passwordRequired, PasswordExpired, InstallDate | export-csv -Path C:\Users\Admin\Documents -NoTypeInformation 
#Task: Dump the results to a csv file.


# Filter for the network adapter wmi-object using regex.

Get-WmiObject -Class win32_networkAdapter

#WMIC