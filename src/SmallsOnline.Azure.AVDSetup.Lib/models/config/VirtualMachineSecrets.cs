using System.Text.Json.Serialization;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public class VirtualMachineSecrets : IVirtualMachineSecrets
    {
        public VirtualMachineSecrets() {}

        [JsonPropertyName("localAdminAccount")]
        public SecretItem LocalAdminAccount { get; set; }

        [JsonPropertyName("domainJoinerAccount")]
        public SecretItem DomainJoinerAccount { get; set; }
    }
}