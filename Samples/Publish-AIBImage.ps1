#region Connect to Azure
Connect-AzAccount
$azContext = Get-AzContext
$subscriptionID = $azContext.Subscription.Id
#endregion

#region Configure variables
$resourceGroupName = 'AzImageBuilderRG'
$location = 'eastus'
$imageTemplateName = 'wvd-20h1-prebuilt'
$sharedGalleryName = 'AIBSIG'
$imageDefinitionName = 'M365MMM'
$runOutputName = 'aibCustomWinManImg02ro' # Image distribution metadata reference name
$runOutputName = 'winClientR01' # This gives you the properties of the managed image on completion.
$imageConfig = @{
    OsState   = 'generalized'
    OsType    = 'Windows'
    Publisher = 'MicrosoftWindowsDesktop'
    Offer     = 'office-365'
    Sku       = '20h1-evd-o365pp'
    Version   = 'latest'
}
## shared image gallery vars

#region Required modules
Install-Module Az.ImageBuilder.Tools
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
    CustomizerName       = 'MountAppShareAndRunInstaller'
    RunElevated          = $true
    scriptUri            = 'https://pwshappstorage.blob.core.windows.net/scripts/AppInstall.ps1'
    sha256Checksum       = 'E51DE5E8E3EFCC94269FB55567A08E4679E07AF57726860D7145278AAE910445'
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
$job = Start-AzImageBuilderTemplate -ResourceGroupName $resourceGroupName -Name $imageTemplateName
# wait for the job status to complete

Get-AIBBuildStatus -AzureContext $azContext -ResourceGroupName $resourceGroupName -ImageTemplateName $imageTemplateName -fullStatus
#endregion


