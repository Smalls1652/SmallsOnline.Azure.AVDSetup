namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public interface ISecretItem
    {
        string VaultName { get; set; }
        string Name { get; set; }
    }
}