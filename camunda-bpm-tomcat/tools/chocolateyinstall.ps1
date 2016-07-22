<#


$PackageName = '{{PackageName}}'
$PackageVersion = '{{PackageVersion}}'

# Replace below with above for automatic packages

#>


$PackageName = 'camunda-bpm-tomcat'
$PackageVersion = '7.5.0'
$ServiceName = 'camunda-bpm-tomcat-service'


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

function Install-CamundaBPMTomcatService {
    Write-Host "Installing service"

    if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
        if ($Service.Status -eq "Running") {
            Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
        }
        Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
    }

    Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "start-camunda.bat")" nssm
    Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
}

$PathVersionNumber = Set-PathVersion

$DownloadURL = "https://camunda.org/release/camunda-bpm/tomcat/$PathVersionNumber/$PackageName-$PackageVersion.zip"

Install-ChocolateyZipPackage -PackageName $PackageName -UnzipLocation $env:chocolateyPackageFolder -Url $DownloadURL

# Install-CamundaBPMTomcatService # Service installer not working yet. May be due to lack of Java installation and environment variable.