# Templates and scripts for: Networking 

## Description
Set of templates and scripts provided for provisioning Networking Azure resources:
* 1 Network Security Group
* 1 Virtual Network
  * 1 Subnet
  * 1 Gateway subnet

## Content
* **execute-azuredeploy.Network.ps1** : main script
* **template.Network.json** : contains all the parameters to be filled in and used at each steps

## Usage (manual execution)

### Deployment steps
1. Download and extract all files locally
2. Start your preferred PowerShell tool (ISE, PowerShell console)
3. Change the current directory to the top folder containing **initProxy.ps1**
4. Run **initProxy.ps1** if executed from an AXA/ATS registered workstation 
5. Fill-in the **parameter.json** with your custom value
6. (optional) Add new resource instances into the templates **template.Network.json**
7. Change the current directory to the folder **1-Networking** related to the step to deploy
8. Run the **execute-azuredeploy.Network.ps1**

### Add more resource instances
To add more instances of a particular resource, follow the following exemple of a #2 instance of Network Security Group, whose index would be "nsg02" :
* Edit the **"parameters": {}** section in **parameter.json** file to add a "**nsg_02_index**" parameter:
> `"nsg_02_index": {"value": "nsg02"},`

* Edit the **"parameters": {}** section in **template.Network.json** file to add a "**nsg_02_index**" parameter:
> `"nsg_02_index": {"type": "string" },`

* Edit the **"variables": {}** section in **template.Network.json** file to add a "**nsg_02_name**" variable with a "**nsg_02_index**" parameter:
> `"nsg_02_name": "[concat('z-' , parameters('opco_code') , '-' , parameters('project_code') , '-' , parameters('app_code') , '-' , parameters('env_code') , '-' , parameters('corridor_code') , '-' , parameters('location_code') , '-' , parameters('nsg_02_index'))]",`

* Edit the **"resources": [{}]** section in **template.Network.json** file to add a Network Security Group instance named "**nsg_02_name**":
>        {
>            "type": "Microsoft.Network/networkSecurityGroups",
>            "name": "[variables('nsg_02_name')]",
>            "apiVersion": "2016-03-30",
>            "location": "[parameters('location_name')]",
>            "dependsOn": [],
>            "tags": {
>                ...
>            },
>            "properties": {
>                "securityRules": [
>                    {
>                        "name": "AllowInboundAllAzureMngmt",
>                        "properties": {
>                            ...
>                        }
>                    }
>                ]
>            }
>        },

* **Important** : make sure to take dependencies into account, in this case, the Network Security Group has to be attached to a new or existing Subnet. Therefore, the corresponding subnet should edited accordingly to update the "dependsOn" and "networkSecurityGroup"{"id"}" properties for "**nsg_02_name**" :
>        {
>            "type": "Microsoft.Network/virtualNetworks",
>            "name": "[variables('vnet_01_name')]",
>            "apiVersion": "2016-03-30",
>            "location": "[parameters('location_name')]",
>            "dependsOn": ["[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsg_02_name'))]"],
>            "tags": {
>                ...
>            },
>            "properties": {
>                ...
>                "subnets": [
>                    {
>                        "name": "[variables('subnet_01_name')]",
>                        "properties": {
>                            "addressPrefix": "[parameters('subnet_01_range')]",
>                            "networkSecurityGroup": {
>                                "id": "[resourceId('Microsoft.Network/networkSecurityGroups', variables('nsg_02_name'))]"
>                            }
>                        }
>                    },
>                    ...
>                ]
>            }
>        }
