################################
# EXECUSTION SCRIPT : NETWORKING
#	If executed from a local (AXA/ATS registered) machine or laptop, then :
#	- change the current directory to templates folder
#	- you may need to run "initProxy.ps1" prior to that (in order to configure proxy settings)
################################

###### PARAMETERS SECTION ######
# Param for template and parameters Files
$deploymentTemplatePath = ".\template.Network.json"
$deploymentTemplateParamsPath = "..\parameters.json"

# Get Parameters from parameter file
$json = (Get-Content $deploymentTemplateParamsPath) -join "`n" | ConvertFrom-Json

# Param for subscription
$SubscriptionId = $json.parameters.subscription_id.value

# Param for the location
$location = $json.parameters.location_name.value

# Param for ResourceGroup Name
$resourceGroupName = "z-" `
                    + $json.parameters.opco_code.value `
                    + "-tran-shrd-" `
                    + $json.parameters.env_code.value `
                    + "-" + $json.parameters.corridor_code.value `
                    + "-" + $json.parameters.location_code.value `
                    + "-" + $json.parameters.netResourceGroup_index.value

####### EXECUTION SECTION ######
# Execute the main script
. ..\0-Shared\deployARM.ps1 $subscriptionID $location $deploymentTemplatePath $deploymentTemplateParamsPath $resourceGroupName

######### END OF SCRIPT ########
