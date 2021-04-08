$vServer = read_host -Prompt "Please enter vcsa host:"
$user = read_host -Prompt "Please enter username:"
$pass = read_host -Prompt "Please enter password:"

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
    $Source = read_host -Prompt "Provide path to OVA from Disk:"

    #Select host
    get-vmhost
    $host = read_host -Prompt "Select VMHost:"

    #Select datastore
    get-datastore
    $datastore = read_host -Prompt "Select Datastore:"
    


    $name = read_host -Prompt "Set name:"
    $loop = read_host -Prompt "How many to deploy:"

    if ($loop > 1) {

        $n = 1

       }
    while ($loop > 0) {

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
}
if (select = 1 ) {

    exportOVA
}

elif (select = 2) {

    importOVA
}

