function Get-AzCachedAccessToken {
    <#
    .SYNOPSIS
    Get the Bearer token from the currently set AzContext
    https://gist.github.com/brettmillerb/69c557f269515ea903364948238a41ab
    .DESCRIPTION
    Get the Bearer token from the currently set AzContext. Retrieves from Get-AzContext
    .EXAMPLE
    Get-AzCachedAccesstoken
    .EXAMPLE
    Get-AzCachedAccesstoken -AzureContext $azureContext -Verbose
    #>
    [cmdletbinding()]
    param(
        [parameter(Mandatory = $true)]
        [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]$AzureContext
    )
    $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile)

    Write-Verbose ("Tenant: {0}" -f  $AzureContext.Subscription.Name)

    $token = $profileClient.AcquireAccessToken($AzureContext.Tenant.TenantId)
    $token.AccessToken
}