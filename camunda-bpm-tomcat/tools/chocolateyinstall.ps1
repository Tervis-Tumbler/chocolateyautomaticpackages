$PackageName = '{{PackageName}}'
$PackageVersion = '{{PackageVersion}}'

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

    Start-ChocolateyProcessAsAdmin "install $ServiceName $(Join-Path $env:chocolateyPackageFolder "server\apache-tomcat-8.0.24\bin\catalina.bat")" nssm
    Start-ChocolateyProcessAsAdmin "set $ServiceName AppDirectory $(Join-Path $env:chocolateyPackageFolder "server\apache-tomcat-8.0.24\bin")" nssm
    Start-ChocolateyProcessAsAdmin "set $ServiceName Start SERVICE_DEMAND_START" nssm
    Start-ChocolateyProcessAsAdmin "set $ServiceName DisplayName `"Camunda BPM Tomcat`"" nssm
    Start-ChocolateyProcessAsAdmin "set $ServiceName Description `"Camunda BPM Tomcat server`"" nssm
    Start-ChocolateyProcessAsAdmin "set $ServiceName AppParameters run" nssm
    Start-ChocolateyProcessAsAdmin "set $ServiceName AppEnvironmentExtra CATALINA_HOME=%ChocolateyInstall%\lib\camunda-bpm-tomcat\server\apache-tomcat-8.0.24" nssm

}

$PathVersionNumber = Set-PathVersion

$DownloadURL = "https://camunda.org/release/camunda-bpm/tomcat/$PathVersionNumber/$PackageName-$PackageVersion.zip"

Install-ChocolateyZipPackage -PackageName $PackageName -UnzipLocation $env:chocolateyPackageFolder -Url $DownloadURL

Install-CamundaBPMTomcatService