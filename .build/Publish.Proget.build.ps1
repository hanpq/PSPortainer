<#
    .SYNOPSIS
        Tasks for releasing modules.

    .PARAMETER OutputDirectory
        The base directory of all output. Defaults to folder 'output' relative to
        the $BuildRoot.

    .PARAMETER BuiltModuleSubdirectory
        The parent path of the module to be built.

    .PARAMETER VersionedOutputDirectory
        If the module should be built using a version folder, e.g. ./MyModule/1.0.0.
        Defaults to $true.

    .PARAMETER ChangelogPath
        The path to and the name of the changelog file. Defaults to 'CHANGELOG.md'.

    .PARAMETER ReleaseNotesPath
        The path to and the name of the release notes file. Defaults to 'ReleaseNotes.md'.

    .PARAMETER ProjectName
        The project name.

    .PARAMETER ModuleVersion
        The module version that was built.

    .PARAMETER ProgetApiToken
        The module version that was built.

    .PARAMETER NuGetPublishSource
        The source to publish nuget packages. Defaults to https://www.powershellgallery.com.

    .PARAMETER PSModuleFeed
        The name of the feed (repository) that is passed to command Publish-Module.
        Defaults to 'PSGallery'.

    .PARAMETER SkipPublish
        If publishing should be skipped. Defaults to $false.

    .PARAMETER PublishModuleWhatIf
        If the publish command will be run with '-WhatIf' to show what will happen
        during publishing. Defaults to $false.
#>

param
(
    [Parameter()]
    [string]
    $OutputDirectory = (property OutputDirectory (Join-Path $BuildRoot 'output')),

    [Parameter()]
    [System.String]
    $BuiltModuleSubdirectory = (property BuiltModuleSubdirectory ''),

    [Parameter()]
    [System.Management.Automation.SwitchParameter]
    $VersionedOutputDirectory = (property VersionedOutputDirectory $true),

    [Parameter()]
    $ChangelogPath = (property ChangelogPath 'CHANGELOG.md'),

    [Parameter()]
    $ReleaseNotesPath = (property ReleaseNotesPath (Join-Path $OutputDirectory 'ReleaseNotes.md')),

    [Parameter()]
    [string]
    $ProjectName = (property ProjectName ''),

    [Parameter()]
    [System.String]
    $ModuleVersion = (property ModuleVersion ''),

    [Parameter()]
    [string]
    $PSTOOLS_APITOKEN = (property PSTOOLS_APITOKEN ''),

    [Parameter()]
    [string]
    $PSTOOLS_SOURCE = (property PSTOOLS_SOURCE '')
)

function Register-PSRepositoryFix
{
    <#
    .DESCRIPTION
        This function provides a workaround for an issue where it is not possible to register thirdparty repositories correctly.
    .PARAMETER Name
        Defines the name of the repository
    .PARAMETER SourceLocation
        Defines the source location of the repository
    .PARAMETER InstallationPolicy
        Defines the installation policy for the repository
    .PARAMETER Credential
        Defines the credentials to use when interacting with the repository
    .EXAMPLE
        Register-PSRepositoryFix -Name 'Repo'

        Register a repo with the specified settings
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [Uri]
        $SourceLocation,

        [ValidateSet('Trusted', 'Untrusted')]
        $InstallationPolicy = 'Trusted',

        [pscredential]
        $Credential
    )

    PROCESS
    {
        $ErrorActionPreference = 'Stop'
        Try
        {
            Write-Verbose 'Trying to register via Register-PSRepository'
            if ($Credential)
            {
                Write-Verbose -Message 'Credentials provided'
                Register-PSRepository -Name $Name -SourceLocation $SourceLocation -InstallationPolicy $InstallationPolicy -Credential $Credential
            }
            else
            {
                Register-PSRepository -Name $Name -SourceLocation $SourceLocation -InstallationPolicy $InstallationPolicy
            }
            Write-Verbose 'Registered via Register-PSRepository'
        }
        Catch
        {
            Write-Verbose 'Register-PSRepository failed, registering via workaround'

            # Adding PSRepository directly to file
            if ($Credential)
            {
                Write-Verbose -Message 'Credentials provided'
                Register-PSRepository -Name $Name -SourceLocation $env:TEMP -InstallationPolicy $InstallationPolicy -Credential $Credential
            }
            else
            {
                Register-PSRepository -Name $Name -SourceLocation $env:TEMP -InstallationPolicy $InstallationPolicy
            }
            $PSRepositoriesXmlPath = "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PowerShellGet\PSRepositories.xml"
            $repos = Import-Clixml -Path $PSRepositoriesXmlPath
            $repos[$Name].SourceLocation = $SourceLocation.AbsoluteUri
            $repos[$Name].PublishLocation = $SourceLocation.AbsoluteUri
            $repos[$Name].ScriptSourceLocation = $SourceLocation.AbsoluteUri
            $repos[$Name].ScriptPublishLocation = $SourceLocation.AbsoluteUri
            $repos | Export-Clixml -Path $PSRepositoriesXmlPath

            # Reloading PSRepository list
            Set-PSRepository -Name $Name -InstallationPolicy Trusted
            Write-Warning -Message 'Powershell needs to be restarted before the new PSRepository is available'
            Write-Verbose 'Registered via workaround'
        }
        $ErrorActionPreference = 'Continue'
    }
}

Task publish_module_to_proget -if ($PSTOOLS_APITOKEN -and (Get-Command -Name 'Publish-Module' -ErrorAction 'SilentlyContinue')) {
    . Set-SamplerTaskVariable

    Import-Module -name 'ModuleBuilder' -ErrorAction 'Stop'

    if (-not (Get-PSRepository -name 'pstools' -ErrorAction SilentlyContinue))
    {
        Register-PSRepositoryFix -Name 'pstools' -SourceLocation $PSTOOLS_SOURCE
    }

    if (-not $BuiltModuleManifest)
    {
        throw "No valid manifest found for project $ProjectName."
    }

    # Uncomment release notes (the default in Plaster/New-ModuleManifest)
    $ManifestString = Get-Content -Raw $BuiltModuleManifest
    if ( $ManifestString -match '#\sReleaseNotes\s?=')
    {
        $ManifestString = $ManifestString -replace '#\sReleaseNotes\s?=', '  ReleaseNotes ='
        $Utf8NoBomEncoding = [System.Text.UTF8Encoding]::new($False)
        [System.IO.File]::WriteAllLines($BuiltModuleManifest, $ManifestString, $Utf8NoBomEncoding)
    }

    Write-Build DarkGray "`nAbout to release '$BuiltModuleBase'."
    Write-Build DarkGray "APIToken: $($PSTOOLS_APITOKEN.SubString(0,4))..."
    Write-Build DarkGray 'Repository: pstools'

    $PublishModuleParams = @{
        Path        = $BuiltModuleBase
        NuGetApiKey = $PSTOOLS_APITOKEN
        Repository  = 'pstools'
        ErrorAction = 'Stop'
    }

    try
    {
        Publish-Module @PublishModuleParams -ErrorAction SilentlyContinue
    }
    catch
    {
        if ($_.Exception.message -like '*is already available in the repository*')
        {
            Write-Build Yellow 'This module version is already published to PSGallery'
        }
        else
        {
            throw $_
        }
    }

    Write-Build Green 'Package Published to Proget.'
}
