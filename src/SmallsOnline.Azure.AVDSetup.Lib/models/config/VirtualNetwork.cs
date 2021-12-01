using System.Text.Json.Serialization;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public class VirtualNetwork : IVirtualNetwork
    {
        public VirtualNetwork() {}

        [JsonPropertyName("vnetResourceGroupName")]
        public string ResourceGroupName { get; set; }

        [JsonPropertyName("vnetName")]
        public string Name { get; set; }

        [JsonPropertyName("vnetSubnetName")]
        public string SubnetName { get; set; }

        public override string ToString()
        {
            return $"/{ResourceGroupName}/{Name}/{SubnetName}";
        }
    }
}