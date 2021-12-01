using System;
using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

using SmallsOnline.Azure.AVDSetup.Lib.Models.Config;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models
{
    public class ConfigFile : IConfigFile
    {
        public ConfigFile() { }

        public ConfigFile(string inputString, JsonInputType inputType)
        {
            ConfigFile _configFile = inputType switch
            {
                JsonInputType.FilePath => FromJsonFile(inputString),
                _ => FromJsonContents(inputString)
            };

            VMConfig = _configFile.VMConfig;
            VirtualNetworkConfig = _configFile.VirtualNetworkConfig;
            GalleryConfig = _configFile.GalleryConfig;
            ActiveDirectoryConfig = _configFile.ActiveDirectoryConfig;
            SecretItems = _configFile.SecretItems;
        }

        [JsonPropertyName("vmConfig")]
        public VirtualMachine VMConfig { get; set; }

        [JsonPropertyName("vnetConfig")]
        public VirtualNetwork VirtualNetworkConfig { get; set; }

        [JsonPropertyName("galleryConfig")]
        public ComputeGallery GalleryConfig { get; set; }

        [JsonPropertyName("adConfig")]
        public ActiveDirectory ActiveDirectoryConfig { get; set; }

        [JsonPropertyName("secretItems")]
        public SecretItem[] SecretItems { get; set; }

        private static readonly JsonSerializerOptions serializerOptions = new()
        {
            Converters = {
                new JsonStringEnumConverter(
                    namingPolicy: JsonNamingPolicy.CamelCase,
                    allowIntegerValues: false
                )
            }
        };

        public string ConvertToJson()
        {
            return JsonSerializer.Serialize(this, serializerOptions);
        }

        private static ConfigFile FromJsonContents(string jsonContents) => ConvertFromJson(jsonContents);

        private static ConfigFile FromJsonFile(string filePath)
        {
            string fileContents = ReadFileContents(filePath);

            return ConvertFromJson(fileContents);
        }

        private static ConfigFile ConvertFromJson(string jsonContents)
        {
            return JsonSerializer.Deserialize<ConfigFile>(jsonContents, serializerOptions);
        }

        private static string ReadFileContents(string filePath)
        {
            Task<string> taskReadFileContents = Task.Run(() => ReadFileContentsAsync(filePath));

            taskReadFileContents.Wait();

            return taskReadFileContents.Result;
        }

        private static async Task<string> ReadFileContentsAsync(string filePath)
        {
            using StreamReader streamReader = new(filePath);
            string fileContent = await streamReader.ReadToEndAsync();

            return fileContent;
        }
    }
}