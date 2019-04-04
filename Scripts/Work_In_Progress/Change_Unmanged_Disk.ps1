# Info
#
# Script that will increase an Azure VM Disk
#
# Version 0.1
# Written by Jay

#Variables

Connect-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName 'Microsoft Azure Enterprise'
$rgName = 'Resource Group Name'
$vmName = 'Server Name'
$vm = Get-AzureRmVM -ResourceGroupName $rgName -Name $vmName
Stop-AzureRmVM -ResourceGroupName $rgName -Name $vmName 
$vm.StorageProfile.OSDisk.DiskSizeGB = 36
Update-AzureRmVM -ResourceGroupName $rgName -VM $vm
Start-AzureRmVM -ResourceGroupName $rgName -Name $vmName