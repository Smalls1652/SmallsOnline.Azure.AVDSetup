using System.Text.Json.Serialization;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public class SecretItem : ISecretItem
    {
        public SecretItem() {}

        [JsonPropertyName("secretVaultName")]
        public string VaultName { get; set; }

        [JsonPropertyName("secretName")]
        public string Name { get; set; }

        public override string ToString()
        {
            return $"{VaultName}/{Name}";
        }
    }
}