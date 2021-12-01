namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public interface IActiveDirectory
    {
        string DomainName { get; set; }
        string OrganizationalUnitPath { get; set; }
    }
}