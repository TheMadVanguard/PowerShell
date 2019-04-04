# Info
#
# This script will connect to Meraki's AIP and change the wifi password.
#
# Version 1.0
# Written by Jay

#Variables
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11
#Meraki API KEY
$api_key = "API KEY"
#Meraki Network URL
$network_id = "N_ID NUMBER"
# SSID Number
$SSIDNumber = "SSID Number"

#Base API URL
$api = @{
    "endpoint" = 'https://api.meraki.com/api/v0'
}
#API URL for SSID PSK Change XXX
$api_put = @{
    "endpoint" = 'https://nxx.meraki.com/api/v0'
}

$header_org = @{
    "X-Cisco-Meraki-API-Key" = $api_key
    "Content-Type" = 'application/json'
}
# PSK = New password
$data = @{
    "psk" = Read-Host -Prompt 'Enter New Password'
}
#Convert data to Json format
$jbody = ConvertTo-Json -InputObject $data
#URL Network_ID and SSID number
$api.ssid = "/networks/$network_id/ssids/$SSIDNumber"
#Combine base api_put URL and $api.ssid
$Merakiuri = $api_put.endpoint + $api.ssid
Invoke-RestMethod -Method Put -Uri $Merakiuri -Headers $header_org -Body $jbody -Verbose