using System.Text.Json.Serialization;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public class ActiveDirectory : IActiveDirectory
    {
        public ActiveDirectory() {}

        [JsonPropertyName("adDomainName")]
        public string DomainName { get; set; }

        [JsonPropertyName("adOrganizationalUnitPath")]
        public string OrganizationalUnitPath { get; set; }

        public override string ToString()
        {
            return DomainName;
        }
    }
}