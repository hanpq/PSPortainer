<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "0cf86f27-137b-43ee-a194-ec0207d85ce5",
  "FILENAME": "InvokePortainerRestMethod.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-23",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function InvokePortainerRestMethod
{
    <#
    .DESCRIPTION
        Function that is responsible for making the rest api web call
    .PARAMETER NoAuth
        Specifies that the REST API call do not need authentication
    .PARAMETER Method
        Defines the method to use when calling the REST API, valid values GET,POST etc.
    .PARAMETER PortainerSession
        A PortainerSession object to use for the call.
    .PARAMETER RelativePath
        The REST API path relative to the base URL
    .PARAMETER Body
        Defines body attributes for the REST API call
    .PARAMETER Headers
        Defines header attributes for the REST API call
    .EXAMPLE
        InvokePortainerRestMethod
    #>
    [CmdletBinding()] # Enabled advanced function support
    param(
        [switch]$NoAuth,
        [string]$Method,
        [portainersession]$PortainerSession,
        [string]$RelativePath,
        [hashtable]$Body = @{},
        [hashtable]$Headers = @{}
    )

    if (-not $PortainerSession)
    {
        Write-Debug -Message 'InvokePortainerRestMethod; No PortainerSession passed as parameter'
        if ($script:PortainerSession)
        {
            Write-Debug -Message 'InvokePortainerRestMethod; PortainerSession found in script scope'
            $PortainerSession = $script:PortainerSession
        }
        else
        {
            Write-Error -Message 'No Portainer Session established, please call Connect-Portainer'
        }
    }

    $InvokeRestMethodSplat = @{
        Method = $Method
        Uri    = "$($PortainerSession.ApiUri)$($RelativePath)"
    }

    if (-not $NoAuth)
    {
        switch ($PortainerSession.AuthMethod)
        {
            'Credential'
            {
                $InvokeRestMethodSplat.Authentication = 'Bearer'
                $InvokeRestMethodSplat.Token = $PortainerSession.JWT
            }
            'AccessToken'
            {
                $Headers.'X-API-Key' = (ConvertFrom-SecureString -SecureString $PortainerSession.AccessToken -AsPlainText)
            }
        }
    }

    if ($Headers.Keys.Count -gt 0)
    {
        $InvokeRestMethodSplat.Headers = $Headers
    }
    if ($InvokeRestMethodSplat.Method -eq 'Get')
    {
        if ($Body.Keys.Count -gt 0 )
        {
            $InvokeRestMethodSplat.Body = $Body
        }
    }
    elseif ($InvokeRestMethodSplat.Method -eq 'Post')
    {
        # Might need to be changed, some post requests require formdata
        $InvokeRestMethodSplat.Body = $Body | ConvertTo-Json -Compress
        $InvokeRestMethodSplat.ContentType = 'application/json'
    }


    Write-Debug -Message "InvokePortainerRestMethod; Calling Invoke-RestMethod with settings`r`n$($InvokeRestMethodSplat | ConvertTo-Json)"
    Invoke-RestMethod @InvokeRestMethodSplat -Verbose:$false | ForEach-Object { $_ }
}


#endregion
