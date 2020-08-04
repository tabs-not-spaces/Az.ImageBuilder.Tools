<#
.EXTERNALHELP Az.ImageBuilder.Tools-help.xml
#>
function New-AIBRole {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)]
        [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]$AzureContext,

        [parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [parameter(Mandatory = $true)]
        [object]$ManagedIdentity
    )
    try {
        Write-Host "Generating AIB role definition.. " -ForegroundColor Cyan -NoNewline
        $timeInt = $(Get-Date -UFormat "%s")
        $imageRoleDefName = "Azure Image Builder Image Def$timeInt"
        $aibRoleImageCreationPath = "$env:temp\$($script:AIBRoleTemplate | Split-Path -Leaf)"
        ## Download config
        $roleDefCfg = Get-Content $script:AIBRoleTemplate -Raw | ConvertFrom-Json
        $roleDefCfg.Name = $imageRoleDefName
        $roleDefCfg.AssignableScopes = @("/subscriptions/$($AzureContext.Subscription.Id)/resourceGroups/$ResourceGroupName")
        $roleDefCfg | ConvertTo-Json -Depth 20 | Out-File $aibRoleImageCreationPath -Encoding ascii -Force
        Write-Host "$script:tick" -ForegroundColor Green
        ## Create the  role definition
        Write-Host "Submitting AIB role definition.." -ForegroundColor Cyan -NoNewline
        New-AzRoleDefinition -InputFile  $aibRoleImageCreationPath -ErrorAction Stop | Out-Null
        Write-Host "$script:tick" -ForegroundColor Green
        ## Grant role definition to image builder service principal
        Write-Host "Assigning AIB role to $($ManagedIdentity.Name).." -ForegroundColor Cyan -NoNewline
        New-AzRoleAssignment -ObjectId $ManagedIdentity.PrincipalId -RoleDefinitionName $imageRoleDefName -Scope $roleDefCfg.AssignableScopes[0] -ErrorAction Stop | Out-Null
        Write-Host "$script:tick" -ForegroundColor Green
    }
    catch {
        Write-Host "X" -ForegroundColor Red
        Write-Warning $_.Exception.Message
    }

}