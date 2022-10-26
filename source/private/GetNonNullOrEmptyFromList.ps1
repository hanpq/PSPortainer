<#PSScriptInfo
{
  "VERSION": "1.0.0",
  "GUID": "4a356917-cc37-4ba0-b54b-82ead703ac2a",
  "FILENAME": "GetNonNullOrEmptyFromList.ps1",
  "AUTHOR": "Hannes Palmquist",
  "CREATEDDATE": "2022-10-26",
  "COMPANYNAME": [],
  "COPYRIGHT": "(c) 2022, Hannes Palmquist, All Rights Reserved"
}
PSScriptInfo#>
function GetNonNullOrEmptyFromList
{
    <#
    .DESCRIPTION
        Selects a non null, non empty value from the provided array, if more than one is found it coniders the lowest value in the array with priority.
    .PARAMETER Array
        String array containing the values to evaluate, null and empty strings are allowed as these will not be considered for selection, efectievly filtering them out.
    .PARAMETER AskIfNoneIsFound
        Defines if the script should try and ask the user for a value instead of failing.
    .PARAMETER PropertyName
        If the parameter AskIfNoneIsFound is selected this string is used to ask the user for a value
    .EXAMPLE
        GetNonNullOrEmptyFromList -Array @('test1',$null,'','test2')

        The example above would return test1 as it is not null or empty and by beeing defined earlier in the array than test2.
    #>

    [CmdletBinding()] # Enabled advanced function support
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][AllowNull()][AllowEmptyString()][string[]]$Array,
        [Parameter(Mandatory, ParameterSetName = 'Ask')][switch]$AskIfNoneIsFound,
        [Parameter(Mandatory, ParameterSetName = 'Ask')][string]$PropertyName
    )

    $Selected = $null

    # Reverse array to process the first item as highest prio
    [array]::Reverse($Array)
    foreach ($item in $Array)
    {
        if (-not ([string]::IsNullOrEmpty($Item)))
        {
            $Selected = $item
        }
    }

    # Ask user if no cadidate can be selected
    if (-not $Selected -and $AskIfNoneIsFound)
    {
        $Selected = Read-Host -Prompt "Please enter a value for $PropertyName"
    }

    # Verify that user input is not empty before returning
    if ([string]::IsNullOrEmpty($Selected))
    {
        Write-Error -Message 'GetNonNullOrEmptyFromList; Unable to find candidate' -ErrorAction Stop
    }
    else
    {
        return $Selected
    }
}



