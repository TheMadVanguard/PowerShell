# Info
#
# Script to deploy AD
#
# Version 1.0
# Written by Jay


#Variables
$DomainName = "Domain Name"

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "$DomainName" `
-DomainNetbiosName "NetBIOS Name" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true