# Info
#
# This PowerShell script will query the server and return all disk space excluding the Floppy and CD/DVD drive (A:/D:/)
# if the space is below a certain threshold it will send a customised email alert.
#
# Version 1.0
# Written by Jay

#Variables
$DrivesSizeinGB = "Size in GB"
$Computer = hostname
$ComputerName = $Computer

# Email Variables
$SecPassword = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force
$MyCreds = New-Object System.Management.Automation.PSCredential ("EMAIL LOGIN", $SecPassword)
$SmtpServer = "EMAIL SERVER ADDRESS"
$Port = "PORT"
$Subject = "Error Report $ComputerName"
$From = "FROM ADDRESS"
$To = "TO ADDRESS"
$Priority = "High"

        $Disks = Get-WmiObject Win32_LogicalDisk -ErrorAction SilentlyContinue | Select-Object PSComputerName,deviceid,Size,FreeSpace 
        
        foreach ($Disk in $Disks | Where-Object {$_.DeviceID -ne "A:" -and $_.DeviceID -ne "D:"})
                {
                $DiskLetter = $Disk.DeviceID
                $DiskSize = [math]::round(($Disk.Size)/1gb)
                $DiskFreeSize = [math]::round(($Disk.FreeSpace)/1gb) 

                If ($DiskFreeSize -lt "$DrivesSizeinGB")
                    {
                    $DiskSpaceError = "1"
                    }
                If ($DiskSpaceError -eq 1)
                    {    
                    Send-MailMessage -From $From -To $To -usessl -Subject $Subject -Credential $MyCreds -SmtpServer $SmtpServer -Port $Port -Priority $Priority -body "An error has occurred, details are below.

A fault has been reported on, $ComputerName

The Disk Space Check - Drive $DiskLetter Failed.

Additional information : Total: $DiskSize GB, Free: $DiskFreeSize GB"
                    }
                $DiskSpaceError ="0"
                }