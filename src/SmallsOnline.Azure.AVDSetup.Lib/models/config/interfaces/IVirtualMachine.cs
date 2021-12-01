namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public interface IVirtualMachine
    {
        string Size { get; set; }
        string Location { get; set; }
        string ResourceGroupName { get; set; }
        string HostNamePrefix { get; set; }
    }
}