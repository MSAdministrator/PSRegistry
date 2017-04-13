$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'
$function = 'Dismount-RegistryHive'

Describe "$function" {

        It "when mountkey is not a GUID, it should throw" {
            { Dismount-RegistryHive -MountKey 'string' -KeyType HKLM }  | Should throw
            { Dismount-RegistryHive -MountKey 'string' -KeyType HKU }  | Should throw
        }

        It "when KeyType is not a HKLM or HKU, it should throw" {
            { Dismount-RegistryHive -MountKey 'string' -KeyType 'other' }  | Should throw
            { Dismount-RegistryHive -MountKey 'string' -KeyType 'other' }  | Should throw
        }

        It "should return true" {
            mock New-Guid {return 'some-random-guid'}

            Dismount-RegistryHive -MountKey $mountKey -KeyType HKLM | should be $true
            
        }
    }