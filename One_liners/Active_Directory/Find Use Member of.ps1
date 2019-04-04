# See what groups a user is part of
# Version 1.0
# Written by Jay

#Variables
$Username = Read-Host -Prompt "Enter Username"

#Command
(Get-ADUser $Username –Properties MemberOf | Select-Object MemberOf).MemberOf