# Info
#
# Command to connect to Exchange Online.
#
# Version 1.1
# Written by Jay

# Moduel checking - Needs to be downloaded from https://outlook.office365.com/ecp/ "Hybrid > Setup"
Write-Host "You will need to ensure you have download the module from the ECP"
pause "Press any key to continue"

# Importing the EXOPS module
$module = ((Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | Select-Object -Last 1)
Import-Module $module

$session = New-ExoPSSession
Import-PSSession $session