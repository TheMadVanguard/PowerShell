# Info
#
# Script to monitor the DEV Hutwood court vCenter and report on VMs with Snapshots
#
#
# Version 1.0
# Updated by Jay 

# Imports Module
Import-Module VMware.PowerCLI

# vCenter Variables 
$vCenter = "JP-VCSA-001.jayp.io"
$vCenter_Name = "JP-VCSA-001.jayp.io"

# Connects to vCenter
Connect-VIServer $vCenter -WarningAction SilentlyContinue
$Snaps = Get-VM | Get-Snapshot | Select-Object VM,name,Description,Created
Disconnect-VIServer $vCenter -Confirm:$false

# A for each, if there is more than 1 snapshot
foreach ($Snap in $Snaps)
{
  if ($Snaps -ne $null)
  {
    $Snap_Report = "Yes"
  }
  else
  {
    $Snap_Report = "No"
  }
  if ($Snap_Report -eq "Yes")
  {

    # Snap details
    $SnapVM = $Snap.VM
    $SnapName = $Snap.Name
    $SnapDate = $Snap.Created

    # General Webhook Variables
    $Status = "Warning"
    $MessTitle = "VMWare $vCenter_Name snapshot Alert"
    $MessBody = "The following VM has a snapshot within VMWare."
    $WebHookURL = 'SOMETHING SOMETHING URL'
    $ActSubtitle = "Snap Detials: VM - $SnapVM, Snap Name - $SnapName, Created Date - $SnapDate"
    $ButtonURL = "https://$vCenter/ui/"


    # Sends Notification
   # Send-TeamChannelMessage -MessageType $Status -MessageTitle "$MessTitle" -MessageBody "$MessBody" `
   #    -activityTitle "" -activitySubtitle "$ActSubtitle" -Uri "$WebHookURL" -buttons @(@{ Name = 'vSphere'; value = "$ButtonURL" })
  }
}
