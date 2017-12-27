
#https://docs.microsoft.com/en-us/powershell/module/azurerm.automation/register-azurermautomationdscnode?view=azurermps-4.4.1

#Registers an Azure VM to a DSC Configuration

$AutomationAccountName = "DanTest-Auto"
$AutomationRGName = "DanTest-Auto-RG"
$AzureVMRGName = "TFTest_RG_VMs"
$AzureVMName = "TFTestVM0"
$AzureVMLocation = "EastUS"
$NodeConfiguration = "FileResourceExample.locahost"

Register-AzureRmAutomationDscNode -AutomationAccountName $AutomationAccountName -AzureVMResourceGroup $AzureVMRGName -AzureVMName $AzureVMName -AzureVMLocation $AzureVMLocation -ResourceGroupName $AutomationRGName -NodeConfigurationName $NodeConfiguration
