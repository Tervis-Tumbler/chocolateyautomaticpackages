$ServiceName = 'camunda-bpm-tomcat-service'

if ($Service = Get-Service $ServiceName -ErrorAction SilentlyContinue) {
    Write-Host "Removing service."
    if ($Service.Status -eq "Running") {
        Start-ChocolateyProcessAsAdmin "stop $ServiceName" "sc.exe"
    }
    Start-ChocolateyProcessAsAdmin "delete $ServiceName" "sc.exe"
}