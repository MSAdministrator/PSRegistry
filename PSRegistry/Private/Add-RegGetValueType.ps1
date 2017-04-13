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
function Add-RegGetValueType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegDeleteValue definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll", SetLastError=true)]
public static extern int RegGetValue(int hKey, string lpSubKey, string lpValue, int dwFlags, string pdwType, string pvData, string pcbData);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "GetRegValue" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegDeleteValue type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}