# Info
#
# This script queries the PDC to find the lock out logs for a user.
#
# Version 1.0
# Written by Jay

$LockUserName = Read-Host "Please enter username"
#Get main DC
$LockPDC = (Get-ADDomainController -Filter * | Where-Object {$_.OperationMasterRoles -contains "PDCEmulator"}).hostname
#Get user info
$LockUserInfo = Get-ADUser -Identity $LockUserName
#Search PDC for lockout events with ID 4740
$LockedOutEvents = Get-WinEvent -ComputerName $LockPDC -FilterHashtable @{LogName='Security';Id=4740} -ErrorAction Stop | Sort-Object -Property TimeCreated
#Parse and filter out lockout events
Foreach($LockEvent in $LockedOutEvents){
    If($LockEvent | Where {$_.Properties[2].value -match $LockUserInfo.SID.Value}){
        $LockUsernameEvent = $LockEvent | Select-Object -Property @(
        @{Label = 'User'; Expression = {$_.Properties[0].Value}}
        @{Label = 'DomainController'; Expression = {$_.MachineName}}
        @{Label = 'EventId'; Expression = {$_.Id}}
        @{Label = 'LockoutTimeStamp'; Expression = {$_.TimeCreated}}
        @{Label = 'Message'; Expression = {$_.Message -split "`r" | Select -First 1}}
        @{Label = 'LockoutSource'; Expression = {$_.Properties[1].Value}}
        )
        $LockUsernameEvent
    }
}
$LockUsernameEventSource = $LockUsernameEvent.LockoutSource
Write-Host "The last lockout occurred on " -ForegroundColor Green -NoNewline
Write-Host "$LockUsernameEventSource" -ForegroundColor Red -BackgroundColor black

#Read-Host "ok?"

Get-Variable -Name "lock*" | Clear-Variable
Get-Variable -Name "lock*" | Remove-Variable