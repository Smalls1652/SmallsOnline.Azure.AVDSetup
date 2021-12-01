namespace SmallsOnline.Azure.AVDSetup.Lib.Models.Config
{
    public interface IComputeGallery
    {
        string ResourceGroupName { get; set; }
        string GalleryName { get; set; }
        string ImageDefinitionName { get; set; }
        string ImageDefinitionVersion { get; set; }
    }
}