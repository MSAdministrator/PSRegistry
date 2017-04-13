$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'
$function = 'New-RegistryKey'

Describe "$function" {

        It "when keypath includes keytype, it should throw" {
            { New-RegistryKey -KeyType HKLM -KeyPath 'HKLM:\SOFTWARE' }  | Should throw
        }

        It "should return an object" {
            $ReturnObject = New-RegistryKey -KeyType HKLM -KeyPath 'SOFTWARE\test'
            $ReturnObject.GetType().FullName | should be "System.Object[]"
            $ReturnObject.KeyType | Should not be $null
            $ReturnObject.KeyPath | Should not be $null
        }

        It "when passed HKLM as KeyType it should return HKLM as keytype" {
            $ReturnObject = New-RegistryKey -KeyType HKLM -KeyPath 'SOFTWARE\test'
            $ReturnObject.KeyType | Should be 'HKLM'
        }

        It "when passed HKU as KeyType it should return HKU as keytype" {
            $ReturnObject = New-RegistryKey -KeyType HKU -KeyPath 'SOFTWARE\test'
            $ReturnObject.KeyType | Should be 'HKU'
        }
}