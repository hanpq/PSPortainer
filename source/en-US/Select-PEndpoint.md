---
external help file: PSPortainer-help.xml
Module Name: PSPortainer
online version:
schema: 2.0.0
---

# Select-PEndpoint

## SYNOPSIS

## SYNTAX

```
Select-PEndpoint [[-Endpoint] <String>] [[-Session] <PortainerSession>] [<CommonParameters>]
```

## DESCRIPTION
Configures the default endpoint to use

## EXAMPLES

### EXAMPLE 1
```
Select-PEndpoint -Endpoint 'prod'
```

Set the default endpoint to use

## PARAMETERS

### -Endpoint
Defines the endpoint name to select

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

### -Session
Optionally define a portainer session object to use.
This is useful when you are connected to more than one portainer instance.

-Session $Session

```yaml
Type: PortainerSession
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
