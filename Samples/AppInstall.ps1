Write-Host "Adding credentials for storage account.."
. cmdkey /add 'pwshappstorage.file.core.windows.net' /user:'Azure\pwshappstorage' /pass:'PploDc80SSHV5NMe87HpYMmVC+SYbZyWvghyGEa+yuR9wNGym+2ieXFxiYtTO/SChpn+fb9hiEQ0sBkFPRdwcg=='
New-SmbMapping -LocalPath 'Z:' -RemotePath '\\pwshappstorage.file.core.windows.net\appstore' -Persistent $true
Write-Host "Creating staging directory"
New-Item -Path 'C:\ProgramData\AIBStaging' -ItemType Directory -Force
Write-Host "Copying media"
Copy-Item -Path 'Z:\apps\7zip.msi' -Destination 'C:\ProgramData\AIBStaging\7zip.msi' -Force
$stagingDir = "C:\ProgramData\AIBStaging"

#region Some fancy Teams media settings for WVD
Write-Host "Apply teams registry keys"
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
    Write-Host "downloading installation media from $($param.uri)"
    Invoke-WebRequest @param
}
#endregion
#region Install all the things
Write-Host "Installing vs runtimes.."
Start-Process -FilePath "$stagingDir\vc.exe" -ArgumentList "/quiet" -Wait 
Write-Host "Installing websocket.."
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\websocket.msi`" /qn" -Wait
Write-Host "Installing teams.."
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\\Teams.msi`" /quiet /l*v C`"$stagingDir\teamsinstall.log`" ALLUSER=1 ALLUSERS=1" -Wait
Write-Host "Installing edge.."
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\EdgeEnt.msi`" /qn" -Wait
Write-Host "Installing 7zip.."
Start-Process -FilePath msiexec -ArgumentList "/i `"$stagingDir\7zip.msi`" /qn" -Wait
#endregion