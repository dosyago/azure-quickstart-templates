---
description: This template allows you to deploy BrowserBox on an Ubuntu Server 22.04 LTS, Debian 11, or RHEL 8.7 LVM on Azure.
page_type: sample
products:
- azure
- azure-resource-manager
urlFragment: browserbox-ubuntu-vm
languages:
- json
---
# BrowserBox on Ubuntu Server 22.04 LTS, Debian 11, or RHEL 8.7 LVM

![Azure Public Test Date](https://azurequickstartsservice.blob.core.windows.net/badges/application-workloads/browserbox/browserbox-ubuntu-vm/PublicLastTestDate.svg)
![Azure Public Test Result](https://azurequickstartsservice.blob.core.windows.net/badges/application-workloads/browserbox/browserbox-ubuntu-vm/PublicDeployment.svg)

![Azure US Gov Last Test Date](https://azurequickstartsservice.blob.core.windows.net/badges/application-workloads/browserbox/browserbox-ubuntu-vm/FairfaxLastTestDate.svg)
![Azure US Gov Last Test Result](https://azurequickstartsservice.blob.core.windows.net/badges/application-workloads/browserbox/browserbox-ubuntu-vm/FairfaxDeployment.svg)

![Best Practice Check](https://azurequickstartsservice.blob.core.windows.net/badges/application-workloads/browserbox/browserbox-ubuntu-vm/BestPracticeResult.svg)
![Cred Scan Check](https://azurequickstartsservice.blob.core.windows.net/badges/application-workloads/browserbox/browserbox-ubuntu-vm/CredScanResult.svg)

[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fdosyago%2Fazure-quickstart-templates%2Fadd-browserbox%2Fapplication-workloads%2Fdosyago%2Fbrowserbox%2Fazuredeploy.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2Fdosyago%2Fazure-quickstart-templates%2Fadd-browserbox%2Fapplication-workloads%2Fdosyago%2Fbrowserbox%2FcreateUiDefinition.json)
[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fdosyago%2Fazure-quickstart-templates%2Fadd-browserbox%2Fbrowserbox-ubuntu-vm%2Fazuredeploy.json)

This template deploys BrowserBox, a secure browsing environment, on an Ubuntu Server 22.04 LTS, Debian 11, or RHEL 8.7 LVM on Azure. 

## Features
- Seamless deployment of BrowserBox on Azure.
- Compatible with multiple Linux distributions: Ubuntu 22.04 LTS, Debian 11, RHEL 8.7 LVM.
- Customizable settings to suit different requirements.

## Prerequisites
- A valid Azure subscription.
- Familiarity with Azure Resource Manager templates.

## Deployment Steps
1. Click on the "Deploy to Azure" button.
2. Fill in the required parameters (Admin Username, DNS Name, etc.).
3. Review and agree to the terms and conditions.
4. Click on "Create" to initiate the deployment.

## Post-Deployment Steps
- Ensure necessary firewall ports (tcp:8078-8082) are open.
- Configure a DNS A record pointing to the public IP of the deployed VM.

## License
This template is provided under standard [license terms](https://link-to-license).

`Tags: Microsoft.Network/publicIPAddresses, Microsoft.Network/networkSecurityGroups, Microsoft.Network/virtualNetworks, Microsoft.Network/networkInterfaces, Microsoft.Compute/virtualMachines, Microsoft.Compute/virtualMachines/extensions, CustomScriptExtension`

