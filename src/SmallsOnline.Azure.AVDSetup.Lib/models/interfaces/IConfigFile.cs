using SmallsOnline.Azure.AVDSetup.Lib.Models.Config;

namespace SmallsOnline.Azure.AVDSetup.Lib.Models
{
    public interface IConfigFile
    {
        VirtualMachine VMConfig { get; set; }
        VirtualNetwork VirtualNetworkConfig { get; set; }
        ComputeGallery GalleryConfig { get; set; }
        ActiveDirectory ActiveDirectoryConfig { get; set; }
        VirtualMachineSecrets VirtualMachineSecrets { get; set; }

        string ConvertToJson();
    }
}