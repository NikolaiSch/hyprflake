{
  lib,
  stylix,
  config,
  ...
}: {
  imports = [stylix.nixosModules.stylix];

  options = {
    systemColoring.wallpaperPath = lib.mkOption {
      description = "The path to the wallpaper image.";
      type = lib.types.path;
      default = null;
    };
  };

  config = lib.pathIsRegularFile config.systemColoring.wallpaperPath {
    home.file.".wallpaper/wallpaper.jpg".source = config.systemColoring.wallpaperPath;

    stylix = {
      enable = true;
      image = options.systemColoring.wallpaperPath;
      polarity = "dark";
    };
  };
}
