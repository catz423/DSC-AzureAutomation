
## Oboarding via AzureRM Powershell

# Define the parameters for Get-AzureRmAutomationDscOnboardingMetaconfig using PowerShell Splatting
$Params = @{
    
        ResourceGroupName = 'DanTest-Auto-RG'; # The name of the ARM Resource Group that contains your Azure Automation Account
        AutomationAccountName = 'DanTest-Auto'; # The name of the Azure Automation Account where you want a node on-boarded to
        ComputerName = @('dc01', 'core201601'); # The names of the computers that the meta configuration will be generated for
        OutputFolder = "$env:UserProfile\Desktop\";
    }
    # Use PowerShell splatting to pass parameters to the Azure Automation cmdlet being invoked
    # For more info about splatting, run: Get-Help -Name about_Splatting
    Get-AzureRmAutomationDscOnboardingMetaconfig @Params

