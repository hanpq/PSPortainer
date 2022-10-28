---
external help file: PSPortainer-help.xml
Module Name: PSPortainer
online version:
schema: 2.0.0
---

# Restart-PContainer

## SYNOPSIS

## SYNTAX

```
Restart-PContainer [[-Endpoint] <String>] [[-Id] <Object[]>] [[-Session] <PortainerSession>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Restart container

## EXAMPLES

### EXAMPLE 1
```
Restart-PContainer
Description of example
```

## PARAMETERS

### -Endpoint
Defines the portainer endpoint to use when retreiving containers.
If not specified the portainer sessions default docker endpoint value is used.

Use Get-PSession to see what endpoint is selected

Use Select-PEndpoint to change the default docker endpoint in the portainer session.

-Endpoint 'local'

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

### -Id
Defines the id of the container to retreive.

-Id '\<Id\>'

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
