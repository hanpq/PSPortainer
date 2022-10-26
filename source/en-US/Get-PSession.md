---
external help file: PSPortainer-help.xml
Module Name: PSPortainer
online version:
schema: 2.0.0
---

# Get-PSession

## SYNOPSIS

## SYNTAX

```
Get-PSession [[-Session] <PortainerSession>] [<CommonParameters>]
```

## DESCRIPTION
Displays the Portainer Session object.

## EXAMPLES

### EXAMPLE 1
```
Get-PSession
```

Returns the PortainerSession, if none is specified, it tries to retreive the default

## PARAMETERS

### -Session
Optionally define a portainer session object to use.
This is useful when you are connected to more than one portainer instance.

-Session $Session

```yaml
Type: PortainerSession
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
