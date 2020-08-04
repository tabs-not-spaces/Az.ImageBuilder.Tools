---
external help file: Az.ImageBuilder.Tools-help.xml
Module Name: Az.ImageBuilder.Tools
online version:
schema: 2.0.0
---

# Invoke-AIBProviderCheck

## SYNOPSIS
Helper function to check for and register relevant Resource Providers and Features to enable Azure Image Builder (Preview) in your Azure tenant.

## SYNTAX

```
Invoke-AIBProviderCheck [-Wait] [<CommonParameters>]
```

## DESCRIPTION
Helper function to check for and register relevant Resource Providers and Features to enable Azure Image Builder (Preview) in your Azure tenant.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-AIBProviderCheck -Wait
```

This will verify the state of all required providers and will register any that are set to "NotRegistered". Using the wait switch will cause the function to re-run every 30 seconds until all registration states are "Registered". This process can take up to 10-15 minutes to complete, so using the wait switch can be helpful.

### Example 2
```powershell
PS C:\> Invoke-AIBProviderCheck
```

This will verify the state of all required providers and will register any that are set to "NotRegistered".

## PARAMETERS

### -AZResourceProviders
For internal use only - this allows the function to consume it's output if the wait switch is used.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Wait
Forces the function to wait until all providers return "registered" for their registration state. Can take a while. Go grab a coffee - take a load off.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
