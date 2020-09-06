#region Connect to Azure
Connect-AzAccount
$azContext = Get-AzContext
$subscriptionID = $azContext.Subscription.Id
#endregion

#region Configure variables
$resourceGroupName      = 'wvd-o365-images'
$location               = 'eastus'
$imageTemplateName      = 'wvd-20h1-test'
$sharedGalleryName      = 'AIBSIG'
$imageDefinitionName    = 'win0365'
$runOutputName          = 'aibCustomWinManImg02ro' # Image distribution metadata reference name
$runOutputName          = 'winClientR01' # This gives you the properties of the managed image on completion.
$imageConfig = @{
    OsState             = 'generalized'
    OsType              = 'Windows'
    Publisher           = 'MicrosoftWindowsDesktop'
    Offer               = 'office-365'
    Sku                 = '20h1-evd-o365pp'
    Version             = 'latest'
}
## shared image gallery vars

#region Required modules
Import-Module Az.ImageBuilder.Tools
'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object {
    Install-Module -Name $_ -AllowPrerelease
}
#endregion

#region Resource Group / Managed Identify config
$mIDParams = @{
    AzureContext      = $azContext
    ResourceGroupName = $resourceGroupName
    Location          = $location
    IdentityName      = 'aibIdentity'
}
$managedIdentity = Initialize-AzureImageBuilder @mIDParams
#endregion

#region Create the shared image gallery (SIG)
$azGalleryParams = @{
    Name              = $sharedGalleryName
    ResourceGroupName = $resourceGroupName
    Location          = $location
}
New-AzGallery @azGalleryParams
#endregion

#region Build source object
$srcObjParams = @{
    SourceTypePlatformImage = $true
    Publisher               = $imageConfig.Publisher
    Offer                   = $imageConfig.Offer
    Sku                     = $imageConfig.Sku
    Version                 = $imageConfig.Version
}
$srcPlatform = New-AzImageBuilderSourceObject @srcObjParams
#endregion

#region Create the image definition
$imageDefParams = @{
    GalleryName       = $sharedGalleryName
    ResourceGroupName = $resourceGroupName
    Location          = $location
    Name              = $imageDefinitionName
    OsState           = $imageconfig.OsState
    OsType            = $imageConfig.OsType
    Publisher         = ([mailaddress]$azContext.account.id).Host
    Offer             = $imageConfig.Offer
    Sku               = $imageConfig.Sku
}
New-AzGalleryImageDefinition @imageDefParams
#endregion

#region Build distribution object
$distObjParams = @{
    SharedImageDistributor = $true
    ArtifactTag            = @{ tag = 'dis-share' }
    GalleryImageId         = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroupName/providers/Microsoft.Compute/galleries/$sharedGalleryName/images/$imageDefinitionName"
    ReplicationRegion      = $location
    RunOutputName          = $runOutputName
    ExcludeFromLatest      = $false
}
$disSharedImg = New-AzImageBuilderDistributorObject @distObjParams
#endregion

#region Build customization object
$imgCustomParams = @{
    PowerShellCustomizer = $true
    CustomizerName       = 'settingUpMgmtAgtPath'
    RunElevated          = $false
    Inline               = @("mkdir c:\\buildActions", "echo Azure-Image-Builder-Was-Here  > c:\\buildActions\\buildActionsOutput.txt")
}
$customizer = New-AzImageBuilderCustomizerObject @imgCustomParams
#endregion

#region Create AIB Template
$imgTemplateParams = @{
    ImageTemplateName      = $imageTemplateName
    ResourceGroupName      = $resourceGroupName
    Source                 = $srcPlatform
    Distribute             = $disSharedImg
    Customize              = $customizer
    Location               = $location
    UserAssignedIdentityId = $managedIdentity.ResourceId
}
New-AzImageBuilderTemplate @ImgTemplateParams
#endregion

#region Start image build
$job = Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName -AsJob
$job
#endregion