$template = "D:\VS CoDe\Project\netBridge\netBridge\netbridge.json"
$templatepara = "D:\VS CoDe\Project\netBridge\netBridge\netbridge.parameter.json"
$rg = 'automate-rg'
$loc = 'eastasia'

New-AzResourceGroup -Name $rg -Location $loc
New-AzResourceGroupDeployment `
-Name netdeploy6 `
-ResourceGroupName $rg `
-TemplateFile $template `
-TemplateParameterFile $templatepara -verbose
