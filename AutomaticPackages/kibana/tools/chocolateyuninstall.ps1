$PackageName="Kibana"
$PackageDirectory="$(Join-Path "$env:ChocolateyInstall\lib" $PackageName)"

Write-Host "Uninstalling $PackageName"
Remove-Item $PackageDirectory -Recurse -Force