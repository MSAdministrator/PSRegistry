$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'

Describe -Tags "Unit" "Add-RegUnLoadType" {

    It "returns a new system.runtimetype" {
        $reg = Add-RegUnLoadType
        $reg.GetType().FullName | Should Be "System.RuntimeType"
    }

    It "should have declared method of RegUnLoadKey" {
        $reg = Add-RegUnLoadType
        $reg.DeclaredMethods.Name | Should Be "RegUnLoadKey"
    }
}