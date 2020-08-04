<#
.EXTERNALHELP Az.ImageBuilder.Tools-help.xml
#>
function New-AIBResourceGroup {
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [parameter(Mandatory = $true)]
        [string]$Location,

        [parameter(Mandatory = $false)]
        [switch]$Force
    )
    #region Resource groups
    Write-Host "Resource group $ResourceGroupName`: " -ForegroundColor Cyan -NoNewline
    if (!(Get-AzResourceGroup -Location $Location -Name $ResourceGroupName -ErrorAction SilentlyContinue)) {
        if ($Force) {
            Write-Host "$script:Tick Creating.." -ForegroundColor Green
            New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        }
        else {
            Write-Host "Not found - try again with '-Force' applied" -ForegroundColor Red
        }
    }
    else {
        Write-Host "$script:Tick Found.." -ForegroundColor Green
    }
    #endregion
}