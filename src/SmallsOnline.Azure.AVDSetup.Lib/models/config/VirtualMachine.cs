using System.Text.Json.Serialization;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public class VirtualMachine : IVirtualMachine
    {
        public VirtualMachine() {}

        [JsonPropertyName("vmSize")]
        public string Size { get; set; }

        [JsonPropertyName("vmLocation")]
        public string Location { get; set; }

        [JsonPropertyName("vmResourceGroupName")]
        public string ResourceGroupName { get; set; }

        [JsonPropertyName("vmHostNamePrefix")]
        public string HostNamePrefix { get; set; }

        public override string ToString()
        {
            return $"{ResourceGroupName} / {Location}";
        }
    }
}