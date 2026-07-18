$ImmichUrl = "https://WEB_SERVER_URL/api"
$ApiKey    = "API_KEY"
$DownloadDir = "C:\Immich-Favorites"

New-Item -ItemType Directory -Path $DownloadDir -Force | Out-Null

$headers = @{ "x-api-key" = $ApiKey; "Content-Type" = "application/json" }
$body = @{ isFavorite = $true; type = "IMAGE"; page = 1; size = 1000 } | ConvertTo-Json

$favorites = (Invoke-RestMethod -Uri "$ImmichUrl/search/metadata" -Method Post -Headers $headers -Body $body).assets.items

Write-Host "Found $($favorites.Count) favorites, downloading..."

foreach ($asset in $favorites) {
    $outFile = Join-Path $DownloadDir $asset.originalFileName
    Invoke-WebRequest -Uri "$ImmichUrl/assets/$($asset.id)/original" -Headers @{ "x-api-key" = $ApiKey } -OutFile $outFile
}

Write-Host "Done. Files saved to $DownloadDir"
