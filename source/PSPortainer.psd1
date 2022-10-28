@{
  RootModule = 'PSPortainer.psm1'
  ModuleVersion = '0.0.15'
  CompatiblePSEditions = @('Core')
  GUID = 'a81b1e93-5997-4aeb-b491-524b7a309862'
  Author = 'Hannes Palmquist'
  CompanyName = ''
  Copyright = '(c) 2022 Hannes Palmquist. All rights reserved.'
  Description = 'Powershell Module for interaction with Portainer API'
  RequiredModules = @()
  FunctionsToExport = @('Connect-Portainer','Disconnect-Portainer','Get-PContainer','Get-PContainerProcess','Get-PContainerStatistic','Get-PEndpoint','Get-PSession','Get-PSettingsPublic','Get-PStatus','Restart-PContainer','Select-PEndpoint','Start-PContainer','Stop-PContainer')
  FileList = @('.\data\appicon.ico','.\data\banner.ps1','.\docs\PSPortainer.md','.\en-US\Connect-Portainer.md','.\en-US\Disconnect-Portainer.md','.\en-US\Get-PContainer.md','.\en-US\Get-PContainerProcess.md','.\en-US\Get-PContainerStatistics.md','.\en-US\Get-PEndpoint.md','.\en-US\Get-PortainerContainer.md','.\en-US\Get-PortainerSession.md','.\en-US\Get-PortainerSettingsPublic.md','.\en-US\Get-PortainerStatus.md','.\en-US\Get-PSession.md','.\en-US\Get-PSettingsPublic.md','.\en-US\Get-PStatus.md','.\en-US\PSPortainer-help.xml','.\en-US\Select-PEndpoint.md','.\include\module.utility.functions.ps1','.\include\PortainerContainer.Format.ps1xml','.\include\PortainerContainerProcess.Format.ps1xml','.\private\.gitignore','.\private\ArgumentCompleters.ps1','.\private\GetNonNullOrEmptyFromList.ps1','.\private\InvokePortainerRestMethod.ps1','.\private\PortainerContainerProcess.class.ps1','.\private\PortainerSession.class.ps1','.\public\Connect-Portainer.ps1','.\public\Disconnect-Portainer.ps1','.\public\Get-PContainer.ps1','.\public\Get-PContainerProcess.ps1','.\public\Get-PContainerStatistic.ps1','.\public\Get-PEndpoint.ps1','.\public\Get-PSession.ps1','.\public\Get-PSettingsPublic.ps1','.\public\Get-PStatus.ps1','.\public\Restart-PContainer.ps1','.\public\Select-PEndpoint.ps1','.\public\Start-PContainer.ps1','.\public\Stop-PContainer.ps1','.\settings\config.json','.\LICENSE.txt','.\PSPortainer.psd1','.\PSPortainer.psm1')
  PrivateData = @{
    ModuleName = 'PSPortainer.psm1'
    DateCreated = '2022-10-23'
    LastBuildDate = '2022-10-28'
    PSData = @{
      Tags = @('PSEdition_Core','Windows','Linux','MacOS')
      ProjectUri = 'https://getps.dev/modules/PSPortainer/quickstart'
      LicenseUri = 'https://github.com/hanpq/PSPortainer/blob/main/LICENSE'
      ReleaseNotes = 'https://getps.dev/modules/PSPortainer/changelog'
      IsPrerelease = 'False'
      IconUri = ''
      PreRelease = ''
      RequireLicenseAcceptance = $True
      ExternalModuleDependencies = @()
    }
  }
  CmdletsToExport = @()
  VariablesToExport = @()
  AliasesToExport = @()
  DscResourcesToExport = @()
  ModuleList = @()
  RequiredAssemblies = @()
  ScriptsToProcess = @()
  TypesToProcess = @()
  FormatsToProcess = @('.\include\PortainerContainer.Format.ps1xml','.\include\PortainerContainerProcess.Format.ps1xml')
  NestedModules = @()
  HelpInfoURI = ''
  DefaultCommandPrefix = ''
  PowerShellVersion = '6.0'
  PowerShellHostName = ''
  PowerShellHostVersion = ''
  DotNetFrameworkVersion = ''
  CLRVersion = ''
  ProcessorArchitecture = ''
}
