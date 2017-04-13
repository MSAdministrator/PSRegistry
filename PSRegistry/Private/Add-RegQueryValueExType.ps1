<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Add-RegQueryValueExType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegQueryValueEx definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll",EntryPoint="RegQueryValueEx")]
public static extern int RegQueryValueEx_DllImport(IntPtr hKey,string lpValueName,int lpReserved,out uint lpType, IntPtr lpData,out uint lpcbData);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "QueryRegValueEx2" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegQueryValueEx type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}