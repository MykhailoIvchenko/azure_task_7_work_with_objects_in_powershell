$DataFolder = Join-Path -Path $PSScriptRoot -ChildPath "data"
$TargetVmSize = "Standard_B2pts_v2"
$ResultRegions = [System.Collections.Generic.HashSet[string]]::new()
$JsonFiles = Get-ChildItem -Path $DataFolder -Filter *.json -Recurse -File

foreach ($File in $JsonFiles) {
    $RegionName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
    try {
        $Content = Get-Content -Path $File.FullName -Raw | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-Warning "Failed to parse JSON in file $($File.FullName). Skipping..."
        continue
    }
    $Found = $Content | Where-Object { $_.name -eq $TargetVmSize }
    if ($Found) {
        $null = $ResultRegions.Add($RegionName)
    }
}

$ResultFile = Join-Path -Path $PSScriptRoot -ChildPath "result.json"
$ResultArray = $ResultRegions | Sort-Object
$ResultArray | ConvertTo-Json -Depth 5 | Set-Content -Path $ResultFile -Encoding UTF8
