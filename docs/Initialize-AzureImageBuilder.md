---
external help file: Az.ImageBuilder.Tools-help.xml
Module Name: Az.ImageBuilder.Tools
online version:
schema: 2.0.0
---

# Initialize-AzureImageBuilder

## SYNOPSIS
Initializer function that will create a resource group, managed identity and custom role permissions to assist preparing your tenant to use Azure Image Builder (Preview)

## SYNTAX

```
Initialize-AzureImageBuilder [-AzureContext] <PSAzureContext> [-ResourceGroupName] <String>
 [-Location] <String> [[-IdentityName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Initializer function that will create a resource group, managed identity and custom role permissions to assist preparing your tenant to use Azure Image Builder (Preview)

## EXAMPLES

### Example 1
```powershell
PS C:\> Initialize-AzureImageBuilder -AzureContext (Get-AzContext) -ResourceGroupName <ResourceGroupName> -Location <Location> -IdentityName <IdentityName>
```

Will create a resource group if not found in your tenant. Will create a managed identity and associate required custom roles to it.

## PARAMETERS

### -AzureContext
Pipe your Azure context object to the rest of the functions,

```yaml
Type: PSAzureContext
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -IdentityName
Name of the managed identity to be generated.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Azure location that you want the resources to be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Name of the resource group you want to either use (existing) or create if not found.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
