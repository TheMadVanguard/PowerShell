# Info
#
# This script removes the user from the recycle bin
#
# Version 1.0
# Written by Jay

Remove-MsolUser -UserPrincipalName ‘User@email.onmicrosoft.com’ -RemoveFromRecycleBin
