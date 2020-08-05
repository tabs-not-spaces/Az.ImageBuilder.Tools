---
external help file: Az.ImageBuilder.Tools-help.xml
Module Name: Az.ImageBuilder.Tools
online version:
schema: 2.0.0
---

# Get-AIBBuildStatus

## SYNOPSIS
Check on your build status!

## SYNTAX

```
Get-AIBBuildStatus [-AzureContext] <PSAzureContext> [-ResourceGroupName] <String> [-ImageTemplateName] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Check on your build status!

## EXAMPLES

### Example 1
```
PS C:\> Get-AIBBuildStatus -AzureContext (Get-AzContext) -ResourceGroupName "AIBResourceGroup" -ImageTemplateName "HellaCoolTemplate"
```

This will return the build status metadata in JSON format.

## PARAMETERS

### -AzureContext
Everything needs context.
Store your AzureContext here.

```yaml
Type: PSAzureContext
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName
What are we calling the resource group?
Slap it in here.
I'll do the rest.

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

### -ImageTemplateName
Whats the name of the custom template you want to check on?

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
