configuration BaseWebServerConfig
{
    param
    (
        # Target nodes to apply the configuration
        [string[]]$NodeName = 'localhost'
        
    )

    # Import the module that defines custom resources
    Import-DscResource -Module PSDesiredStateConfiguration

    Node $NodeName
    {
        # Install the IIS role
        WindowsFeature IIS
        {
            Ensure = 'Present'
            Name   = 'Web-Server'
        }

        # Install the .NET 4.5
        WindowsFeature Aspnet45
        {
            Ensure = 'Present'
            Name   = 'Web-Asp-Net45'
        }

        # Install the Remote Management Feature
        WindowsFeature WebMgmt
        {
            Ensure = 'Present'
            Name   = 'Web-Mgmt-Service'
        }

        #Update Registry for Remote IIS Management
        Registry RegistryRemoteIIS
        {
            Ensure      = "Present"  
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WebManagement\Server"
            ValueName   = "EnableRemoteManagement"
            ValueType   = "Dword"
            ValueData   = "1"
            Hex         = $true
            DependsOn   = "[WindowsFeature]WebMgmt"
        }

        #Set WMSVC Service for IIS Remote MGMT to Start Automatically
        Service RemoteIISMgmt
        {
            Name        = "WMSvc"
            StartupType = "Automatic"
            State       = "Running"
            DependsOn   = "[WindowsFeature]WebMgmt"
        } 
    }
}