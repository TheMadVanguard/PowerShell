# Info
#
# Script to remove files older than 15 Days
#
# Version 1.0
# Written by Jay

# Variables 
$Limit = (Get-Date).AddDays(-15)
$Path = "FOLDER LOCATION"

# Delete files older than the $Limit.
Get-ChildItem -Path $Path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $Limit } | Remove-Item -Force