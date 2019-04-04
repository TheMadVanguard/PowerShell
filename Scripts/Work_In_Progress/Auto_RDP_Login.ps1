# Info
#
# Auto login RDS Sessions
#
# Version 1.0
# Written by Jay

Invoke-Item "C:\scripts\RDP Login.rdp"
Start-Sleep -Seconds 5
Stop-Process -Name mstsc
