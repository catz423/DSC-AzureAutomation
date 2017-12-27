configuration WebAppTestConfig
{
    param
    (
        # Target nodes to apply the configuration
        [string[]]$NodeName = 'localhost',
        # Name of the website to create
        #[Parameter(Mandatory)]
        #[ValidateNotNullOrEmpty()]
        [String]$WebSiteName = 'testsite',
        # Source Path for Website content
        #[Parameter(Mandatory)]
        #[ValidateNotNullOrEmpty()]
        [String]$SourcePath = '\\dc01\FileShare\Websites\testsite',
        # Destination path for Website content
        #[Parameter(Mandatory)]
        #[ValidateNotNullOrEmpty()]
        [String]$DestinationPath = 'C:\inetpub\wwwroot\testsite'
        
    )
    #ADD Credentials to connect to Source 
    $username = 'DANDOMAIN\svcDSCuser'
    $password = 'Password123'
    $spassword = $password | ConvertTo-SecureString -Force -AsPlainText

    $creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $spassword
    
    #Get Creds from Azure Asset Store
    #$creds = Get-AzureRmAutomationCredential -ResourceGroupName "ResourceGroup01" -AutomationAccountName "AutomationAcct" -Name "SomeCredentialAsset"
    

    # Import the module that defines custom resources
    Import-DscResource -Module xWebAdministration, PSDesiredStateConfiguration

    Node $NodeName
    {
        #Set IIS Defaults for Website(s)
        xWebSiteDefaults SiteDefaults
        {
           ApplyTo = 'Machine'
           LogFormat = 'IIS'
           AllowSubDirConfig = 'true'
        }

        xWebAppPoolDefaults PoolDefaults
        {
           ApplyTo = 'Machine'
           ManagedRuntimeVersion = 'v4.0'
           IdentityType = 'ApplicationPoolIdentity'
        }

        # Stop the default website
        xWebsite DefaultSite
        {
            Ensure          = "Present"
            Name            = "Default Web Site"
            State           = "Stopped"
            PhysicalPath    = "C:\inetpub\wwwroot"
        }
        
        # Copy the website content
        File WebContent
        {
            Ensure          = "Present"
            SourcePath      = $SourcePath
            DestinationPath = $DestinationPath
            Credential      = $creds
            Recurse         = $true
            Type            = "Directory"
        }

        # Create the new Website with HTTPS
        xWebsite NewWebsite
        {
            Ensure          = "Present"
            Name            = $WebSiteName
            State           = "Started"
            PhysicalPath    = $DestinationPath
            BindingInfo     = @(
                MSFT_xWebBindingInformation
                {
                    Protocol              = "HTTP"
                    Port                  = 80
                    #CertificateThumbprint = "71AD93562316F21F74606F1096B85D66289ED60F"
                    #CertificateStoreName  = "WebHosting"
                }
            )
            DependsOn       = "[File]WebContent"
        }

    }
}