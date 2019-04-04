# Info
#
# This function queries the Meraki VPNs
#
# Version 1.0
# Written by Jay

# Variables
$api_key = 'INSET API KEY'
$OrganizationID = "Enter Organization ID"
$Nerwork_ID = "Enter Network ID"


function Get-MerakiVPN {

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api.url = '/organizations/$OrganizationID/thirdPartyVPNPeers'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiSwitches {

    $header = @{
        
        "X-Cisco-Meraki-API-Key" = $api_key
        "Content-Type" = 'application/json'
        
    }

    $api = @{

        "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
    }

    $api.url = '/networks/$Nerwork_ID/devices'
    $uri = $api.endpoint + $api.url
    $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
    return $request

}

function Get-MerakiSwitchPorts {

    #Useage: Get-MerakiSwitchPorts "SW01"

    param (
    
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $switch_name
    
    )
    
    $switch = Get-MerakiSwitches | where {$_.name -eq $switch_name}

    if ($switch){

        $api = @{

            "endpoint" = 'https://dashboard.meraki.com/api/v0'
    
        }

        $header = @{
        
            "X-Cisco-Meraki-API-Key" = $api_key
            "Content-Type" = 'application/json'
        
        }

        $api.url = "/devices/" + $switch.serial + "/switchPorts"
        $uri = $api.endpoint + $api.url
        $request = Invoke-RestMethod -Method GET -Uri $uri -Headers $header
        return $request
    
    }
    else{

        Write-Host "Switch doesn't exist." -ForegroundColor Red
    
    }

}