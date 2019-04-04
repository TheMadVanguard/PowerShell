# Info
#
# Script to report on DHCP Server free IP Addresses.
#
# Version 0.1
# Written by Jay
#
# Change 0.2 by Jay
# Removed the predefinded scope options

#Variables
$Computername = "COMPUTER NAME"
$Scopes = "SCOPE"
$Number = "20"

$FromAddress = "FROM EMAIL"
$ToAddress =  "TO EMAIL"
$MyCreds = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force
$EmailServer = "SMTP Server"
$EmailPort = "SMTP Port"

Foreach($Scope in $Scopes)
    {
    $DHCPScope = Get-DhcpServerv4Scope -ComputerName $Computername -ScopeId $Scope
    $DHCPScopeName = $DHCPScope.Name
    $DHCPFreeIPs = Get-DhcpServerv4FreeIPAddress -ComputerName $Computername -ScopeId $Scope -NumAddress $Number
    $DHCPIPsCount = ($DHCPFreeIPs | Measure-Object).Count
  

    If ($DHCPIPsCount -lt "$Number")
        {
        $DHCPError = "Yes" 
        }
    else
        {
        $DHCPError = "No" 
        }
        If ($DHCPError -eq "Yes")
            {    
            Send-MailMessage -From $FromAddress -To $ToAddress -usessl -Subject "DHCP Error $ComputerName $Scope" -Credential $MyCreds -SmtpServer $EmailServer -Port $EmailPort -body "An error, details are below.

A fault has been reported on $ComputerName

The DHCP Scope - Scope $Scope $DHCPScopeName and there are fewer than $Number IPs free"
            }
    }