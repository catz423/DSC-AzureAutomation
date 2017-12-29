

### Onboard On-Prem VM to Azure Automation DSC

# The DSC configuration that will generate metaconfigurations
[DscLocalConfigurationManager()]
Configuration DscMetaConfigs
{

    param
    (
        [Parameter(Mandatory=$True)]
        [String]$RegistrationUrl,

        [Parameter(Mandatory=$True)]
        [String]$RegistrationKey,

        [Parameter(Mandatory=$True)]
        [String[]]$ComputerName,

        [Int]$RefreshFrequencyMins = 30,

        [Int]$ConfigurationModeFrequencyMins = 15,

        [String]$ConfigurationMode = "ApplyAndMonitor",

        [String]$NodeConfigurationName,

        [Boolean]$RebootNodeIfNeeded= $False,

        [String]$ActionAfterReboot = "ContinueConfiguration",

        [Boolean]$AllowModuleOverwrite = $False,

        [Boolean]$ReportOnly
    )

    if(!$NodeConfigurationName -or $NodeConfigurationName -eq "")
    {
        $ConfigurationNames = $null
    }
    else
    {
        $ConfigurationNames = @($NodeConfigurationName)
    }

    if($ReportOnly)
    {
    $RefreshMode = "PUSH"
    }
    else
    {
    $RefreshMode = "PULL"
    }

    Node $ComputerName
    {

        Settings
        {
            RefreshFrequencyMins = $RefreshFrequencyMins
            RefreshMode = $RefreshMode
            ConfigurationMode = $ConfigurationMode
            AllowModuleOverwrite = $AllowModuleOverwrite
            RebootNodeIfNeeded = $RebootNodeIfNeeded
            ActionAfterReboot = $ActionAfterReboot
            ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins
        }

        if(!$ReportOnly)
        {
        ConfigurationRepositoryWeb AzureAutomationDSC
            {
                ServerUrl = $RegistrationUrl
                RegistrationKey = $RegistrationKey
                ConfigurationNames = $ConfigurationNames
            }

            ResourceRepositoryWeb AzureAutomationDSC
            {
            ServerUrl = $RegistrationUrl
            RegistrationKey = $RegistrationKey
            }
        }

        ReportServerWeb AzureAutomationDSC
        {
            ServerUrl = $RegistrationUrl
            RegistrationKey = $RegistrationKey
        }
    }
}

# Create the metaconfigurations
# TODO: edit the below as needed for your use case
$Params = @{
    RegistrationUrl = 'https://scus-agentservice-prod-1.azure-automation.net/accounts/ab34e2f6-07a3-4bec-8a22-4e351014c7bd';
    RegistrationKey = 'Ldi85cfGsUUIi4ZoivearrV74Rt5sJsYpur4rgf01U+fgcHsxbF4zYQX4vPM+c9pwZA3s76VzDmxXomwe7XXJA==';
    #ComputerName = @('<some VM to onboard>', '<some other VM to onboard>');
    #ComputerName = @('DC01');
    ComputerName = @($env:computername);
    NodeConfigurationName = 'FileResource.localhost';
    RefreshFrequencyMins = 30;
    ConfigurationModeFrequencyMins = 15;
    RebootNodeIfNeeded = $False;
    AllowModuleOverwrite = $False;
    ConfigurationMode = 'ApplyAndAutocorrect';
    ActionAfterReboot = 'ContinueConfiguration';
    ReportOnly = $False;  # Set to $True to have machines only report to AA DSC but not pull from it
}

# Use PowerShell splatting to pass parameters to the DSC configuration being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
DscMetaConfigs @Params

##Sleep for 5 seconds
Start-Sleep -s 5

#Run the DSC Configuration
Set-DscLocalConfigurationManager -Path ./DscMetaConfigs
