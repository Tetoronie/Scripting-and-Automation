$vServer = read-host -Prompt "Please enter vcsa host:"
$user = read-host -Prompt "Please enter username:"
$pass = read-host -Prompt "Please enter password:"

function connect {
    Connect-VIServer -Server $vServer -User $user -Password $pass
}


function listProfile {

    Get-vmhostprofile
}

function startAll {

    $list = Get-VM

    foreach($vm in $list) {
        Start-VM -VM $vm -Confirm:$false
    }
}

function exportOVA {

    #select VM
    get-vm
    $vm = read-host -Prompt "Select VM to export to OVA:"

    #Set Name
    $name = Read-Host -Prompt "Create a Name for OVA:"

    #Set destination
    $dest = Read-Host -Prompt "Set destination:"

    export-vapp -format OVA -VM $vm -Name $name -Destination $dest

}

function importOVA {

    #select OVA
    $Source = read-host -Prompt "Provide path to OVA from Disk:"

    #Select host
    get-vmhost
    $host = read-host -Prompt "Select VMHost:"

    #Select datastore
    get-datastore | select-object -Property Name, ID
    $datastore = read-host -Prompt "Select Datastore:"
    


    $name = read-host -Prompt "Set name:"
    $loop = read-host -Prompt "How many to deploy:"

    if ($loop -gt 1) {

        $n = 1

       }
    while ($loop -gt 0) {

        $nameN = ('$name' + '$n')

        import-vapp -source $Source -VMHost $host -Datastore $datastore -Name $nameN

        $n + 1
        $loop - 1
    }
}


function menu {
    Write-Host "==Select an option=="
    write-host "1) Export OVAs"
    Write-Host "2) Import OVAs"
    $select = Read-Host -Prompt "Selection:"



<#
if (1 -eq $select ) {

    exportOVA
}

elseif (2 -eq $select) {

    importOVA
}
#>

switch ( $select )
{
	1 { write-host "1"
		exportOVA }
	2 { importOVA }

}

}

#connect

menu 
