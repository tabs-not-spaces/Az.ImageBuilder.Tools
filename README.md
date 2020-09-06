# AzureImageBuilder
Azure Image Builder configuration done right(ish).

## What have we got here?

Azure Image Builder is currently in a very rough preview state - there is currently no UI for anything and it requires some preview providers and features to be programmatically lit up in your environment. I've found from personal experience that this kind of stuff is a major road block for people who just want to get in and try out the tools.

This module contains helper functions that should make most of the process to get your environment ready for AIB fairly painless.

Included in this repository is some sample code to show how to use the cmdlets included in the module to prepare your environment for Azure Image Builder (AIB), create a Shared Image Gallery (SIB), publish a custom image and how to use that custom image to provision session hosts for Windows Virtual Desktop (WVD).

Pretty cool, huh?

## How to use the tools

Install the module from the gallery as always..

``` PowerShell
Install-Module Az.ImageBuilder.Tools
```

Once the module is installed, the process to provision your tenant and start creating Images is as follows

- Use <code>Invoke-AIBProviderCheck</code> to verify all providers and features are enabled in your tenant. If they aren't they will be switched on. This can take up to 15 minutes.
- Once all providers and features are lit up, use <code>Initialize-AzureImageBuilder</code> to create the necessary custom roles and managed identities in the resource group of your choice. If the resource group does not exist it will be created for you.
- Once the roles and identities are created, it's just a case of following along with the [excellent](https://wvdcommunity.com/building-master-images-using-azure-image-builder/) [existing](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/image-builder-overview) [documentation](https://www.windowsvirtualdesktop.blog/2020/06/12/windows-virtual-desktop-wvd-image-management-how-to-manage-and-deploy-custom-images-including-versioning-with-the-azure-shared-image-gallery-sig/), as well as using [Publish-AIBImage.ps1](Samples/Publish-AIBImage.ps1) as a starting point to prepare custom images.
- For extra credit, check out [Publish-NewWVDSessionHost.ps1](Samples/Publish-NewWVDSessionHost.ps1) to see how you can utilise the provisioned image templates with WVD.

## Build from source

For those living on the edge, you can build the module from this repository using the [build.ps1](Build.ps1) script. Clone the repo and run the below command from the root directory.

``` PowerShell
.\Build.ps1 -modulePath .\Az.ImageBuilder.Tools -buildLocal
```

This will build out the module to .\bin\release\*versionNumber*\Az.ImageBuilder.Tools

Import from that location and have fun.