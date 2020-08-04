<#
.EXTERNALHELP Az.ImageBuilder.Tools-help.xml
#>
Function Invoke-AIBProviderCheck {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $false, DontShow)]
        [array]$AZResourceProviders,

        [parameter(Mandatory = $false)]
        [switch]$Wait
    )
    if (!($AZResourceProviders)) {
        $azResourceProviders = @(
            [pscustomobject]@{
                Name  = "Microsoft.VirtualMachineImages"
                State = $null
                Type  = "ResourceProvider"
            }
            [pscustomobject]@{
                Name  = "Microsoft.Storage"
                State = $null
                Type  = "ResourceProvider"
            }
            [pscustomobject]@{
                Name  = "Microsoft.Compute"
                State = $null
                Type  = "ResourceProvider"
            }
            [pscustomobject]@{
                Name  = "Microsoft.KeyVault"
                State = $null
                Type  = "ResourceProvider"
            }
            [pscustomobject]@{
                Name        = "Microsoft.VirtualMachineImages"
                State       = "NotRegistered"
                Type        = "ProviderFeature"
                FeatureName = "VirtualMachineTemplatePreview"
            }
        )
    }
    do {
        foreach ($az in $($azResourceProviders | Where-Object { $_.State -ne "Registered" })) {
            switch ($az.Type) {
                "ProviderFeature" {
                    $reg = Get-AzProviderFeature -ProviderNamespace $az.Name -FeatureName $az.FeatureName
                }
                "ResourceProvider" {
                    $reg = Get-AzResourceProvider -ProviderNamespace $az.Name
                }
            }
            switch ($reg.RegistrationState) {
                "NotRegistered" {
                    switch ($az.Type) {
                        "ProviderFeature" {
                            Register-AzProviderFeature -ProviderNamespace $az.Name -FeatureName $az.FeatureName
                        }
                        "ResourceProvider" {
                            Register-AzResourceProvider -ProviderNamespace $az.Name
                        }
                    }
                }
                "Registering" {
                    $az.State = "Registering"
                }
                "Registered" {
                    $az.State = "Registered"
                }
            }
            if ($az.State -ne "NotRegistered") {
                $az | Select-Object Name, State
            }
        }
    }
    until ($azResourceProviders.State -notcontains "NotRegistered")
    if ($azResourceProviders.State -contains "Registering") {
        if ($Wait) {
            (1..30) | ForEach-Object {
                Write-Progress -Activity "Sleeping before we check again" -PercentComplete $($_/30*100)
                Start-Sleep -Seconds 1
            }
            Invoke-AIBProviderCheck -AZResourceProviders $AZResourceProviders -Wait
        }
        else {
            Write-Host "Resources are still registering - check back again in 5-10 minutes..." -ForegroundColor Green
        }
    }
}