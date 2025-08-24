# Write your code here
$DataFolder = Join-Path -Path $PSScriptRoot -ChildPath "data"

$TargetVmSize = "Standard_B2pts_v2"

$ResultRegions = @()

$JsonFiles = Get-ChildItem -Path $DataFolder -Filter *.json

foreach ($File in $JsonFiles) {
    $RegionName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)

    $Content = Get-Content -Path $File.FullName -Raw | ConvertFrom-Json

    $Found = $Content | Where-Object { $_.name -eq $TargetVmSize }

    if ($Found) {
        $ResultRegions += $RegionName
    }
}

$ResultFile = Join-Path -Path $PSScriptRoot -ChildPath "result.json"
$ResultRegions | ConvertTo-Json -Depth 2 | Set-Content -Path $ResultFile -Encoding UTF8