# Info
#
# This script generates a secure credentials xml
#
# Version 1.0
# Written by Jay

$Name = Read-Host -Prompt "Who's credentials are these?"
$Server = $env:COMPUTERNAME
$credName = "$Server $Name"
Write-Host "Your credentials will be saved as $credName.xml"
read-host -Prompt "press enter to continue"
cls
$ExportPath = "S:\creds.xml"
$ExportPath
read-host -Prompt "press enter to continue"
$MyCredentials = Get-Credential | Export-Clixml $ExportPath 