# Info
# This PowerShell script will query Active Directory and return the computer accounts which have not logged for the past
# 90 days. 
# The last part of this script will query Active Directory and remove computer accounts which have not logged for the past
# 120 days.
# Version 1.0
# Written by Jay

#Variables
$Searchbase = "DC=domain,DC=com"
$InactiveOU = "OU=test,DC=domain,DC=com"
$Then = (Get-Date).AddDays(-90) # The This will identify any computer older than 90 and disable it.
$Thenremove = (Get-Date).AddDays(-120) # This will remove any computer account older than 120 days.
$Computers = Get-ADComputer -Properties * -Filter {LastLogonDate -lt $then} -SearchBase $searchbase
$DisabledComps = Get-ADComputer -Properties Name,Enabled,LastLogonDate -Filter {(Enabled -eq "False" -and LastLogonDate -lt $then)} -SearchBase $inactiveOU

#Email Variables
$EmailAccount ="Email Account"
$Creds = Get-Credential $EmailAccount
$From = "From Address"
$To = "To Address"
$Attachment = "C:\Temp\Inactive Computer Accounts.CSV"
$Subject = "Please see the Inactive Computer Accounts Report"
$SMTPServer = "Email Server"
$smtpPort = "Port"

Get-ADComputer -Filter {lastLogonDate -lt $then} -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName | Export-CSV "C:\Temp\Inactive Computer Accounts.CSV" -NoTypeInformation

# Move inactive computer accounts to your inactive OU
foreach ($computer in $computers) {	
	Set-ADComputer $computer -Location $computer.LastLogonDate | Set-ADComputer $computer -Enabled $false 
	Move-ADObject -Identity $computer.ObjectGUID -TargetPath $inactiveOU
	}

# If you would like to Disable these computer accounts, uncomment the following line:
# Get-ADComputer -Property Name,lastLogonDate -Filter {lastLogonDate -lt $then} | Set-ADComputer -Enabled $false

# If you would like to Remove these computer accounts, uncomment the following line:
# Get-ADComputer -Filter {passwordlastset -lt $thenremove} -Properties passwordlastset | Remove-ADObject -Recursive -Verbose -Confirm:$false

Send-MailMessage -UseSsl -From $From -to $To -Subject $Subject -SmtpServer $SMTPServer -Port $smtpPort -Attachments $Attachment -Credential $cred