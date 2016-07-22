$PackageName = '{{PackageName}}'
$PackageVersion = '{{PackageVersion}}'

function Set-PathVersion {
    $VersionSplit = $PackageVersion.Split(".")
    if ($VersionSplit[2] -eq "0") {
        $PathVersion = [string]::Join(".",$($VersionSplit[0,1]))
    }
    else {
        $PathVersion = $PackageVersion
    }

    return $PathVersion
}

$PathVersionNumber = Set-PathVersion

$DownloadURL = "https://camunda.org/release/$PackageName/$PathVersionNumber/$PackageName-$PackageVersion-win32-x64.zip"

Install-ChocolateyZipPackage -PackageName $PackageName -UnzipLocation $env:chocolateyPackageFolder -Url $DownloadURL
