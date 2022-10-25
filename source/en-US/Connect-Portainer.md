---
external help file: PSPortainer-help.xml
Module Name: PSPortainer
online version:
schema: 2.0.0
---

# Connect-Portainer

## SYNOPSIS

## SYNTAX

### AccessToken
```
Connect-Portainer -BaseURL <String> [-AccessToken <String>] [-PassThru] [<CommonParameters>]
```

### Credentials
```
Connect-Portainer -BaseURL <String> [-Credential <PSCredential>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Connect to a Portainer instance

## EXAMPLES

### EXAMPLE 1
```
Connect-Portainer -BaseURL 'https://portainer.contoso.com' -AccessToken 'ptr_ABoR54bB1NUc4aNY0F2PhppP1tVDu2Husr3vEbPUsw5='
```

Connect using access token

### EXAMPLE 2
```
Connect-Portainer -BaseURL 'https://portainer.contoso.com' -Credentials (Get-Credential)
```

Connect using username and password

## PARAMETERS

### -BaseURL
Defines the base URL to the portainer instance

-BaseURL 'https://portainer.contoso.com'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
Connects to portainer using a access token.
This AccessToken can be generated from the Portainer Web GUI.

-AccessToken 'ptr_ABoR54bB1NUc4aNY0F2PhppP1tVDu2Husr3vEbPUsw5'

```yaml
Type: String
Parameter Sets: AccessToken
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Connect to portainer using username and password.
Parameter accepts a PSCredentials object

-Credential (Get-Credential)

```yaml
Type: PSCredential
Parameter Sets: Credentials
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
This parameter will cause the function to return a PortainerSession object that can be stored in a variable and referensed with the -Session parameter on most cmdlets.

-PassThru

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
