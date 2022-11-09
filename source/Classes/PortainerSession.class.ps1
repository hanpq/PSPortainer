<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "c0ed732e-d178-4e31-8969-c7ec01b70089",
  "FILENAME": "PortainerSession.class.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": "GetPS",
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'JWT token retreived in plain text')]
class PortainerSession
{
    [string]$BaseUri
    [string]$AuthMethod
    [securestring]$AccessToken
    [pscredential]$Credential
    [securestring]$JWT
    [string]$APIUri
    [string]$InstanceID
    [string]$PortainerVersion
    [string]$DefaultDockerEndpoint
    [string]$SessionID

    PortainerSession ([string]$BaseUri, [securestring]$AccessToken)
    {
        Write-Debug -Message 'PortainerSession.Class; Running constructor accesstoken'
        $this.SessionID = (New-Guid).Guid
        $this.BaseUri = $BaseUri
        $this.APIUri = "$BaseUri/api"
        $this.AuthMethod = 'AccessToken'
        $this.AccessToken = $AccessToken
        $this.GetStatus()
        $this.ResolveDockerEndpoint()
        Write-Verbose -Message "Connected to portainer instance at $($this.BaseUri) with AccessToken"
    }

    PortainerSession ([string]$BaseUri, [pscredential]$Credential)
    {
        Write-Debug -Message 'PortainerSession.Class; Running constructor credential'
        $this.SessionID = (New-Guid).Guid
        $this.BaseUri = $BaseUri
        $this.APIUri = "$BaseUri/api"
        $this.AuthMethod = 'Credential'
        $this.Credential = $Credential
        $this.AuthenticateCredential()
        $this.GetStatus()
        $this.ResolveDockerEndpoint()
        Write-Verbose -Message "Connected to portainer instance at $($this.BaseUri) with Credentials"
    }

    hidden ResolveDockerEndpoint ()
    {
        [array]$AllEndpoints = InvokePortainerRestMethod -Method Get -RelativePath '/endpoints' -PortainerSession $this
        if ($AllEndpoints.Count -eq 1)
        {
            $this.DefaultDockerEndpoint = $AllEndpoints[0].Name
        }
    }

    hidden AuthenticateCredential()
    {
        $JWTResponse = InvokePortainerRestMethod -NoAuth -Method:'Post' -PortainerSession $this -RelativePath '/auth' -Body @{password = $this.Credential.GetNetworkCredential().Password; username = $this.Credential.Username }
        $this.JWT = ConvertTo-SecureString -String $JWTResponse.JWT -AsPlainText -Force
        Remove-Variable -Name JWTResponse
    }

    hidden GetStatus()
    {
        $Status = InvokePortainerRestMethod -NoAuth -Method:'Get' -PortainerSession $this -RelativePath '/status'
        $this.PortainerVersion = $Status.Version
        $this.InstanceID = $Status.InstanceID
        Remove-Variable -Name Status
    }
}
