$template = "D:\VS CoDe\Project\netBridge\netBridge\netbridge.json"
$templatepara = "D:\VS CoDe\Project\netBridge\netBridge\netbridge.parameter.json"
$rg = 'pkp-rg'

New-AzResourceGroupDeployment `
-Name netbridgeDeploy `
-ResourceGroupName $rg `
-TemplateFile $template `
-TemplateParameterFile $templatepara -verbose


Remove-AzResourceGroup pkp-rg -Force

