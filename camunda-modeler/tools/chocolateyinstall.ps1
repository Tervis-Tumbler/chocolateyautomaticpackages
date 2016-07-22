$PackageName = '{{PackageName}}'
$PackageVersion = '{{PackageVersion}}'

$DownloadURL = "https://camunda.org/release/$PackageName/$PackageVersion/$PackageName-$PackageVersion-win32-x64.zip"

Install-ChocolateyZipPackage -PackageName $PackageName -UnzipLocation $env:chocolateyPackageFolder -Url $DownloadURL