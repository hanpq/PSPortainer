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
class PortainerSession
{
    [string]$BaseUri
    [string]$AuthMethod
    [securestring]$AccessToken
    [string]$APIUri
    [string]$FQDN
    [string]$InstanceID
    [string]$PortainerVersion

    PortainerSession ([string]$BaseUri, [securestring]$AccessToken)
    {
        Write-Debug -Message 'PortainerSession.Class; Running constructor accesstoken'
        $this.BaseUri = $BaseUri
        $this.APIUri = "$BaseUri/api"
        $this.AuthMethod = 'AccessToken'
        $this.AccessToken = $AccessToken
        $this.GetStatus()
        Write-Verbose -Message "Connected to portainer instance at $($this.BaseURL)"
    }

    GetStatus()
    {
        $Status = InvokePortainerRestMethod -AuthRequired:$false -Method:'Get' -PortainerSession $this -RelativePath '/status'
        $this.PortainerVersion = $Status.Version
        $this.InstanceID = $Status.InstanceID
    }

    [hashtable]GetAuthHeader()
    {
        switch ($this.AuthMethod)
        {
            'AccessToken'
            {
                return ([hashtable]@{
                        'X-API-Key' = (ConvertFrom-SecureString -SecureString $this.AccessToken -AsPlainText)
                    })
            }
            default
            {
                return (@{})
            }
        }
        return (@{})
    }

}
