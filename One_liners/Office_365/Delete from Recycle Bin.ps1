#This script removes the user from the recycle bin
Remove-MsolUser -UserPrincipalName ‘User@email.onmicrosoft.com’ -RemoveFromRecycleBin
