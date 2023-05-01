# Info
#
# Script to deploy AD
#
# Version 0.2
# Written by Jay

# To install the Active Directory Domain Services (ADDS) role. To do it, run the following command in the PowerShell console:

Install-WindowsFeature AD-Domain-Services –IncludeManagementTools -Verbose

#Make sure that the AD-Domain-Services role is installed:

Get-WindowsFeature -Name *AD*

#Variables
$DomainName = "DOMAIN.NAME"
$NetBIOSName = "DOMAINNAME"
$Password = Read-Host -Prompt 'Enter SafeMode Admin Password' -AsSecureString

#Config
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "$DomainName" `
-DomainNetbiosName "$NetBIOSName" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $Password `
-Force:$true
