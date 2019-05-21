# Info
#
# Command to connect to Office 365.
#
# Version 1.1
# Written by Jay


#Variables
$MyCreds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $MyCreds -Authentication Basic -AllowRedirection

Import-PSSession $Session