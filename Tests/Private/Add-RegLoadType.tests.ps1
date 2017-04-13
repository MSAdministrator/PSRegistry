$here = Split-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -Parent

$module = 'PSRegistry'

Describe -Tags "Unit" "Add-RegLoadType" {

    It "returns a new system.runtimetype" {
        $reg = Add-RegLoadType
        $reg.GetType().FullName | Should Be "System.RuntimeType"
    }

    It "should have declared method of RegLoadKey" {
        $reg = Add-RegLoadType
        $reg.DeclaredMethods.Name | Should Be "RegLoadKey"
    }
}