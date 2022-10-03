# Info
#
# Script to ping a and cnames within a DC
#
# Version 1.0
# Written by Jay

$DNSNames = Get-DnsServerResourceRecord -ZoneName "JayP.io" -computername "JP-DC-001" | Where-Object {$_.RecordType -eq 'A' -or ($_.RecordType -eq 'CName')}
$servers = $DNSNames.hostname 

$collection = $()
foreach ($server in $servers)
{
    $status = @{ "ServerName" = $server; "TimeStamp" = (Get-Date -f s) }
    if (Test-Connection $server -Count 1 -ea 0 -Quiet)
    { 
        $status["Results"] = "Up"
    } 
    else 
    { 
        $status["Results"] = "Down" 
    }
    New-Object -TypeName PSObject -Property $status -OutVariable serverStatus
    $collection += $serverStatus

}

$collection | Sort-Object results | Format-Table -AutoSize -Property Servername,Results
