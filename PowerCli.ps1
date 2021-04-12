$vServer = read-host -Prompt "Please enter vcsa host:"
$user = read-host -Prompt "Please enter username:"
$pass = read-host -Prompt "Please enter password:"

function connect {
    # Connect to the vcsa server with user provided credentials
    Connect-VIServer -Server $vServer -User $user -Password $pass
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
    $vhost = read-host -Prompt "Select VMHost:"

    #Select datastore
    get-vmhost -Name $vhost | get-datastore | select-object -Property Name
    $datastore = read-host -Prompt "Select Datastore:"
    

    # Set name of VM and how many to create
    $name = read-host -Prompt "Set name:"
    $loop = read-host -Prompt "How many to deploy:"

    if ($loop -gt 1) {
        # Loop for deploying more than one of OVA
	for ($n=1; $n -le $loop; $n++) {

		$nameN = ($name + $n)
		import-vapp -source $Source -VMHost $vhost -Datastore $datastore -Name $nameN

	}   
    }
    else {
	# Deploy single OVA
	import-vapp -source $Source -VMHost $vhost -Datastore $datastore -Name $name	

	}
}


function menu {

    # Display menu for user selection
    Write-Host "==Select an option=="
    write-host "1) Export OVAs"
    Write-Host "2) Import OVAs"
    $select = Read-Host -Prompt "Selection:"

# Switch statement calls OVA function based on user input
switch ( $select )
{
	1 { exportOVA }
	2 { importOVA }

}

}

connect
menu
