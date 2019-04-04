# Info
#
# This script remove disabled users from an AD Groups
# Version 0.1
# Written by Jay

# Variables 
$Group = "GROUP_NAME"

$DisabledUser = Get-ADGroupMember -Identity $Group | Get-ADUser | Where-Object {$_.Enabled -eq $false}

Remove-ADGroupMember -Identity "$Group" -Members $DisabledUser -Confirm:$false