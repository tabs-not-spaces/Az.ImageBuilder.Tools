#region Connect to Azure
Connect-AzAccount
$azContext = Get-AzContext
$subscriptionID = $azContext.Subscription.Id
#endregion

#region Configure variables
$imageResourceGroup = 'wvd-goldimage-test'
$location = 'eastus'
$imageTemplateName = 'wvd-20h1-test'
$sharedGalleryName = 'AIBSIG'
$imageDefinitionName = 'win10imageAppsTeams'
$runOutputName = 'aibCustWinManImg02ro' # Image distribution metadata reference name
$runOutputName = 'winClientR01' # This gives you the properties of the managed image on completion.
$imageConfig = @{
    OsState   = 'generalized'
    OsType    = 'Windows'
    Publisher = 'MicrosoftWindowsDesktop'
    Offer     = 'Windows-10'
    Sku       = '20h1-evd'
    Version   = 'latest'
}
## shared image gallery vars

#region Required modules
'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object {
    Install-Module -Name $_ -AllowPrerelease
}
#endregion

#region Resource Group / Managed Identify config
$managedIdentity = Initialize-AzureImageBuilder -AzureContext $azContext -ResourceGroupName $imageResourceGroup -IdentityName "aibIdentity"
#endregion

#region Create the shared image gallery (SIG)
$azGalleryParams = @{
    Name              = $sharedGalleryName
    ResourceGroupName = $imageResourceGroup
    Location          = $location
}
New-AzGallery @azGalleryParams
#endregion

#region Create the image definition
$azGalleryImageDefs = @{
    GalleryName       = $sharedGalleryName
    ResourceGroupName = $imageResourceGroup
    Location          = $location
    Name              = $imageDefinitionName
    OsState           = 'generalized'
    OsType            = 'Windows'
    Publisher         = ([mailaddress]$azContext.account.id).Host
    Offer             = 'Windows-10-App-Teams'
    Sku               = '20h1-evd'
}
New-AzGalleryImageDefinition @azGalleryImageDefs
#endregion

#region Build source object
$srcObjParams = @{
    SourceTypePlatformImage = $true
    Publisher               = 'MicrosoftWindowsDesktop'
    Offer                   = 'Windows-10'
    Sku                     = '20h1-evd'
    Version                 = 'latest'
}
$srcPlatform = New-AzImageBuilderSourceObject @srcObjParams
#endregion

#region Build distribution object
$disObjParams = @{
    SharedImageDistributor = $true
    ArtifactTag            = @{ tag = 'dis-share' }
    GalleryImageId         = "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup/providers/Microsoft.Compute/galleries/$sharedGalleryName/images/$imageDefinitionName"
    ReplicationRegion      = $location
    RunOutputName          = $runOutputName
    ExcludeFromLatest      = $false
}
$disSharedImg = New-AzImageBuilderDistributorObject @disObjParams
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
    ResourceGroupName      = $imageResourceGroup
    Source                 = $srcPlatform
    Distribute             = $disSharedImg
    Customize              = $customizer
    Location               = $location
    UserAssignedIdentityId = $managedIdentity.ResourceId
}
New-AzImageBuilderTemplate @ImgTemplateParams
#endregion

#region Start image build
Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName
#endregion