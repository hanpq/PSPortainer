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
        .
    .PARAMETER Name
        Description
    .EXAMPLE
        InvokePortainerRestMethod
        Description of example
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
    if ($Body.Keys.Count -gt 0 )
    {
        if ($InvokeRestMethodSplat.Method -eq 'Get')
        {
            $InvokeRestMethodSplat.Body = $Body
        }
        elseif ($InvokeRestMethodSplat.Method -eq 'Post')
        {
            # Might need to be changed, some post requests require formdata
            $InvokeRestMethodSplat.Body = $Body | ConvertTo-Json
            $InvokeRestMethodSplat.ContentType = 'application/json'
        }
    }


    Write-Debug -Message "InvokePortainerRestMethod; Calling Invoke-RestMethod with settings`r`n$($InvokeRestMethodSplat | ConvertTo-Json)"
    Invoke-RestMethod @InvokeRestMethodSplat | ForEach-Object { $_ }
}


#endregion


