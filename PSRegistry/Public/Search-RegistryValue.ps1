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
Function Search-RegistryValue
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
            'HKEY_CURRENT_CONFIG'
        )]
        [string]$KeyType,

        # KeyPath that you want to remove
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 1
        )]
        [ValidateNotNullOrEmpty()]
       # [ValidateScript({ if ($_ -match '^H\w{2,3}\:\\'){$false}}
       #     )]
        [System.String]$KeyPath,

        #Registry Key value you want to remove
        [Parameter(
            Mandatory         = $True,
            ValueFromPipeline = $True,
            Position          = 2
        )] 
        [string]$Value
    )

    Try
    {
        Write-Verbose -Message 'Setting token privileges'

        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeBackupPrivilege"
        $TokenPrivilege = Set-TokenPrivilege -Privilege "SeRestorePrivilege"

        
        switch ($KeyType)
        {
            'HKEY_CLASSES_ROOT'     { $Key = 0x80000000 }
            'HKEY_CURRENT_USER'     { $Key = 0x80000001 }
            'HKEY_LOCAL_MACHINE'    { $Key = 0x80000002 }
            'HKEY_USERS'            { $Key = 0x80000003 }
            'HKEY_CURRENT_CONFIG'   { $Key = 0x80000005 }
        }

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

        Write-Verbose -Message 'Opening registry with SET_VALUE permissions'

        $OpenKey = Open-RegistryKey -KeyType $KeyType -KeyPath $KeyType -Permission KEY_QUERY_VALUE

        Write-Verbose -Message 'Adding custom type RegGetValue'

        $Reg = Add-RegQueryValueExType

        $pdwType = ''
        [byte]$pvData
        [int]$pcbData
        
        Write-Verbose -Message 'Calling RegGetValue'
        Write-Verbose -Message "Key Type is $Key"
        $Result = $Reg::RegQueryValueEx( $OpenKey, $KeyPath, $null, $null, $pvData, $pcbData ) 
        if ($Result = 2) { $Error = 'File Not Found' }

        return $Result, $pvData, $pcbData
        $props = @{
            KeyType = $KeyType
            KeyPath = $KeyPath
            Result = $Result
            Type = $pdwType
            Data = $pvData
            PointerData = $pcbData
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