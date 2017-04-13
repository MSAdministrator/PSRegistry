$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'
$function = 'Remove-RegistryKey'

Describe "$function" {

        It "when keypath includes keytype, it should throw" {
            { Remove-RegistryKey -KeyType HKLM -KeyPath 'HKLM:\SOFTWARE' }  | Should throw
        }

        It "should return an object" {
            $ReturnObject = Remove-RegistryKey
            $ReturnObject.GetType().FullName | should be "System.Management.Automation.PSCustomObject"
            $ReturnObject.KeyType | Should not be $null
            $ReturnObject.MountKey | Should not be $null
        }

        It "when passed HKLM as KeyType it should return HKLM as keytype" {
            $ReturnObject = Remove-RegistryKey
            $ReturnObject.KeyType | Should be 'HKLM'
        }

        It "when passed HKU as KeyType it should return HKU as keytype" {
            $ReturnObject = Remove-RegistryKey
            $ReturnObject.KeyType | Should be 'HKU'
        }

        It "when keytype value is not HKLM or HKU, it should throw" {
            { Remove-RegistryKey } | should throw
        }
}