$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'

Describe -Tags "Unit" "Add-RemoteRegLoadType" {

    It "returns a new system.runtimetype" {
        $reg = Add-RemoteRegLoadType
        $reg.GetType().FullName | Should Be "System.RuntimeType"
    }

    It "should have declared method of RegConnectRegistry" {
        $reg = Add-RemoteRegLoadType
        $reg.DeclaredMethods.Name | Should Be "RegConnectRegistry"
    }
}