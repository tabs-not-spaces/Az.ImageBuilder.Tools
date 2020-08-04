---
external help file: Az.ImageBuilder.Tools-help.xml
Module Name: Az.ImageBuilder.Tools
online version:
schema: 2.0.0
---

# New-AIBRole

## SYNOPSIS
Creates the necessary custom roles to use Azure Image Builder in its current "Public Preview" state.

## SYNTAX
```
New-AIBRole [-AzureContext] <Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext> [-ResourceGroupName] <String> [-ManagedIdentity] <Object> [<CommonParameters>]
```

## DESCRIPTION
Creates the necessary custom roles to use Azure Image Builder in its current "Public Preview" state.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-AIBRole -AzureContext (Get-AzContext) -ResourceGroupName "AIBResourceGroup" -ManagedIdentity $ManagedIdentity
```

This will create the custom roles in the resource group named "AIBResourceGroup" and apply them to the managed identity created by using "New-AIBManagedIdentity".

## PARAMETERS

### -AzureContext
Everything needs context. Store your AzureContext here.

```yaml
Type: Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
What are we calling the resource group? Slap it in here. I'll do the rest.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ManagedIdentity
Custom object generated from the "New-AIBManagedIdentity" function in this module.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
