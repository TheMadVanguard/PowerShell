# Info
#
# Script to create Azure resources. 
# Resource Group, VNet, NSG, Subnet. 
#
# Version 1.0
# Created by Jay 

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

# Name Variables
$Name = "CHANGE ME"

#General Variables 
$Location = "LOCATION"
$SubName = "NAME"

#Tag Variables  
$Environment = "ENV"
$Owner = "OWNER"
$Team = "TEAM"
$RGType = "ResourceGroup"
$NSGType = "NSG"
$VNETType = "VNET"

#Creating the Resource Group
New-AzResourceGroup `
    -Name "RG_$Name" `
    -Location $Location `
    -Tag @{Environment="$Environment"; Owner="$Owner"; Team="$Team"; Type="$RGType"}

#Creating the NSG
New-AzNetworkSecurityGroup `
    -name "NSG_$Name" `
    -Location $Location `
    -ResourceGroupName "RG_$Name" `
    -Tag @{Environment="$Environment"; Owner="$Owner"; Team="$Team"; Type="$NSGType"}

#Creating the VNet
New-AzVirtualNetwork `
    -ResourceGroupName "RG_$Name" `
    -Location $Location `
    -Name "VNET_$NAME" `
    -AddressPrefix 1.1.1.1/24 `
    -Tag @{Environment="$Environment"; Owner="$Owner"; Team="$Team"; Type="$VNETType"} 

#Getting the VNet
$vnet = Get-AzVirtualNetwork -Name "VNET_$NAME" -ResourceGroupName "RG_$Name"

#Getting the NSG
$NSG = (Get-AzNetworkSecurityGroup -name "NSG_$name" -ResourceGroupName "RG_$Name").id

#Creating the Subnet
$subnetConfig = add-AzVirtualNetworkSubnetConfig -Name $SubName -VirtualNetwork $vnet -AddressPrefix 1.1.1.1/28 -NetworkSecurityGroupId "$NSG"  | Set-AzVirtualNetwork