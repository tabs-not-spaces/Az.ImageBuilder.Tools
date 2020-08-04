<#
.EXTERNALHELP Az.ImageBuilder.Tools-help.xml
#>
function New-AIBManagedIdentity {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [parameter(Mandatory = $false)]
        [string]$IdentityName = "aibIdentity"

    )
    try {
        #region Create user assigned identity
        Write-Host "Managed identity $IdentityName`: " -ForegroundColor Cyan -NoNewline
        if ( !(Get-AzUserAssignedIdentity -ResourceGroupName $ResourceGroupName -Name $IdentityName -ErrorAction SilentlyContinue)) {
            Write-Host "$script:tick Creating.." -ForegroundColor Green
            New-AzUserAssignedIdentity -ResourceGroupName $ResourceGroupName -Name $IdentityName
        }
        else {
            Write-Host "$script:tick Found.." -ForegroundColor Green
        }
        $identity = Get-AzUserAssignedIdentity -ResourceGroupName $ResourceGroupName -Name $IdentityName
        $res = [PSCustomObject]@{
            Name = $IdentityName
            ResourceId  = $identity.Id
            PrincipalID = $identity.PrincipalId
        }
        Write-Host
        return $res
        #endregion
    }
    catch {
        Write-Warning $_.Exception.Message
    }
}