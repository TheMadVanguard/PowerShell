# Info
#
# This script searches Exchange and finds any enabled mailbox that is hidden from the GAL
#
# Version 1.0
# Written by JayP

# Get Snapin
Add-PSSnapin -Name Microsoft.Exchange.M*

# Command 
Get-Mailbox -ResultSize Unlimited | Where {($_.HiddenFromAddressListEnabled -eq $True) -and ($_.IsMailboxEnabled -eq $True)} | Select DisplayName,UserPrincipalName,HiddenFromAddressListsEnabled, IsMailboxEnabled | Export-CSV "C:\Temp\Hidden_from_GAL_and_is_Enabled.csv" -NoTypeInformation -Encoding UTF8
