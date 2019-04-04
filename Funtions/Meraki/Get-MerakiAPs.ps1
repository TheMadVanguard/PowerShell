# Info
#
# This function queries the Meraki Access Points
#
# Version 1.0
# Written by Jay

# Variables
$api_key = 'INSET API KEY'

function Get-MerakiAPs {

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/networks/$Nerwork_ID/devices'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}