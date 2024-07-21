$template = "D:\VS CoDe\Project\netBridge\netBridge\netbridge.json"
$templatepara = "D:\VS CoDe\Project\netBridge\netBridge\netbridge.parameter.json"
$rg = 'netbridge-rg'
$loc= 'eastasia'

New-AzResourceGroup -Name $rg -Location $loc

New-AzResourceGroupDeployment `
-Name netbridgeDeploy `
-ResourceGroupName $rg `
-TemplateFile $template `
-TemplateParameterFile $templatepara -verbose

