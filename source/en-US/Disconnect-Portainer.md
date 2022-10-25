---
external help file: PSPortainer-help.xml
Module Name: PSPortainer
online version:
schema: 2.0.0
---

# Disconnect-Portainer

## SYNOPSIS

## SYNTAX

```
Disconnect-Portainer [[-Session] <PortainerSession>] [<CommonParameters>]
```

## DESCRIPTION
Disconnect and cleanup session configuration

## EXAMPLES

### EXAMPLE 1
```
Disconnect-Portainer
```

Disconnect from the default portainer session

### EXAMPLE 2
```
Disconnect-Portainer -Session $Session
```

Disconnect the specified session

## PARAMETERS

### -Session
Defines a PortainerSession object that will be disconnected and cleaned up.

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
