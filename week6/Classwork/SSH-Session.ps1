# Use SSH to login to Linux VM
#New-SSHSession -ComputerName '192.168.7.81' -Credential (get-credential sys320)



while ($true) {
    
    <#
        Create a prompt that allows users to run interactive commands then wait for
        the command: exit
        and break the user out of the while loop, otherwise, run the command.
    #>

    $the_cmd = Read-host -Prompt "Please enter a command (type exit to exit)"
    
    if ($the_cmd -ilike 'exit'){

        # Exit out of system
        break
    }
    
    else {
        
        # Run a command on the remote system
        (Invoke-SSHCommand -index 0 $the_cmd).output
    }
}