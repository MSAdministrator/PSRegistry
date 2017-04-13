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
function Add-RemoteRegLoadType
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    Param()

    Write-Verbose -Message 'Adding RegConnectRegistry definition'
    
    try
    {
        $Definition = @"
[DllImport("advapi32.dll", SetLastError=true)]
public static extern long RegConnectRegistry(string lpMachineName, int hKey, String phkResult);
"@

        $Reg = Add-Type -MemberDefinition $Definition -Name "RegConnect" -Namespace "Win32Functions" -PassThru
    }
    catch
    {
        Write-LogEntry -type Error -message 'Error attempting to add RegLoad type' -thisError $($Error[0] | Format-List -Force)
    }
    
    return $Reg
}