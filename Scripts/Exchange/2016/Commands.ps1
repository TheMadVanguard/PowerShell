# Useful for investigating the Content Index State
Get-MailboxDatabase | Get-MailboxDatabaseCopyStatus | Select Name,*index*
