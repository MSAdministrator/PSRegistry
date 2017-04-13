function Get-RegistryKeyValue
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateSet(
            'REG_NONE',
            'REG_SZ',
            'REG_EXPAND_SZ',
            'REG_BINARY',
            'REG_DWORD',
            'REG_DWORD_LITTLE_ENDIAN',
            'REG_DWORD_BIG_ENDIAN',
            'REG_LINK',
            'REG_MULTI_SZ',
            'REG_RESOURCE_LIST',
            'REG_FULL_RESOURCE_DESCRIPTOR',
            'REG_RESOURCE_REQUIREMENTS_LIST',
            'REG_QWORD_LITTLE_ENDIAN'
        )]
        $ValueType
    )

    switch ($ValueType)
    {
        'REG_NONE'                       { $Value = 0  }
        'REG_SZ'                         { $Value = 1  }
        'REG_EXPAND_SZ'                  { $Value = 2  }
        'REG_BINARY'                     { $Value = 3  }
        'REG_DWORD'                      { $Value = 4  }
        'REG_DWORD_LITTLE_ENDIAN'        { $Value = 4  }
        'REG_DWORD_BIG_ENDIAN'           { $Value = 5  }
        'REG_LINK'                       { $Value = 6  }
        'REG_MULTI_SZ'                   { $Value = 7  }
        'REG_RESOURCE_LIST'              { $Value = 8  }
        'REG_FULL_RESOURCE_DESCRIPTOR'   { $Value = 9  }
        'REG_RESOURCE_REQUIREMENTS_LIST' { $Value = 10 }
        'REG_QWORD_LITTLE_ENDIAN'        { $Value = 11 }
    }

    return [int]$Value
}