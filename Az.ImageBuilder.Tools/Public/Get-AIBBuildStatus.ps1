<#
.EXTERNALHELP Az.ImageBuilder.Tools-help.xml
#>
function Get-AIBBuildStatus {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]$AzureContext,

        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string]$ImageTemplateName,

        [Parameter(Mandatory = $false)]
        [switch]$fullStatus
    )
    $accessToken = Get-AzCachedAccessToken -AzureContext $AzureContext
    $managementEp = $AzureContext.Environment.ResourceManagerUrl
    $urlBuildStatus = [System.String]::Format("{0}subscriptions/{1}/resourceGroups/$ResourceGroupName/providers/Microsoft.VirtualMachineImages/imageTemplates/{2}?api-version=2020-02-14", $managementEp, $AzureContext.Subscription.Id, $ImageTemplateName)
    $buildStatusResult = Invoke-WebRequest -Method GET  -Uri $urlBuildStatus -UseBasicParsing -Headers  @{"Authorization" = ("Bearer " + $accessToken) } -ContentType application/json
    $buildJsonStatus = $buildStatusResult.Content | ConvertFrom-Json
    if ($fullStatus) {
        $buildJsonStatus
    }
    else {
        $buildJsonStatus.properties.lastRunStatus
    }
}