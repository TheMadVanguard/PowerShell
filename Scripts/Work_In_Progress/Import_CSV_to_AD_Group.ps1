# Info
#
# Script that adds members from a CSV file to a AD Group.
#
# Version 0.1
# Written by Jay

#Variables
$Group = " AD GROUP"
$CSVFile = "CSV Location"

Import-CSV $CSVFile | %{Add-ADGroupMember -Identity $Group -Members $_.UserName} 