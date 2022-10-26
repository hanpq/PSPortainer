[Setup]
AppId={{ a81b1e93-5997-4aeb-b491-524b7a309862 }}
AppName=PSPortainer
AppVersion=0.0.12
AppPublisher=GetPS
AppPublisherURL=getps.dev
AppSupportURL=getps.dev
AppUpdatesURL=getps.dev
DefaultDirName={userdocs}\WindowsPowerShell\Modules\PSPortainer
DisableDirPage=yes
DefaultGroupName=PSPortainer
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=C:\Users\hanpalmq\OneDrive\DEV\PowerShell\modules\PSPortainer\release\0.0.12
OutputBaseFilename=PSPortainer.0.0.12.Installer
Compression=lzma
SolidCompression=yes
WizardStyle=modern
Uninstallable=yes
SetupIconFile=C:\Users\hanpalmq\OneDrive\DEV\PowerShell\modules\PSPortainer\stage\PSPortainer\0.0.12\data\appicon.ico

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "C:\Users\hanpalmq\OneDrive\DEV\PowerShell\modules\PSPortainer\stage\PSPortainer\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs skipifsourcedoesntexist

[Icons]
Name: "{userdesktop}\PSPortainer"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-executionpolicy bypass -noexit -noprofile -file ""{app}\0.0.12\data\banner.ps1"""; IconFilename: "{app}\0.0.12\data\AppIcon.ico"

[Run]
Filename: "Powershell.exe"; Parameters: "-executionpolicy bypass -noexit -noprofile -file ""{app}\0.0.12\data\banner.ps1"""; Description: "Run PSPortainer"; Flags: postinstall nowait


