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
Retreive endpoints

## EXAMPLES

### EXAMPLE 1
```
Get-PEndpoint
Description of example
```

## PARAMETERS

### -SearchString
{{ Fill SearchString Description }}

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
{{ Fill Id Description }}

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
Does not work for some reason, regardless of input to the API parameter name, all endpoints are returned...
\[Parameter(ParameterSetName = 'Name')\]\[string\]$Name

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
