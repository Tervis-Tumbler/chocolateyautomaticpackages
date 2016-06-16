$PackageName = '{{PackageName}}'
$PackageVersion = '{{PackageVersion}}'
$ServiceName = 'kibana-service'
$PackageDirectory = $env:chocolateyPackageFolder
$DownloadURL = "http://download.elastic.co/$PackageName/$PackageName/$PackageName-$PackageVersion-windows.zip"

Install-ChocolateyZipPackage -PackageName $PackageName -UnzipLocation $PackageDirectory -Url $DownloadURL

Write-Host "Installing service"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $PackageDirectory "bin\kibana.bat")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm