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
function Add-RegSetKeyValueType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegLoad definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll", SetLastError=true)]
public static extern long RegSetKeyValue(int hKey, String lpSubKey, String lpValueName, int dwType, string lpData, int cbData);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "RegSetValueOfKey" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegLoad type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}