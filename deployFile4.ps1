$template = "D:\VS CoDe\Project\Insightscape\InsightScape\insightmain.json"
$templatepara = "D:\VS CoDe\Project\Insightscape\InsightScape\insightmain.parameter.json"
$rg = 'netbridge-rg'
$loc = 'eastasia'

New-AzResourceGroup -Name $rg -Location $loc
New-AzResourceGroupDeployment `
-Name netdeploy `
-ResourceGroupName $rg `
-TemplateFile $template `
-TemplateParameterFile $templatepara -verbose
