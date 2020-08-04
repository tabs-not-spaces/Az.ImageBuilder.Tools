---
external help file: Az.ImageBuilder.Tools-help.xml
Module Name: Az.ImageBuilder.Tools
online version:
schema: 2.0.0
---

# New-AIBResourceGroup

## SYNOPSIS
Creates a resource group if it can't be found. Pretty logical, yeah?

## SYNTAX

```
New-AIBResourceGroup [-ResourceGroupName] <String> [-Location] <String> [-Force] [<CommonParameters>]
```

## DESCRIPTION
Creates a resource group if it can't be found. Pretty logical, yeah?

## EXAMPLES

### Example 1
```powershell
PS C:\> New-AIBResourceGroup -ResourceGroupName "AIBResourceGroup" -Location "eastus" -Force
```

Will create a resource group name "AIBResourceGroup" if not found.

### Example 2
```powershell
PS C:\> New-AIBResourceGroup -ResourceGroupName "AIBResourceGroup" -Location "eastus"
```

Will alert that the resource group named "AIBResourceGroup" already exists, or will alert that it is not found and ask you to use -Force to make it appear as if by magick.

## PARAMETERS

### -Force
Forces it to happen. Like SUDO, but... y'know... less good.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location
Where are you storing this badboy? requires correct location values. You know how to get them.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
