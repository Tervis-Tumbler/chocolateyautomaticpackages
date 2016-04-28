$PackageName="Kibana"
$ServiceName="kibana-service"
$PackageDirectory="$(Join-Path "$env:ChocolateyInstall\lib" $PackageName)"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Removing service."
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

Write-Host "Uninstalling $PackageName"
Remove-Item $PackageDirectory -Recurse -Force