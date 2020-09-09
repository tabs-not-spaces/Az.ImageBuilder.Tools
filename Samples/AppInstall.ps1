. cmd.exe /add 'pwshappstorage.file.core.windows.net' /user:'Azure\pwshappstorage' /pass:'PploDc80SSHV5NMe87HpYMmVC+SYbZyWvghyGEa+yuR9wNGym+2ieXFxiYt'
New-SmbMapping -LocalPath 'Z:' -RemotePath '\\pwshappstorage.file.core.windows.net\appstore' -Persistent $true
New-Item -Path 'C:\ProgramData\AIBStaging' -ItemType Directory -Force
Copy-Item -Path 'Z:\apps\7zip.msi' -Destination 'C:\ProgramData\AIBStaging\7zip.msi' -Force
#region create staging directory
$stagingDir = "$env:ProgramData\AIBStaging"
if (!(Test-Path $stagingDir -ErrorAction SilentlyContinue)) {
    New-Item -Path $stagingDir -ItemType Directory -Force | Out-Null
}
#endregion

#region Some fancy Teams media settings for WVD
New-Item -Path HKLM:\SOFTWARE\Microsoft\Teams -Force | Out-Null
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Teams -name IsWVDEnvironment -Value "1" -Force | Out-Null
#endregion

#region Download software
$params = @(
    @{
        uri = 'https://aka.ms/vs/16/release/vc_redist.x64.exe'
        outFile = "$stagingDir\vc.exe"
    }
    @{
        uri = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4vkL6'
        outFile = "$stagingDir\websocket.msi"
    }
    @{
        uri = 'https://statics.teams.cdn.office.net/production-windows-x64/1.3.00.4461/Teams_windows_x64.msi'
        outFile = "$stagingDir\teams.msi"
    }
    @{
        uri = 'http://go.microsoft.com/fwlink/?LinkID=2093437'
        outFile = "$stagingDir\EdgeEnt.msi"
    }
)
foreach ($param in $params) {
    Invoke-WebRequest @param -Use
}
#endregion
#region Install all the things
Start-Process -FilePath "$stagingDir\vs.exe" -ArgumentList "/quiet" -Wait 
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\websocket.msi`" /qn" -Wait
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\\Teams.msi`" /quiet /l*v C`"$stagingDir\teamsinstall.log`" ALLUSER=1 ALLUSERS=1" -Wait
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\EdgeEnt.msi`" /qn" -Wait
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\7zip.msi`" /qn" -Wait
#endregion