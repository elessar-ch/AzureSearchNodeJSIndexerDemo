param (
    [Parameter(Position=1, Mandatory=$true)]  
    [string]
	$subscriptionID,
    
    [Parameter(Position=2, Mandatory=$true)]    
	[string]
	$location,
    
    [Parameter(Position=3, Mandatory=$true)]    
	[string]
	$deploymentTemplatePath,

	[Parameter(Position=4, Mandatory=$true)]    
	[string]
	$deploymentTemplateParamsPath,

	[Parameter(Position=5, Mandatory=$true)]    
	[string]
	$resourceGroupName
)

$ErrorActionPreference = "Stop"

$Date = Get-Date -Format "yyyyMMdd-HHmmss"

# Sign in
Write-Host "Logging in..."
Login-AzureRmAccount

# Select subscription
Write-Host "Selecting subscription '$subscriptionID'"
Select-AzureRmSubscription -SubscriptionID $subscriptionID

# Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup) {
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location."
    if(!$location) {
        $location = Read-Host "location"
    }
    Write-Host "Creating resource group '$resourceGroupName' in location '$location'"
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
} else {
	Write-Host "Using existing resource group '$resourceGroupName'"
}

# Start the deployment
try {
	$resourceGroupDeploymentName = $resourceGroupName + "_" + $date
	Write-Host "Deployment of ARM template: $deploymentTemplatePath with parameters: $deploymentTemplateParamsPath"
	Write-Host "Deployment name : $resourceGroupDeploymentName"
	Write-Host "Starting deployment..."
	New-AzureRmResourceGroupDeployment `
		-Name $resourceGroupDeploymentName `
		-ResourceGroupName $resourceGroupName `
		-TemplateFile $deploymentTemplatePath `
		-TemplateParameterFile $deploymentTemplateParamsPath `
		-Verbose
} catch {
	Write-Error "/!\ Something went wrong while deploying /!\"
    Write-Error $_.Exception
}
