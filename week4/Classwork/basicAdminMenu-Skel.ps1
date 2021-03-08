# Create menus for sys admin and sec admin task
function showmenu {

    # Clear the screen
    cls

    # Create our menus
    Write-Host "~~~~~~~~~~~~~ Administration Menu ~~~~~~~~~~~~~"
    Write-Host "1) System Administration"
    Write-Host "2) Security Administration"
    Write-Host "[E]xit"

    # Prompt the user for a selection
    $u_select = read-host -Prompt "Please select one of the options above"

    # Process the user response
    if ($u_select -eq 1) {
    
        # Call the sysadmin function
        sysAdmin
    
    } elseif ($u_select -eq 2 ) {

        # Call the secAdmin function
        secAdmin

    } elseif ($u_select -eq "E") {

        # exit the program
        exit

    } else {
    
        # out-host shows results right away
        write-host "Invalid value: $u_select" | out-host
        sleep 2
        showMenu
    
    }

}




# This function will provide a prompt to the user to hit Enter when they are done reviewing the results
# and take them back to the menu they were in.
function allDone  {

    read-host -prompt "Press [Enter] when done."

}

# Process sys admin tasks.
function sysAdmin {

    # Clear the screen
    clear

    # Build our menu
    write-host "~~~~~~~~~~~~~ System Administration Menu ~~~~~~~~~~~~~"
    write-host "1) Show Running Processes"
    Write-Host "2) Show Running Services"
    Write-Host "3) Show Running Services with Path"
    write-host "[R]eturn to main menu"
    Write-Host "[E]xit"
   
    # Prompt the user
    $sysAdminTask = Read-Host -Prompt "Please select one of the above options: 1, 2, 3, R, or E"

    #use switch statement
    switch ($sysAdminTask) {

        1 { Get-Process | out-host }
        2 { Get-Service | where {$_.Status -eq "Running"} | out-host }
        3 { Get-WmiObject -Class win32_service | where {$_.status -eq "Running"} | select Name, ProcessID, PathName | out-host }
        R { showmenu }
        E { exit }

        default {
            write-host "Invalid option" -foregroundcolor Red
            sleep 4

            # Call the system admin menu so the user can start again.
            sysAdmin
         }

    } # End sysadmin switch statement

<#   
    #Process the user's input
    if ($sysAdminTask -eq "R") {
        showmenu
    
    } elseif ($sysAdminTask -eq 1) {
        Get-Process | out-host
    
    } elseif ($sysAdminTask -eq 2) {
        get-service | where {$_.Status -eq "Running"} | out-host
   
    } elseif ($sysAdminTask -eq 3) {
        Get-WmiObject -Class win32_service | where {$_.status -eq "Running"} | select Name, ProcessID, PathName | out-host
   
    } elseif ($sysAdminTask -eq "E") {
        exit
    
    } else {
    
        write-host "Invalid option"
        sleep 4

        # Call the system admin menu so the user can start again.
        sysAdmin
    
    }
    #>

    # Allow the user to review the results
    allDone
    

    # Call the sysAdmin menu, because they are currently working in this menu.  
    sysAdmin
     
} # END sysAdmin function

function secAdmin {
    
    clear

    # build out menu
    write-host "~~~~~~~~~~~~~ Security Administration Menu ~~~~~~~~~~~~~"
    write-host "1) Show Running Processes with path, ID, and process name"
    Write-Host "2) Show Installed packages"
    Write-Host "3) Show User Accounts with name, password required, and expiration"
    write-host "[R]eturn to main menu"
    Write-Host "[E]xit"

    # Prompt the user
    $secAdminTask = Read-Host -Prompt "Please select one of the above options: 1, 2, 3, R, or E"

        #Process the user's input
    if ($secAdminTask -eq "R") {
        showmenu
    
    } elseif ($secAdminTask -eq 1) {
        Get-Process | select Id, ProcessName, path | out-host

    
    } elseif ($secAdminTask -eq 2) {
        get-package | out-host
   
    } elseif ($secAdminTask -eq 3) {
        Get-LocalUser | select Name, PasswordRequired, PasswordExpires | Out-Host
   
    } elseif ($secAdminTask -eq "E") {
        exit
    
    } else {
    
        write-host "Invalid option"
        sleep 4
        }

        allDone

        # Call the security admin menu so the user can start again.
        secAdmin


}


# call the mainMenu function
showMenu