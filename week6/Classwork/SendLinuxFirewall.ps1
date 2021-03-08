# Transfer a file to our linux VM
Set-SCPFile -ComputerName '192.168.7.81' -Credential (Get-Credential sys320) `
-LocalFile .\toLinuxFirewall.bash -RemotePath /home/sys320

# Check that the file was uploaded
(Invoke-SSHCommand -index 0 "ls -l toLinuxFirewall.bash").Output