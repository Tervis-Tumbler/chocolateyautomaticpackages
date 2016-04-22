<#
Script modified from Dmitry Kireev's original script.
https://chocolatey.org/packages/logstash-contrib
#>

$PackageName = "logstash-alt"
$PackageDirectory="$env:ProgramFiles\$PackageName"
$PackageVersion = "2.3.1"
$url="http://download.elastic.co/logstash/logstash/logstash-$PackageVersion.tar.gz"

Write-Host "Making sure there are no traces of an old installation. Cleaning up ${PackageDirectory}"

$DoesPackagePathExist = Test-Path $(Join-Path $PackageDirectory "logstash*")

if ($DoesPackagePathExist -eq $true) {
    Get-ChildItem "${PackageDirectory}" | Where-Object {$_.Name -ilike "logstash*"} | Remove-Item -Recurse
    Get-ChildItem "${PackageDirectory}" | Where-Object {$_.Name -ilike "${PackageName}Install*"} | Remove-Item
}
else {
    Write-Host "No old files to remove."
}

Get-ChocolateyWebFile "${PackageName}" $(Join-Path $PackageDirectory "${PackageName}Install.tar.gz") $url $url
Get-ChocolateyUnzip $(Join-Path $PackageDirectory "${PackageName}Install.tar.gz") "${PackageDirectory}"
Get-ChocolateyUnzip $(Join-Path $PackageDirectory "${PackageName}Install.tar") "${PackageDirectory}"
 
Write-Host "Moving files from ${PackageDirectory}\${PackageName}-*\* to ${PackageDirectory}"
 
Copy-Item "${PackageDirectory}\${PackageName}-*\*" "${PackageDirectory}" -Force -Recurse
 
 
Write-Host "Cleaning up temp files & directories created during this install"
Remove-Item "${PackageDirectory}\${PackageName}*" -Recurse -Force
Remove-Item "${PackageDirectory}\${PackageName}Install*" -Recurse -Force