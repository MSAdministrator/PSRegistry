$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'
$function = 'Mount-RegistryHive'

Describe "$function" {

        It "when NTUSER without extension is passed, it should throw" {
            { Mount-RegistryHive -NTUSER $ENV:USERPROFILE\NTUSER -KeyType HKLM }  | Should throw
        }

        It "should return an object" {
            $ReturnObject = Mount-RegistryHive -NTUSER $env:USERPROFILE\NTUSER.dat -KeyType HKLM
            $ReturnObject.GetType().FullName | should be "System.Management.Automation.PSCustomObject"
            $ReturnObject.KeyType | Should not be $null
            $ReturnObject.MountKey | Should not be $null
        }

        It "when passed HKLM as KeyType it should return HKLM as keytype" {
            $ReturnObject = Mount-RegistryHive -NTUSER $env:USERPROFILE\NTUSER.dat -KeyType HKLM
            $ReturnObject.KeyType | Should be 'HKLM'
        }

        It "when passed HKU as KeyType it should return HKU as keytype" {
            $ReturnObject = Mount-RegistryHive -NTUSER $env:USERPROFILE\NTUSER.dat -KeyType HKU
            $ReturnObject.KeyType | Should be 'HKU'
        }

        It "when keytype value is not HKLM or HKU, it should throw" {
            { Mount-RegistryHive -NTUSER $ENV:USERPROFILE\NTUSER.dat -KeyType 'SOMETHING' } | should throw
        }
}