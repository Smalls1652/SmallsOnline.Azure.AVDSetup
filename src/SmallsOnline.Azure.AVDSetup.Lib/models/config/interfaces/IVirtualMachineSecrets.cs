namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public interface IVirtualMachineSecrets
    {
        SecretItem LocalAdminAccount { get; set; }
        SecretItem DomainJoinerAccount { get; set; }
    }
}