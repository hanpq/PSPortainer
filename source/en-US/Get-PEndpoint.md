---
external help file: PSPortainer-help.xml
Module Name: PSPortainer
online version:
schema: 2.0.0
---

# Get-PEndpoint

## SYNOPSIS

## SYNTAX

### List (Default)
```
Get-PEndpoint [-Session <PortainerSession>] [<CommonParameters>]
```

### Search
```
Get-PEndpoint [-SearchString <String>] [-Session <PortainerSession>] [<CommonParameters>]
```

### Id
```
Get-PEndpoint [-Id <Int32>] [-Session <PortainerSession>] [<CommonParameters>]
```

## DESCRIPTION
Retreives endpoints

## EXAMPLES

### EXAMPLE 1
```
Get-PEndpoint -SearchString 'local'
```

Retreives all endpoints containing the word local

## PARAMETERS

### -SearchString
Defines a searchstring to use for filtering endpoints

```yaml
Type: String
Parameter Sets: Search
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Defines the Id of the endpoint to retreive.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
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
