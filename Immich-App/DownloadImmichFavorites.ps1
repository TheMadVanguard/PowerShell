<#
.SYNOPSIS
    Downloads all "favorite" assets from an Immich instance via its REST API.

.DESCRIPTION
    You'll be prompted for the Immich URL and API key, then a folder
    browse dialog will open so you can pick where files are saved.

.EXAMPLE
    .\Get-ImmichFavorites.ps1
#>

$ErrorActionPreference = "Stop"

$ImmichUrl = (Read-Host "Immich server URL (e.g. https://immich.example.com)").TrimEnd('/')
$ApiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((Read-Host "Immich API key" -AsSecureString)))

Add-Type -AssemblyName System.Windows.Forms | Out-Null
$owner = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    Description = "Select a folder to save Immich favorites into"
    ShowNewFolderButton = $true
}
if ($dialog.ShowDialog($owner) -ne [System.Windows.Forms.DialogResult]::OK) { Write-Host "No folder selected. Exiting."; return }
$OutputDir = $dialog.SelectedPath
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

$headers = @{ "x-api-key" = $ApiKey; "Accept" = "application/json" }
$assets = New-Object System.Collections.Generic.List[object]
$page = 1
do {
    $response = Invoke-RestMethod -Uri "$ImmichUrl/api/search/metadata" -Method Post -Headers $headers `
        -Body (@{ isFavorite = $true; page = $page; size = 250 } | ConvertTo-Json) -ContentType "application/json"
    $response.assets.items | ForEach-Object { $assets.Add($_) }
    $page = $response.assets.nextPage
} while ($page)

Write-Host "Found $($assets.Count) favorite(s)."
$i = 0
$downloaded = 0
$skipped = 0
foreach ($asset in $assets) {
    $i++
    $filename = if ($asset.originalFileName) { $asset.originalFileName } else { "$($asset.id).bin" }
    $outPath = Join-Path $OutputDir $filename

    if (Test-Path $outPath) {
        $skipped++
        Write-Progress -Activity "Downloading Immich favorites" -Status "Skipping $filename ($i of $($assets.Count)) - already exists" -PercentComplete (($i / $assets.Count) * 100)
        continue
    }

    Write-Progress -Activity "Downloading Immich favorites" -Status "$filename ($i of $($assets.Count))" -PercentComplete (($i / $assets.Count) * 100)
    try { Invoke-WebRequest -Uri "$ImmichUrl/api/assets/$($asset.id)/original" -Headers $headers -OutFile $outPath; $downloaded++ }
    catch { Write-Warning "Failed to download $filename : $_" }
}
Write-Progress -Activity "Downloading Immich favorites" -Completed
Write-Host "Done. Downloaded $downloaded new file(s), skipped $skipped already-downloaded file(s), to '$OutputDir'."
