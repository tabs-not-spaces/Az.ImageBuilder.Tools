function Initialize-AzureImageBuilder {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true, ValueFromPipeline)]
        [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]$AzureContext,

        [parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [parameter(Mandatory = $true)]
        [string]$Location,

        [parameter(Mandatory = $false)]
        [string]$IdentityName = "aibIdentity"
    )
    try {
        #region Set up resource group if missing
        Write-Host "Creating resource group.." -ForegroundColor Yellow
        New-AIBResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location -Force | Out-Null
        #endregion

        #region Create managed identity
        Write-Host "Creating managed identity.." -ForegroundColor Yellow
        $managedIdentity = New-AIBManagedIdentity -ResourceGroupName $ResourceGroupName -IdentityName $IdentityName
        #endregion

        #region Create role and assign to managed identity
        Write-Host "Creating AIB Roles & assigning to managed identity.." -ForegroundColor Yellow
        New-AIBRole -AzureContext $AzureContext -ResourceGroupName $ResourceGroupName -ManagedIdentity $managedIdentity
        #endregion

        #region return $managedIdentity back to user
        if ($managedIdentity) {
            return $managedIdentity
        }
        else {
            throw "Failure generating managed identity"
        }
        #endregion

    }
    catch {
        Write-Warning $_.Exception.Message
    }
}