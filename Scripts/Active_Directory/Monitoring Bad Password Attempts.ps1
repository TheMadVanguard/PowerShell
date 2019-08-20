# Info
#
# This script queries a domain controller and monitors for a password spray attack.
#
# Version 1.0
# Written by Jay

# Variable
$Amount = 150
$Computername = HostName

# Resetting the variable after 11:35:00 PM and before 11:59:59 PM
If ((Get-Date) -gt (get-date).date.AddHours(23.5836) -and (Get-Date) -le (get-date).date.AddHours(23.9998)) {
Write-Host yay -ForegroundColor red
[Environment]::SetEnvironmentVariable("BadPasswordCount",0,"user")
}

# Getting the Variable
$GetVariable = [int]$env:BadPasswordCount

# Adding the amount to the variable 
$VarAndAmount = $GetVariable + $Amount

# Getting the bad password count
$GetCount = (Get-ADUser -Filter * -Properties badpwdcount,LastBadPasswordAttempt -Server $Computername | Where {$_.LastBadPasswordAttempt -gt (Get-Date).date}).badpwdcount.count

# Comparing the count to the amount
If ($GetCount -gt $VarAndAmount)
    {
    $Alert = "1"
    }

# Webhook Variables
$Status = "Critical"
$MessTitle = "Password Monitoring"
$MessBody = "We have detected a high number of bad password attempts on $Computername."
$ActSubtitle = "There are currently $GetCount bad passwords attempts"
$ButtonURL = ""
$WebHookURL = 'URL'

# Sending the alert
If ($Alert -eq 1)
    {
    Send-TeamChannelMessage -MessageType $Status -MessageTitle "$MessTitle" -MessageBody "$MessBody" `
                -activityTitle "" -activitySubtitle $ActSubtitle -URI "$WebHookURL" -buttons @(@{ name = 'Button'; value = "$ButtonURL" })
    }

# Setting the Variable
[Environment]::SetEnvironmentVariable("BadPasswordCount",$GetCount,"user")