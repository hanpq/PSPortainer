
function Get-ModuleConfiguration
{
    try
    {
        Get-Variable -Scope Global -Name ('ModuleConfiguration_{0}' -f ($MyInvocation.MyCommand.Module.Name)) -ValueOnly -ErrorAction Stop
    }
    catch
    {
        Write-Error -Message 'Failed to retrevie module configuration' -ErrorRecord $_
    }
}

function Initialize-ModuleConfiguration
{
    # Define ModuleConfiguration class
    class ModuleConfiguration
    {
        [string]$ModuleName = ''
        [string]$ModuleRootPath = ''
        [string]$ModuleManifestPath = ''
        [hashtable]$ModuleFolders = @{}
        [hashtable]$ModuleFiles = @{}
        [hashtable]$ModuleFilePaths = @{}
        $ModuleManifest

        [void] CollectModuleFilePaths ()
        {
            Get-ChildItem -Path $this.ModuleRootPath -Recurse -File | ForEach-Object {
                $this.ModuleFilePaths.($PSItem.Name) = $PSItem.FullName
            }
        }

        [void] ImportFiles ()
        {
            foreach ($File in (Get-ChildItem -Path $this.ModuleFolders.Settings -File -Recurse))
            {
                try
                {
                    $Content = $null
                    switch ($File.Extension)
                    {
                        '.csv' { $Content = Import-Csv $File.FullName -Delimiter ';' -Encoding UTF8 -ErrorAction Stop }
                        '.psd1' { $Content = Import-PowerShellDataFile -Path $File.fullname -ErrorAction Stop }
                        '.json' { $Content = Get-Content -Path $File.FullName -ErrorAction Stop -Raw | ConvertFrom-Json -ErrorAction Stop }
                        '.cred' { $Content = Import-Clixml -Path $File.FullName  -ErrorAction Stop }
                        default
                        {
                            Write-Warning -Message ('Failed to import configuration file {0}, unknown extension' -f $File.Name)
                            $Content = $null
                        }
                    }
                    if ($Content)
                    {
                        $null = $this.ModuleFiles.Add($File.BaseName, $Content)
                    }
                }
                catch
                {
                    Write-Error -Message ('Failed to import configuration {0} with error: {1}' -f $File.BaseName, $_.exception.message)
                }
            }
        }

        ModuleConfiguration (
            $MyInvoc
        )
        {
            # ModuleName
            $this.ModuleName = $MyInvoc.MyCommand.Module.Name

            # ModuleRootPath
            $this.ModuleRootPath = $MyInvoc.PSScriptRoot

            # ModuleFolders
            Get-ChildItem -Path $this.ModuleRootPath -Directory | ForEach-Object { $null = $this.ModuleFolders.Add($_.Name, $_.Fullname) }

            # ModuleManifestPath
            $this.ModuleManifestPath = (Join-Path -Path $this.ModuleRootPath -ChildPath ('{0}.psd1' -f $this.ModuleName))

            # ModuleManifest
            $this.ModuleManifest = Import-PowerShellDataFile -Path $this.ModuleManifestPath

            # ModuleFiles
            $this.ImportFiles()

            # ModuleFilePaths
            $this.CollectModuleFilePaths()
        }
    }

    # Store module configuration
    try
    {
        $null = New-Variable -Scope Global -Name ('ModuleConfiguration_{0}' -f ($MyInvocation.MyCommand.Module.Name)) -Value ([ModuleConfiguration]::New($MyInvocation)) -Force -ErrorAction Stop
    }
    catch
    {
        Write-Error -Message 'Failed to store ModuleConfiguration' -ErrorRecord $_
    }
}

function pslog
{
    [cmdletbinding()]
    param(
        [parameter(Position = 0)]
        [ValidateSet('Success', 'Info', 'Warning', 'Error', 'Verbose', 'Debug')]
        [Alias('Type')]
        [string]
        $Severity,

        [parameter(Mandatory, Position = 1)]
        [string]
        $Message,

        [parameter(position = 2)]
        [string]
        $source = 'default',

        [parameter(Position = 3)]
        [switch]
        $Throw
    )

    begin
    {
        $localappdatapath = [Environment]::GetFolderPath('localapplicationdata') # ie C:\Users\<username>\AppData\Local
        $modulename = (Get-ModuleConfiguration).ModuleName
        $logdir = "$localappdatapath\$modulename\logs"
        $logdir | Assert-FolderExists
        $timestamp = (Get-Date)
        $logfilename = ('{0}.log' -f $timestamp.ToString('yyy-MM-dd'))
        $timestampstring = $timestamp.ToString('yyyy-MM-ddThh:mm:ss.ffffzzz')
    }

    process
    {
        switch ($Severity)
        {
            'Success'
            {
                "$timestampstring`t$psitem`t$source`t$message" | Add-Content -Path "$logdir\$logfilename" -Encoding utf8 -WhatIf:$false
                Write-Host -Object "SUCCESS: $timestampstring`t$source`t$message" -ForegroundColor Green
            }
            'Info'
            {
                "$timestampstring`t$psitem`t$source`t$message" | Add-Content -Path "$logdir\$logfilename" -Encoding utf8 -WhatIf:$false
                Write-Information -Message "$timestampstring`t$source`t$message"
            }
            'Warning'
            {
                "$timestampstring`t$psitem`t$source`t$message" | Add-Content -Path "$logdir\$logfilename" -Encoding utf8 -WhatIf:$false
                Write-Warning -Message "$timestampstring`t$source`t$message"
            }
            'Error'
            {
                "$timestampstring`t$psitem`t$source`t$message" | Add-Content -Path "$logdir\$logfilename" -Encoding utf8 -WhatIf:$false
                Write-Error -Message "$timestampstring`t$source`t$message"
                if ($throw)
                {
                    throw
                }
            }
            'Verbose'
            {
                if ($VerbosePreference -ne 'SilentlyContinue')
                {
                    "$timestampstring`t$psitem`t$source`t$message" | Add-Content -Path "$logdir\$logfilename" -Encoding utf8 -WhatIf:$false
                }
                Write-Verbose -Message "$timestampstring`t$source`t$message"
            }
            'Debug'
            {
                if ($DebugPreference -ne 'SilentlyContinue')
                {
                    "$timestampstring`t$psitem`t$source`t$message" | Add-Content -Path "$logdir\$logfilename" -Encoding utf8 -WhatIf:$false
                }
                Write-Debug -Message "$timestampstring`t$source`t$message"
            }
        }
    }
}

function Write-PSProgress
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Standard')]
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Completed')]
        [string]
        $Activity,

        [Parameter(Position = 1, ParameterSetName = 'Standard')]
        [Parameter(Position = 1, ParameterSetName = 'Completed')]
        [ValidateRange(0, 2147483647)]
        [int]
        $Id,

        [Parameter(Position = 2, ParameterSetName = 'Standard')]
        [string]
        $Target,

        [Parameter(Position = 3, ParameterSetName = 'Standard')]
        [Parameter(Position = 3, ParameterSetName = 'Completed')]
        [ValidateRange(-1, 2147483647)]
        [int]
        $ParentId,

        [Parameter(Position = 4, ParameterSetname = 'Completed')]
        [switch]
        $Completed,

        [Parameter(Mandatory = $true, Position = 5, ParameterSetName = 'Standard')]
        [long]
        $Counter,

        [Parameter(Mandatory = $true, Position = 6, ParameterSetName = 'Standard')]
        [long]
        $Total,

        [Parameter(Position = 7, ParameterSetName = 'Standard')]
        [datetime]
        $StartTime,

        [Parameter(Position = 8, ParameterSetName = 'Standard')]
        [switch]
        $DisableDynamicUpdateFrquency,

        [Parameter(Position = 9, ParameterSetName = 'Standard')]
        [switch]
        $NoTimeStats
    )

    # Define current timestamp
    $TimeStamp = (Get-Date)

    # Define a dynamic variable name for the global starttime variable
    $StartTimeVariableName = ('ProgressStartTime_{0}' -f $Activity.Replace(' ', ''))

    # Manage global start time variable
    if ($PSBoundParameters.ContainsKey('Completed') -and (Get-Variable -Name $StartTimeVariableName -Scope Global -ErrorAction SilentlyContinue))
    {
        # Remove the global starttime variable if the Completed switch parameter is users
        try
        {
            Remove-Variable -Name $StartTimeVariableName -ErrorAction Stop -Scope Global
        }
        catch
        {
            throw $_
        }
    }
    elseif (-not (Get-Variable -Name $StartTimeVariableName -Scope Global -ErrorAction SilentlyContinue))
    {
        # Global variable do not exist, create global variable
        if ($null -eq $StartTime)
        {
            # No start time defined with parameter, use current timestamp as starttime
            Set-Variable -Name $StartTimeVariableName -Value $TimeStamp -Scope Global
            $StartTime = $TimeStamp
        }
        else
        {
            # Start time defined with parameter, use that value as starttime
            Set-Variable -Name $StartTimeVariableName -Value $StartTime -Scope Global
        }
    }
    else
    {
        # Global start time variable is defined, collect and use it
        $StartTime = Get-Variable -Name $StartTimeVariableName -Scope Global -ErrorAction Stop -ValueOnly
    }

    # Define frequency threshold
    $Frequency = [Math]::Ceiling($Total / 100)
    switch ($PSCmdlet.ParameterSetName)
    {
        'Standard'
        {
            # Only update progress is any of the following is true
            # - DynamicUpdateFrequency is disabled
            # - Counter matches a mod of defined frequecy
            # - Counter is 0
            # - Counter is equal to Total (completed)
            if (($DisableDynamicUpdateFrquency) -or ($Counter % $Frequency -eq 0) -or ($Counter -eq 1) -or ($Counter -eq $Total))
            {

                # Calculations for both timestats and without
                $Percent = [Math]::Round(($Counter / $Total * 100), 0)

                # Define count progress string status
                $CountProgress = ('{0}/{1}' -f $Counter, $Total)

                # If percent would turn out to be more than 100 due to incorrect total assignment revert back to 100% to avoid that write-progress throws
                if ($Percent -gt 100) { $Percent = 100 }

                # Define write-progress splat hash
                $WriteProgressSplat = @{
                    Activity         = $Activity
                    PercentComplete  = $Percent
                    CurrentOperation = $Target
                }

                # Add ID if specified
                if ($Id) { $WriteProgressSplat.Id = $Id }

                # Add ParentID if specified
                if ($ParentId) { $WriteProgressSplat.ParentId = $ParentId }

                # Calculations for either timestats and without
                if ($NoTimeStats)
                {
                    $WriteProgressSplat.Status = ('{0} - {1}%' -f $CountProgress, $Percent)
                }
                else
                {
                    # Total seconds elapsed since start
                    $TotalSeconds = ($TimeStamp - $StartTime).TotalSeconds

                    # Calculate items per sec processed (IpS)
                    $ItemsPerSecond = ([Math]::Round(($Counter / $TotalSeconds), 2))

                    # Calculate seconds spent per processed item (for ETA)
                    $SecondsPerItem = if ($Counter -eq 0) { 0 } else { ($TotalSeconds / $Counter) }

                    # Calculate seconds remainging
                    $SecondsRemaing = ($Total - $Counter) * $SecondsPerItem
                    $WriteProgressSplat.SecondsRemaining = $SecondsRemaing

                    # Calculate ETA
                    $ETA = $(($Timestamp).AddSeconds($SecondsRemaing).ToShortTimeString())

                    # Add findings to write-progress splat hash
                    $WriteProgressSplat.Status = ('{0} - {1}% - ETA: {2} - IpS {3}' -f $CountProgress, $Percent, $ETA, $ItemsPerSecond)
                }

                # Call writeprogress
                Write-Progress @WriteProgressSplat
            }
        }
        'Completed'
        {
            Write-Progress -Activity $Activity -Id $Id -Completed
        }
    }
}

filter Assert-FolderExists
{
    $exists = Test-Path -Path $_ -PathType Container
    if (!$exists)
    {
        Write-Verbose "$_ did not exist. Folder created."
        $null = New-Item -Path $_ -ItemType Directory
    }
}

filter Invoke-GarbageCollect
{
    [system.gc]::Collect()
}
