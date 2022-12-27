function Get-PCustomTemplate
{
    <#
    .DESCRIPTION
        Retreives custom templates from Portainer
    .PARAMETER Id
        Defines the id of the custom template to retreive.

        -Id '<Id>'
    .PARAMETER Session
        Optionally define a portainer session object to use. This is useful when you are connected to more than one portainer instance.

        -Session $Session
    .PARAMETER Type
        When listing all custom templates the scope can be limited to a type of template. Valid values are 1,2,3

        -Type 2
    .PARAMETER IncludeStackFile
        When specifying ids or piping templates/ids this parameter can be used to retreive the content of the stack configuration file.

        -IncludeStackFile
    .EXAMPLE
        Get-PCustomTemplate

        Retreives all custom templates from portainer.
    .EXAMPLE
        Get-PCustomTemplate -Id "<id>"

        Retreives a single custom template object with the specified Id
    .EXAMPLE
        Get-PContainer -Session $Session

        Retreives all custom templates on the portainer instance defined
    #>

    [CmdletBinding(DefaultParameterSetName = 'list')]
    param(
        [Parameter(ParameterSetName = 'id', ValueFromPipeline, Mandatory)]
        [object[]]
        $Id,

        [Parameter()]
        [PortainerSession]
        $Session = $null,

        [Parameter(ParameterSetName = 'list')]
        [int]
        $Type,

        [Parameter(ParameterSetName = 'id')]
        [switch]
        $IncludeStackFile

    )

    BEGIN
    {
        $Session = Get-PSession -Session:$Session

        if ($PSCmdlet.ParameterSetName -eq 'list')
        {
            if ($Type)
            {
                InvokePortainerRestMethod -Method Get -RelativePath "/custom_templates?type=$type" -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'CustomTemplate'); $_ }
            }
            else
            {
                InvokePortainerRestMethod -Method Get -RelativePath '/custom_templates' -PortainerSession:$Session | ForEach-Object { $PSItem.PSobject.TypeNames.Insert(0, 'CustomTemplate'); $_ }
            }
            break
        }
    }

    PROCESS
    {
        if ($PSCmdlet.ParameterSetName -eq 'id')
        {
            $Id | ForEach-Object {
                if ($PSItem.PSObject.TypeNames -contains 'CustomTemplate')
                {
                    $TemplateID = $PSItem.Id
                }
                elseif ($PSItem -is [int])
                {
                    $TemplateID = $PSItem
                }
                else
                {
                    Write-Error -Message 'Cannot determine input object type' -ErrorAction Stop
                }

                if ($IncludeStackFile)
                {
                    InvokePortainerRestMethod -Method Get -RelativePath "/custom_templates/$TemplateID" -PortainerSession:$Session | ForEach-Object {
                        $PSItem.PSobject.TypeNames.Insert(0, 'CustomTemplate'); $_
                    } | ForEach-Object {
                        $FileContent = InvokePortainerRestMethod -Method Get -RelativePath "/custom_templates/$TemplateID/file" -PortainerSession:$Session | Select-Object -Property filecontent
                        $PSItem | Add-Member -MemberType NoteProperty -Name 'StackFileContant' -Value $FileContent -PassThru -Force
                    }
                }
                else
                {
                    InvokePortainerRestMethod -Method Get -RelativePath "/custom_templates/$TemplateID" -PortainerSession:$Session | ForEach-Object {
                        $PSItem.PSobject.TypeNames.Insert(0, 'CustomTemplate')
                        $_
                    }
                }
            }
        }
    }
}
