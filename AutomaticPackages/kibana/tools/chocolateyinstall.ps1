<#
Script modified from Dmitry Kireev's original script.
https://chocolatey.org/packages/logstash-contrib
#>


$PackageName = '{{PackageName}}'
$PackageVersion = '{{PackageVersion}}'
$ServiceName = 'kibana-service'
$PackageDirectory="$env:ChocolateyInstall\lib\$PackageName"
$DownloadURL = "http://download.elastic.co/$PackageName/$PackageName/$PackageName-$PackageVersion-windows.zip"

Write-Host "Making sure there are no traces of an old installation. Cleaning up $PackageDirectory."

$DoesPackagePathExist = Test-Path $(Join-Path $PackageDirectory "$PackageName*")

if ($DoesPackagePathExist -eq $true) {
    Get-ChildItem "${PackageDirectory}" | Where-Object {$_.Name -ilike "$PackageName*"} | Remove-Item -Recurse
    Get-ChildItem "${PackageDirectory}" | Where-Object {$_.Name -ilike "${PackageName}Install*"} | Remove-Item
}
else {
    Write-Host "No old files to remove."
}

Get-ChocolateyWebFile "${PackageName}" $(Join-Path $PackageDirectory "${PackageName}Install.zip") $DownloadURL $DownloadURL
Get-ChocolateyUnzip $(Join-Path $PackageDirectory "${PackageName}Install.zip") "${PackageDirectory}"
 
Write-Host "Moving files from ${PackageDirectory}\${PackageName}-*\* to ${PackageDirectory}"
 
Copy-Item "${PackageDirectory}\${PackageName}-*\*" "${PackageDirectory}" -Force -Recurse 
 
Write-Host "Cleaning up temp files & directories created during this install"
Remove-Item "${PackageDirectory}\${PackageName}*" -Recurse -Force
Remove-Item "${PackageDirectory}\${PackageName}Install*" -Recurse -Force

Write-Host "Installing service"

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}

Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $PackageDirectory "bin\kibana.bat")" nssm
Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm