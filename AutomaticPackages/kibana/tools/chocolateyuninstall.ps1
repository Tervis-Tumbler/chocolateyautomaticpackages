$package_name="Kibana"
$package_dir="$env:ProgramFiles\$package_name"

Write-Host "Uninstalling $package_name"
Remove-Item $package_dir -Recurse -Force