
#https://docs.microsoft.com/en-us/powershell/module/azurerm.automation/register-azurermautomationdscnode?view=azurermps-4.4.1

#Registers an Azure VM to a DSC Configuration

$AutomationAccountName = "DanTest1"
$AutomationRGName = "DanTest1-AzureAuto"
$AzureVMRGName = "TFTest_MGMT_App_RG"
$AzureVMName = "TFTestVM0"
$AzureVMLocation = "SouthCentralUS"
$NodeConfiguration = "FileResource.locahost"
$ConfigurationMode = "ApplyAndAutocorrect" #ApplyAndMonitor is default

Register-AzureRmAutomationDscNode -AutomationAccountName $AutomationAccountName -AzureVMResourceGroup $AzureVMRGName -AzureVMName $AzureVMName -AzureVMLocation $AzureVMLocation -ResourceGroupName $AutomationRGName -NodeConfigurationName $NodeConfiguration -ConfigurationMode $ConfigurationMode
