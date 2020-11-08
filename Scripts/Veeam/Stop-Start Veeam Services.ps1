# Info
#
# This script stops or stats the Veeam services. 
#
# Version 1.0
# Written by Jay

# Gets Services
$VeeamServices = Get-Service | Where-Object  { $_.Name -like "Veeam*" -and $_.StartType -ne "Disabled" }

# Stop or Start menu
$StopOrStartMenu = [ordered]@{

  1 = 'Stop'

  2 = 'Start'

}
$StopOrStartMenu1 = $StopOrStartMenu | Out-GridView -Passthru -Title 'What are you doing?'
$StopOrStart = $StopOrStartMenu1.value

# Stop or Start action
if ($StopOrStart -eq "Stop")
{
foreach ($VeeamService in $VeeamServices)
{
Stop-Service $VeeamService
}
}
elseif ($StopOrStart -eq "Start")
{
foreach ($VeeamService in $VeeamServices)
{
Start-Service $VeeamService

}
}