---
external help file: Az.ImageBuilder.Tools-help.xml
Module Name: Az.ImageBuilder.Tools
online version:
schema: 2.0.0
---

# New-AIBManagedIdentity

## SYNOPSIS
Creates a managed identity in the resource group specified.

## SYNTAX

```
New-AIBManagedIdentity [-ResourceGroupName] <String> [[-IdentityName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Creates a managed identity in the resource group specified.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-AIBManagedIdentity -ResourceGroupName AIBResourceGroup -IdentityName 'managedIdentity'
```

Creates a managed identity object named "managedIdentity" in the resource group named AIBResourceGroup

### Example 1
```powershell
PS C:\> New-AIBManagedIdentity -ResourceGroupName AIBResourceGroup
```

Creates a managed identity object named "aibIdentity" in the resource group named AIBResourceGroup

## PARAMETERS

### -IdentityName
Name of the managed identity. Leave it out, it defaults to "aibIdentity"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
Name of the resource group to store the managed identity.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
