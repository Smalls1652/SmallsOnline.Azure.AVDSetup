namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public interface IVirtualNetwork
    {
        string ResourceGroupName { get; set; }
        string Name { get; set; }
        string SubnetName { get; set; }
    }
}