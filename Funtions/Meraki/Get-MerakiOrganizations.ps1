# Info
#
# This function queries the Meraki dashboard and reports on the Organizations. 
#
# Version 1.0
# Written by Jay

# Variables
$api_key = 'INSET API KEY'

function Get-MerakiOrganizations {

    $api = @{

        endpoint = 'httpsdashboard.meraki.comapiv0'
    
    }

    $header = @{
        
        X-Cisco-Meraki-API-Key = $api_key
        Content-Type = 'applicationjson'
        
    }

    $api.url = 'organizations'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}