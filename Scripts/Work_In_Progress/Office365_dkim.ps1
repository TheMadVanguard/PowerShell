$Domain = ""
New-DkimSigningConfig -DomainName $Domain -Enabled $true
Get-DkimSigningConfig -Identity $Domain | Format-List Selector1CNAME, Selector2CNAME
set-DkimSigningConfig -Identity $Domain -Enabled $true