# Info
#
# This function queries the Meraki dashboard and returns the networks. 
#
# Version 1.0
# Written by Jay

# Variables
$api_key = 'INSET API KEY'

function Get-MerakiNetworks {

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/organizations/$OrganizationID/networks'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}