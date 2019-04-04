# Info
#
# This script adds sound to the Test-Connection cmdlet.
#
# Version 0.1
# Written by Jay


#Variables
$Server = Read-Host "Enter hostname or IP address to monitor by sonar"
$x = 0

Write-Host "Pinging $Server by sonar . . . "
Write-Host "(Press Ctrl-C to break out of sonar loop.)"
do
{ $x = $x + 1
if (Test-Connection -count 1 -quiet -computer $Server)
{
write-host "still on our Radar Sir" -foregroundcolor green
[console]::beep(500,600)
Start-Sleep -s 2
}
else
{
[console]::beep(500,60)
write-host "Sir! Panic Stations! We have lost it Sir!" -foregroundcolor red
$x = $x + 1
}
}
until
($x = 0) 