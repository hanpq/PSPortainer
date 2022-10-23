@{
  RootModule = 'PSPortainer.psm1'
  ModuleVersion = '0.0.3'
  CompatiblePSEditions = @('Desktop','Core')
  GUID = 'a81b1e93-5997-4aeb-b491-524b7a309862'
  Author = 'Hannes Palmquist'
  CompanyName = ''
  Copyright = '(c) 2022 Hannes Palmquist. All rights reserved.'
  Description = 'Powershell Module for interaction with Portainer API'
  RequiredModules = @()
  FunctionsToExport = @('Connect-Portainer','Get-PortainerSettingsPublic','Get-PortainerStatus')
  FileList = @('.\data\appicon.ico','.\data\banner.ps1','.\docs\PSPortainer.md','.\en-US\Connect-Portainer.md','.\en-US\PSPortainer-help.xml','.\include\module.utility.functions.ps1','.\private\.gitignore','.\private\InvokePortainerRestMethod.ps1','.\private\PortainerSession.class.ps1','.\public\Connect-Portainer.ps1','.\public\Get-PortainerSettingsPublic.ps1','.\public\Get-PortainerStatus.ps1','.\settings\config.json','.\LICENSE.txt','.\PSPortainer.psd1','.\PSPortainer.psm1')
  PrivateData = @{
    ModuleName = 'PSPortainer.psm1'
    DateCreated = '2022-10-23'
    LastBuildDate = '2022-10-23'
    PSData = @{
      Tags = @('PSEdition_Desktop','PSEdition_Core','Windows','Linux','MacOS')
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
  FormatsToProcess = @()
  NestedModules = @()
  HelpInfoURI = ''
  DefaultCommandPrefix = ''
  PowerShellVersion = '5.1'
  PowerShellHostName = ''
  PowerShellHostVersion = ''
  DotNetFrameworkVersion = ''
  CLRVersion = ''
  ProcessorArchitecture = ''
}
