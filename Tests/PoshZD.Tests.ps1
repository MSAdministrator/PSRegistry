$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'

Describe "$module PowerShell Module Tests" {
    
    Context 'Module Setup' {

        It "has the root module $module.psm1" {
            "$here\$module\$module.psm1" | Should exist
        }

        It "has the manifest file $module.psd1" {
            "$here\$module\$module.psd1" | should exist

            "$here\$module\$module.psd1" | Should contain "$module.psm1"
        }

        It "$module has functions" {
            "$here\$module\Public\*.ps1" | Should exist
            "$here\$module\Public\*.ps1" | Should exist
        }

        It "$module is valid PowerShell Code" {
            $psFile = Get-Content -Path "$here\$module\$module.psm1" -ErrorAction Stop
            $errors = $null

            $null = [System.Management.Automation.PSParser]::Tokenize($psFile,[ref]$errors)
            $errors.count | Should be 0
        }
    }


    $globalFunctions = ('Set-ZDDomain',
                        'Set-ZDHeader'
                       )

    $functions = ('Mount-RegistryHive',                    
                  'Dismount-RegistryHive',                  
                  'Remove-RegistryKey'
                )
    #$functions = Get-ChildItem -Path $here\Public\*\*.ps1
    #Split-Path (Split-Path $functions -Parent) -Leaf | select -Unique

    foreach ($function in $functions)
    {
        Context 'Function Tests' {
            
            #It "$globalFunctions.ps1 should exist" {
            #    "$here\Public\$globalFunctions.ps1" | Should Exist
            #}
            It "$function.ps1 should exist" {
                "$here\$module\Public\$function.ps1" | Should Exist
            }

            It "$function.ps1 should have help block" {
                "$here\$module\Public\$function.ps1" | Should contain '<#'
                "$here\$module\Public\$function.ps1" | Should contain '#>'
            }
            
            It "$function.ps1 should have a SYNOPSIS section in the help block" {
                "$here\$module\Public\$function.ps1" | Should contain '.SYNOPSIS'
            }

            It "$function.ps1 should have a DESCRIPTION section in the help block" {
                "$here\$module\Public\$function.ps1" | Should contain '.DESCRIPTION'
            }

            It "$function.ps1 should have a EXAMPLE section in the help block" {
                "$here\$module\Public\$function.ps1" | Should contain '.EXAMPLE'
            }

            It "$function.ps1 should be an advanced function" {
                "$here\$module\Public\$function.ps1" | Should contain 'function'
                "$here\$module\Public\$function.ps1" | Should contain 'CmdLetBinding'
                "$here\$module\Public\$function.ps1" | Should contain 'param'
            }

            It "$function.ps1 should contain Write-Verbose blocks" {
                "$here\$module\Public\$function.ps1" | Should contain 'Write-Verbose'
            }

            It "$function.ps1 is valid PowerShell code" {
                $psFile = Get-Content -Path "$here\$module\Public\$function.ps1" -ErrorAction Stop
                $errors = $null

                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                $errors.count | Should be 0
            }
        }#Context Function Tests

        Context "$function has tests" {
            
            It "$function.ps1 has tests" {
                "$here\Tests\$function.Tests.ps1" | Should exist
            }
        }
    }
    
}