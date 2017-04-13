<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Remove-RegistryKey -KeyType HKLM -KeyPath 'SOFTWARE\Test\Path'
.EXAMPLE
   Another example of how to use this cmdlet
#>
Function Open-RegistryKey
{
    [CmdletBinding()]
    param(
        
        #Registry Key type can be HKLM or HKU
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 0
        )] 
        [ValidateSet(
            'HKEY_CLASSES_ROOT',
            'HKEY_CURRENT_USER',
            'HKEY_LOCAL_MACHINE',
            'HKEY_USERS',
            'HKEY_PERFORMANCE_DATA',
            'HKEY_CURRENT_CONFIG',
            'HKEY_DYN_DATA'
        )]
        [string]$KeyType,

        # KeyPath that you want to remove
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 1
        )]
        [ValidateNotNullOrEmpty()]
        #[ValidateScript({ if ($_ -match '^H\w{2,3}\:\\'){$false}}
        #    )]
        [System.String]$KeyPath,

        #Registry Key value you want to remove
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 2
        )]
        [ValidateSet(
            'KEY_QUERY_VALUE',
            'KEY_SET_VALUE',
            'KEY_CREATE_SUB_KEY',
            'KEY_ENUMERATE_SUB_KEYS',
            'KEY_NOTIFY',
            'KEY_CREATE_LINK',
            'KEY_WOW64_32KEY',
            'KEY_WOW64_64KEY',
            'KEY_ALL_ACCESS',
            'KEY_EXECUTE',
            'KEY_READ',
            'KEY_NOTIFY',
            'KEY_WRITE'
        )]
        [string]$Permission
    )

    Try
    {
        Write-Verbose -Message 'Setting token privileges'

        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeBackupPrivilege"
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeRestorePrivilege"

        Write-Verbose -Message "Requested KeyType is $KeyType"

        switch ($KeyType)
        {
            'HKEY_CLASSES_ROOT'     { $Key = 0x80000000 }
            'HKEY_CURRENT_USER'     { $Key = 0x80000001 }
            'HKEY_LOCAL_MACHINE'    { $Key = 0x80000002 }
            'HKEY_USERS'            { $Key = 0x80000003 }
            'HKEY_PERFORMANCE_DATA' { $Key = 0x80000004 }
            'HKEY_CURRENT_CONFIG'   { $Key = 0x80000005 }
            'HKEY_DYN_DATA'         { $Key = 0x80000006 }
        }

        Write-Verbose -Message "KeyType Value is $Key"

        <#
        VALUE_TYPE

        $REG_NONE,
        $REG_SZ = 1,
        $REG_EXPAND_SZ = 2,
        $REG_BINARY = 3,
        $REG_DWORD = 4,
        $REG_DWORD_LITTLE_ENDIAN = 4,
        $REG_DWORD_BIG_ENDIAN = 5,
        $REG_LINK = 6,
        $REG_MULTI_SZ = 7,
        $REG_RESOURCE_LIST = 8,
        $REG_FULL_RESOURCE_DESCRIPTOR = 9,
        $REG_RESOURCE_REQUIREMENTS_LIST = 10,
        $REG_QWORD_LITTLE_ENDIAN = 11 
        #>

        Write-Verbose -Message "Requested Permission $Permission"

        switch ($Permission)
        {
            'KEY_QUERY_VALUE'        { $PermValue = 0x0001    }
            'KEY_SET_VALUE'          { $PermValue = 0x0002    }
            'KEY_CREATE_SUB_KEY'     { $PermValue = 0x0004    }
            'KEY_ENUMERATE_SUB_KEYS' { $PermValue = 0x0008    }
            'KEY_NOTIFY'             { $PermValue = 0x0010    }
            'KEY_CREATE_LINK'        { $PermValue = 0x0020    }
            'KEY_WOW64_32KEY'        { $PermValue = 0x00200   }
            'KEY_WOW64_64KEY'        { $PermValue = 0x00100   }
            'KEY_WOW64_RES'          { $PermValue = 0x00300   }
            'KEY_ALL_ACCESS'         { $PermValue = 0xF003F   }
            'KEY_EXECUTE'            { $PermValue = 0x20019   }
            'ALL_ACCESS'             { $PermValue = 0xF003F   }
            'KEY_READ'               { $PermValue = 0x0020019 }
            'KEY_WRITE'              { $PermValue = 0x20006   }
        }

        Write-Verbose -Message "Permission Value = $PermValue"

        Write-Verbose -Message 'Adding custom type RegOpenKeyEx'

        $Reg = Add-RegOpenKeyExType
        
        $phkResult = ''

        Write-Verbose -Message 'Calling RegOpenKeyEx'

        $Result = $Reg::RegOpenKeyEx( $Key, $KeyPath, 0, $PermValue, $phkResult )

        $props = @{
            KeyType = $KeyType
            KeyPath = $KeyPath
            Result  = $Result
        }

        $returnObject = New-Object -TypeName PSCustomObject -Property $props

        Write-Output $returnObject
    }
    Catch
    {
        $_ | Format-List -Force
        Write-LogEntry -type Error -message 'Error attempting to mount registry' -thisError $($Error[0] | Format-List -Force)
    }
}