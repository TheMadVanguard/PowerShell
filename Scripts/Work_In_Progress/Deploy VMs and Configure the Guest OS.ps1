# DISCLAIMER: There are no warranties or support provided for this script. Use at you're own discretion.

# This Script is Primarily a Deployment Script. It will first deploy a template from your vSphere environment
# and apply a customization specification

# This section insures that the PowerCLI PowerShell Modules are currently active.
Import-Module VMware.VimAutomation.Core

# ------vSphere Targeting Variables tracked below------
$vCenterInstance = "vCenterAddress.local"
$vCenterUser = "vCenter User Name Here"
$vCenterPass = "vCenter Password Here"

# This section logs on to the defined vCenter instance above
Connect-VIServer $vCenterInstance -User $vCenterUser -Password $vCenterPass -WarningAction SilentlyContinue

# ------Virtual Machine Targeting Variables tracked below------

# The Below Variables define the name of the VM, the target cluster and the source template and customization specification
# inside of vCenter to use during the deployment the Vs.
$DesiredVMName = "Desired Name Here"
$TargetCluster = Get-Cluster -Name "Target Cluster Name"
$SourceVMTemplate = Get-Template -Name "Source Template"
$SourceCustomSpec = Get-OSCustomizationSpec -Name "Source Customization Spec"

# ------This section contains the commands for defining the IP and networking settings for the new virtual machine------
# The below IPs and Interface Names need to be updated for your environment. 
 
# Desired VM IPAddressing Below
# Insert IP info in IP SubnetMask Gateway Order
$VMNetworkSettings = 'netsh interface ip set address "Ethernet0" static x.x.x.x 255.255.255.0 x.x.x.x'
# DNS Servers
$VMDNSSettings = 'netsh interface ip set dnsservers name="Ethernet0" static x.x.x.x primary'

# Script Execution Occurs from this point down
 
# ------This Section Deploys the new VM(s) using a pre-built template and then applies a customization specification to it. It then waits for Provisioning To Finish------
 
Write-Verbose -Message "Deploying Virtual Machine with Name: [$DesiredVMName] using Template: [$SourceVMTemplate] and Customization Specification: [$SourceCustomSpec] on Cluster: [$TargetCluster] and waiting for completion" -Verbose
 
New-VM -Name $DesiredVMName -Template $SourceVMTemplate -ResourcePool $TargetCluster -OSCustomizationSpec $SourceCustomSpec
 
Write-Verbose -Message "Virtual Machine $DesiredVMName Deployed. Powering On" -Verbose
 
Start-VM -VM $DesiredVMName

# ------ Verify Guest Customization Has Finished

# We verify that the guest customization has finished on on the new VM by using the below loops to look for the relevant events within vCenter. 

 Write-Verbose -Message "Verifying that Customization for VM $DesiredVMName has started ..." -Verbose
	while($True)
	{
		$NewVMEvents = Get-VIEvent -Entity $DesiredVMName 
		$DCstartedEvent = $DCvmEvents | Where { $_.GetType().Name -eq "CustomizationStartedEvent" }
 
		if ($DCstartedEvent)
		{
			break	
		}
 
		else 	
		{
			Start-Sleep -Seconds 5
		}
	}
  
  Write-Verbose -Message "Customization of VM $$DesiredVMName has started. Checking for Completed Status......." -Verbose
	while($True)
	{
		$DCvmEvents = Get-VIEvent -Entity $DesiredVMName 
		$DCSucceededEvent = $DCvmEvents | Where { $_.GetType().Name -eq "CustomizationSucceeded" }
        $DCFailureEvent = $DCvmEvents | Where { $_.GetType().Name -eq "CustomizationFailed" }
 
		if ($DCFailureEvent)
		{
			Write-Warning -Message "Customization of VM $DesiredVMName failed" -Verbose
            return $False	
		}
 
		if ($DCSucceededEvent) 	
		{
            break
		}
        Start-Sleep -Seconds 5
        
Write-Verbose -Message "Customization of VM $DesiredVMName Completed Successfully!" -Verbose

# NOTE - The below Sleep command is to help prevent situations where the post customization reboot is delayed slightly causing
# the Wait-Tools command to think everything is fine and carrying on with the script before all services are ready. Value can be adjusted for your environment. 
Start-Sleep -Seconds 30

Write-Verbose -Message "Waiting for VM $DesiredVMName to complete post-customization reboot." -Verbose

Wait-Tools -VM $DesiredVMName -TimeoutSeconds 300

# NOTE - Another short sleep here to make sure that other services have time to come up after VMware Tools are ready. 
Start-Sleep -Seconds 30

# After Customization Verification is done we change the IP of the VM to the value defined near the top of the script
Write-Verbose -Message "Getting ready to change IP Settings on VM $DesiredVMName." -Verbose
Invoke-VMScript -ScriptText $VMNetworkSettings -VM $DesiredVMName

# NOTE - The Below Sleep Command is due to it taking a few seconds for VMware Tools to read the IP Change so that we can return the below output. 
# This is strctly informational and can be commented out if needed, but it's helpful when you want to verify that the settings defined above have been 
# applied successfully within the VM. We use the Get-VM command to return the reported IP information from Tools at the Hypervisor Layer. 
Start-Sleep 30
$DCEffectiveAddress = (Get-VM $DesiredVMName).guest.ipaddress[0]
Write-Verbose -Message "Assigned IP for VM [$DesiredVMName] is [$DCEffectiveAddress]" -Verbose
