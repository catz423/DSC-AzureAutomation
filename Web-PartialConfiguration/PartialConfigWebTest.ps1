[DscLocalConfigurationManager()]
Configuration PartialConfigWebTest
{
    Node $env:computername
    {    
        
        Settings
        {
            RefreshFrequencyMins            = 30;
            RefreshMode                     = "PULL";
            ConfigurationMode               ="ApplyAndAutocorrect";
            AllowModuleOverwrite            = $true;
            RebootNodeIfNeeded              = $true;
            ConfigurationModeFrequencyMins  = 15;
        }
        ConfigurationRepositoryWeb AADSC-PullSrv
        {
            ServerURL                       = 'https://wcus-agentservice-prod-1.azure-automation.net/accounts/ec689ee9-18ee-4000-880c-0af1e950844a'    
            RegistrationKey                 = 'zu3LdeQLXNoDGxsKcRd0FjW4/dNgayZWvEUXKo7CpbMnYOBPtgirMIdOnUsW9uThUjBdqfgbUskotIDk/hX+mw=='     
            ConfigurationNames              = @("BaseWebServerConfig", "WebAppTestConfig")
        }     

        PartialConfiguration BaseWebServerConfig 
        {
            Description                     = "BaseWebServerConfig"
            ConfigurationSource             = @("[ConfigurationRepositoryWeb]AADSC-PullSrv") 
        }

        PartialConfiguration WebAppTestConfig
        {
            Description                     = "WebAppTestConfig"
            ConfigurationSource             = @("[ConfigurationRepositoryWeb]AADSC-PullSrv")
            DependsOn                       = '[PartialConfiguration]BaseWebServerConfig'
        }
    }
}
PartialConfigWebTest