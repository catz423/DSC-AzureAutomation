
Configuration FileResource
{
    Node "locahost"
    {
        File CreateFile {
            DestinationPath = 'C:\DanTest.txt'
            Ensure = "Present"
            Contents = 'This is only a test for DSC!!!'
        }
    }
    
}