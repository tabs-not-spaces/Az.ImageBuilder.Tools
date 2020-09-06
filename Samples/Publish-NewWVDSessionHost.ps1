#region Config
$resGrp = "WVD-Hostpool-example"
$hostPoolName = "WVDHostpool"
$galleryImages = Get-AzGalleryImageDefinition -ResourceGroupName "wvd-0365-images" -GalleryName "AIBSIG"
$azureContext = Get-AzContext
$hostPoolRG = Get-AzResourceGroup -Name $resGrp -Location 'eastus'
#endregion
#region generate registration key
$regKey = New-AzWvdRegistrationInfo -ResourceGroupName $resGrp -HostPoolName $hostPoolName -ExpirationTime ([datetime]::Now.AddDays(1))
#endregion
#region create new session hosts
$ap = @{
    artifactsLocation               = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_7-20-2020.zip"
    nestedTemplatesLocation         = "https://catalogartifact.azureedge.net/publicartifacts/Microsoft.Hostpool-ARM-1.0.14-preview/"
    subscription                    = $azureContext.Subscription.Id
    hostpoolName                    = $hostPoolName
    hostpoolToken                   = $regkey.Token
    administratorAccountUsername    = "ben@powers-hell.com"
    administratorAccountPassword    = "supersecretpassword"
    hostpoolResourceGroup           = $resGrp
    hostpoolLocation                = $hostPoolRG.Location
    createAvailabilitySet           = $true
    vmInitialNumber                 = 2
    vmResourceGroup                 = $resGrp
    vmLocation                      = $hostPoolRG.Location
    vmSize                          = "Standard_D2s_v3"
    vmNumberOfInstances             = 10
    vmNamePrefix                    = "TEST"
    vmImageType                     = "CustomImage"
    vmDiskType                      = "StandardSSD_LRS"
    vmUseManagedDisks               = $true
    existingVnetName                = "aadds-vnet"
    existingSubnetName              = "aadds-subnet"
    virtualNetworkResourceGroupName = "AADDS"
    usePublicIP                     = $false
    createNetworkSecurityGroup      = $false
    domain                          = "powers-hell.com"
    apiVersion                      = "2019-12-10-preview"
    vmCustomImageSourceId           = $galleryImages.Id
}
New-AzResourceGroupDeployment -Name "DemoDeployment$(new-guid)" -ResourceGroupName $resGrp -TemplateParameterObject $ap -TemplateFile 'C:\bin\template.json' -DefaultProfile (get-azcontext)
#endregion