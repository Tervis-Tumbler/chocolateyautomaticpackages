$package_dir="$env:ProgramFiles\Logstash2"

Write-Host "Uninstalling Logstash2"
Remove-Item $package_dir -Recurse -Force