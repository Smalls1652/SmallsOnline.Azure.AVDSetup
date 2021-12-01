using System.Text.Json.Serialization;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public class ComputeGallery : IComputeGallery
    {
        public ComputeGallery() {}

        [JsonPropertyName("galleryResourceGroupName")]
        public string ResourceGroupName { get; set; }

        [JsonPropertyName("galleryName")]
        public string GalleryName { get; set; }

        [JsonPropertyName("galleryImageDefinitionName")]
        public string ImageDefinitionName { get; set; }

        [JsonPropertyName("galleryImageDefinitionVersion")]
        public string ImageDefinitionVersion { get; set; }

        public override string ToString()
        {
            return $"/{ResourceGroupName}/{GalleryName}/{ImageDefinitionName}/{ImageDefinitionVersion}";
        }
    }
}