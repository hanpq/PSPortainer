
BeforeAll {
    $ProjectPath = "$PSScriptRoot\..\..\.." | Convert-Path
    $ProjectName = (Get-ChildItem $ProjectPath\*\*.psd1 | Where-Object {
        ($_.Directory.Name -eq 'source') -and
            $(try
                {
                    Test-ModuleManifest $_.FullName -ErrorAction Stop
                }
                catch
                {
                    $false
                })
        }
    ).BaseName

    Import-Module $ProjectName -Force
}

InModuleScope $ProjectName {
    Describe PortainerContainer.class {
        Context 'Type creation' {
            It 'Has created a type named class1' {
                'PortainerContainerProcess' -as [Type] | Should -BeOfType [Type]
            }
        }
        Context 'Constructors' {
            It 'Has a default constructor' {
                $instance = [PortainerContainerProcess]::new()
                $instance | Should -Not -BeNullOrEmpty
                $instance.GetType().Name | Should -Be 'PortainerContainerProcess'
            }
        }
        Context 'Methods' {
            BeforeEach {
                $instance = [PortainerContainerProcess]::new()
            }

            It 'Overrides the ToString method' {
                $instance.ToString() | Should -Be 'ProcessID: 0'
            }
        }
        Context 'Properties' {
            BeforeEach {
                $instance = [PortainerContainerProcess]::new()
            }

            It 'Has a UserID property' {
                $instance.UserID | Should -Be ''
            }
        }
    }
}
