$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'
$function = 'Mount-RemoteRegistryHive'

Describe "$function" {
    
    Context "Should throw errors" {

        It "when computer name is not valid, it should throw" {
            { Mount-RemoteRegistryHive -Computer 'computer' -KeyType HKLM }  | Should throw
        }

        It "when keytype value is not HKLM or HKU, it should throw" {
            { Mount-RemoteRegistryHive -Computer 'computer' -KeyType 'SOMETHING' } | should throw
        }
    }

    Context "Should not throw" {

        mock Test-Path {return $true}

        It "should return an object" {

            $ReturnObject = Mount-RemoteRegistryHive -Computer '\\computername\share' -KeyType HKLM
            $ReturnObject.GetType().FullName | should be "System.Management.Automation.PSCustomObject"
            $ReturnObject.KeyType | Should not be $null
            $ReturnObject.MountKey | Should not be $null
        }

        It "when passed HKLM as KeyType it should return HKLM as keytype" {
            $ReturnObject = Mount-RemoteRegistryHive -Computer '\\computername\share' -KeyType HKLM
            $ReturnObject.KeyType | Should be 'HKLM'
        }

        It "when passed HKU as KeyType it should return HKU as keytype" {
            $ReturnObject = Mount-RemoteRegistryHive -Computer '\\computername\share' -KeyType HKU
            $ReturnObject.KeyType | Should be 'HKU'
        }

    }
        
}