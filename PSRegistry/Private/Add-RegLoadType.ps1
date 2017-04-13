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
function Add-RegLoadType
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
public static extern long RegLoadKey(int hKey, String lpSubKey, String lpFile);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "RegLoad" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegLoad type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}